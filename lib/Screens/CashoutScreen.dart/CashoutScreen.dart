import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/CashoutScreen.dart/widgets/noInvestementWidget.dart';
import 'package:flutter_app/Utils/ErrorWidgetUtil.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/NoInternetAlertUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/ValidatorUtil.dart';
import 'package:flutter_app/Utils/goldRateCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/cashout_bloc.dart';
import 'widgets/getTextStyle.dart';

class CashoutScreen extends StatefulWidget {
  @override
  _CashoutScreenState createState() => _CashoutScreenState();
}

class _CashoutScreenState extends State<CashoutScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CashoutBloc cashoutBloc = CashoutBloc();
  List<String> quantityArray = ["5", "10", "25", "50", "100"];
  final ValueNotifier<String> selQuantity = ValueNotifier<String>("");

  String walletAddress = "";

  final ValueNotifier<double> withDrawalAmount = ValueNotifier<double>(0.00);
  final ValueNotifier<int> showGlow = ValueNotifier<int>(0);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isWithdrawalWidget = false;
  bool alreadyLogin = false;
  bool buttonPressed = false;

  // enter amount textfield
  final TextEditingController amountController = new TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final amountKey = GlobalKey<FormFieldState>();

  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();

  bool isNetworkConnected = true;

  var _connectivitySubscription;
  ConnectivityResult previousConRes;

  String refreshToken = "";
  String lastSavedDate = "";

  AppLifecycleState curretAppState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    curretAppState = AppLifecycleState.resumed;
    onNetworkChange();
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      isWithdrawalWidget = prefs.getString("cashout") == "true" ? true : false;
      walletAddress = prefs.getString("walletId") ?? "";
      refreshToken = prefs.getString("refreshToken") ?? "";

      Global.cashoutScreenTimer = Timer.periodic(
          Duration(seconds: 10), (Timer t) => updateGoldValue(alreadyLogin));
    });
    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
      } else {
        isNetworkConnected = false;
      }
    });

    if (alreadyLogin == true && lastSavedDate != null && lastSavedDate != "") {
      final savedDate =
          DateFormat('yyyy-MM-dd').parse(lastSavedDate.toString());

      final currentDate =
          DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
      var dayDifference = currentDate.difference(savedDate).inDays;

      if (dayDifference > 0) {
        HelperUtil().refreshToken(refreshToken);
      }
    } else if (alreadyLogin == true) {
      HelperUtil().refreshToken(refreshToken);
    }
    cashoutBloc.add(GetGoldRateEvent(alreadyLogin));
  }

  @override
  void dispose() {
    cashoutBloc.close();
    selQuantity?.dispose();
    withDrawalAmount?.dispose();
    showGlow?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    Global.cashoutScreenTimer?.cancel();
    super.dispose();
  }

   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      Global.cashoutScreenTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      Global.cashoutScreenTimer = Timer.periodic(
          Duration(seconds: 10), (Timer t) => updateGoldValue(alreadyLogin));
    }
  }

  void onNetworkChange() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      ConnectivityResult currentConRes = result;
      if (currentConRes != previousConRes) {
        previousConRes = currentConRes;
        setState(() {
          if (result == ConnectivityResult.none) {
            isNetworkConnected = false;
            cashoutBloc.add(GetGoldRateEvent(alreadyLogin));
          } else {
            isNetworkConnected = true;
            cashoutBloc.add(GetGoldRateEvent(alreadyLogin));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashoutBloc, CashoutState>(
      cubit: cashoutBloc,
      builder: (context, state) {
        if (state is CashoutLoadingState) {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            body: HelperUtil.loadingStateWidget(),
          );
        } else if (state is CashoutLoadedState) {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            body: state.isNetworkConnected == false
                ? NoInternetAlertScreen(
                    isFullScreen: false,
                    onTap: retryInternet,
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: HelperUtil.backgroundGradient(),
                      child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        onRefresh: () {
                          cashoutBloc.add(GetGoldRateEvent(alreadyLogin));
                        },
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: screenUtil.setHeight(6),
                              ),
                              if (state.resData != null &&
                                  state.resData.result != null)
                                Container(
                                  margin: EdgeInsets.only(
                                    left: screenUtil.setWidth(5),
                                    right: screenUtil.setWidth(5),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    image: new DecorationImage(
                                      image: new ExactAssetImage(
                                          ImageConst.goldRateCashoutBgImg),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  height: screenUtil.setHeight(80),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return goldRateCard(screenUtil);
                                      // return cashoutGoldRateCard(state, false,
                                      //     walletAddress, screenUtil);
                                    },
                                  ),
                                ),
                              isWithdrawalWidget
                                  ? investmentWidget(state)
                                  : startInvestmentWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        } else {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            body: isNetworkConnected == false
                ? NoInternetAlertScreen(
                    isFullScreen: false,
                    onTap: retryInternet,
                  )
                : ErrorWidgetScreen(
                    isFullScreen: false,
                    onTap: retryInternet,
                  ),
          );
        }
      },
    );
  }

  Widget investmentWidget(CashoutLoadedState state) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, bottom: 8.0, top: screenUtil.setHeight(17)),
              child: Text(
                "Enter Lid Quantity",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenUtil.setSp(15.0),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                onTap: () {},
                key: amountKey,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //keyboardType: TextInputType.number,
                focusNode: amountFocusNode,
                controller: amountController,
                cursorColor: kTextColor5,
                validator: ValidatorUtil().validateLidAmount,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                  //DecimalTextInputFormatter()
                ],
                onChanged: (text) {
                  selQuantity.value = text;
                  withDrawalAmount.value = text == ""
                      ? 0.00
                      : Global.lidValue.value * double.parse(text);
                  amountKey.currentState.validate();
                },
                style: getTextStyle(),
                decoration: inPutDecoration("Enter Lid Quantity", screenUtil),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: screenUtil.setWidth(36),
                  right: 5.0,
                  top: screenUtil.setHeight(16)),
              height: screenUtil.setHeight(30.0),
              child: ValueListenableBuilder(
                builder: (BuildContext context, String seletecdQuantity,
                    Widget child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: quantityArray.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selQuantity.value = quantityArray[index];
                            amountController.text = selQuantity.value;
                            amountKey.currentState.validate();
                            withDrawalAmount.value = Global.lidValue.value *
                                double.parse(quantityArray[index]);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height: screenUtil.setHeight(30.0),
                          width: screenUtil.setWidth(45.0),
                          decoration: BoxDecoration(
                              color: double.parse(quantityArray[index]) ==
                                      double.parse((selQuantity.value != null &&
                                              selQuantity.value != "")
                                          ? selQuantity.value
                                          : "0")
                                  ? kTextColor5
                                  : null,
                              border: Border.all(
                                width: 1,
                                color: kTextColor5,
                              ),
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Center(
                            child: Text(
                              quantityArray[index],
                              style: TextStyle(
                                  color: double.parse(quantityArray[index]) ==
                                          double.parse(
                                              (selQuantity.value != null &&
                                                      selQuantity.value != "")
                                                  ? selQuantity.value
                                                  : "0")
                                      ? Colors.white
                                      : kTextColor5,
                                  fontSize: screenUtil.setSp(10.0),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                valueListenable: selQuantity,
              ),
            )
          ],
        ),
        ValueListenableBuilder(
          builder: (BuildContext context, double amount, Widget child) {
            return Padding(
              padding: EdgeInsets.only(top: screenUtil.setHeight(27.0)),
              child: Column(
                children: [
                  Text(
                    "Withdrawal Amount",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenUtil.setSp(15),
                        fontFamily: "Poppins"),
                  ),
                  Text(
                    "\$${amount.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: kTextColor16,
                        fontSize: screenUtil.setSp(48),
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
            );
          },
          valueListenable: withDrawalAmount,
        ),
        HelperUtil.glowButtonWithText(
          showGlow: showGlow,
          value: 2,
          onTap: () {
            if (!buttonPressed) {
              buttonPressed = true;
              showGlow.value = 2;
              Future.delayed(Duration(milliseconds: 500), () {
                if (!amountKey.currentState.validate()) {
                  showGlow.value = 0;
                  buttonPressed = false;
                  amountFocusNode.requestFocus();
                } else if ((double.parse(amountController.text) >
                    double.parse(Global.availableLidCount.value))) {
                  showGlow.value = 0;
                  buttonPressed = false;
                  toastUtil.showMsg("Insufficient balance of Lid to sell",
                      Colors.black, Colors.white, 12.0, "short", "bottom");
                } else if (alreadyLogin) {
                  showGlow.value = 0;
                  buttonPressed = false;
                  cashoutAlert();

                  // toastUtil.showMsg(
                  //     "Coming soon, \nwe are waiting for approval from PayPal site.",
                  //     Colors.black,
                  //     Colors.white,
                  //     12.0,
                  //     "short",
                  //     "bottom");
                } else {
                  Global.cashoutScreenTimer?.cancel();
                  showGlow.value = 0;
                  buttonPressed = false;
                  Navigator.of(context).pushNamed(RouteConst.routeLoginPage);
                }
                // }
              });
            }
          },
          btnText: "SELL",
        ),
      ],
    );
  }

  Widget startInvestmentWidget() {
    return Column(
      children: [
        SizedBox(
          height: alreadyLogin == true
              ? screenUtil.setHeight(50)
              : screenUtil.setHeight(80),
        ),
        noInvestmentWidget(screenUtil),
        SizedBox(
          height: alreadyLogin == true
              ? screenUtil.setHeight(50)
              : screenUtil.setHeight(90),
        ),
        HelperUtil.glowButtonWithText(
          showGlow: showGlow,
          value: 1,
          onTap: () {
            if (!buttonPressed) {
              buttonPressed = true;
              showGlow.value = 1;
              Future.delayed(Duration(milliseconds: 500), () {
                Map<String, dynamic> data = {"selectedIndex": 1};
                Global.cashoutScreenTimer?.cancel();
                Navigator.of(context).pushNamed(RouteConst.routeMainDashboard,
                    arguments: {"data": data});
              });
            }
            // if (!buttonPressed) {
            //   buttonPressed = true;
            //   showGlow.value = 1;
            //   Future.delayed(Duration(milliseconds: 500), () {
            //     if (alreadyLogin) {
            //       buttonPressed = false;
            //       showGlow.value = 0;

            //       toastUtil.showMsg(
            //           "Coming soon, \nwe are waiting for approval from PayPal site.",
            //           //    "Please make some investment before you try to sell Lid.",
            //           Colors.black,
            //           Colors.white,
            //           12.0,
            //           "short",
            //           "bottom");
            //     } else {
            //       Global.cashoutScreenTimer.cancel();
            //       showGlow.value = 0;
            //       buttonPressed = false;
            //       Navigator.of(context).pushNamed(RouteConst.routeLoginPage);
            //     }
            //   });
            // }
          },
          btnText: "START INVESTING",
        ),
      ],
    );
  }

  void cashoutAlert() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: screenUtil.setWidth(339),
            height: screenUtil.setHeight(194),
            child: Container(
              decoration: BoxDecoration(
                color: kBackgroundColor9,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 0),
                      blurRadius: 15),
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Are you sure you want to sell ${selQuantity.value} Lid from your wallet?",
                        style: TextStyle(
                            color: kTextColor3,
                            fontFamily: "Poppins",
                            fontSize: screenUtil.setSp(16.0),
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: screenUtil.setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Map<String, dynamic> data = {
                              "lidQuantity": selQuantity.value,
                              "isFrom": 2,
                            };
                            Global.cashoutScreenTimer?.cancel();
                            Navigator.of(context).pushNamed(
                                RouteConst.routeEnterPinScreen,
                                arguments: {"data": data});
                          },
                          child: Container(
                            height: screenUtil.setHeight(60),
                            width: screenUtil.setWidth(155),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              gradient: LinearGradient(colors: [
                                kGradientColor3,
                                kGradientColor4,
                              ]),
                              border: Border.all(
                                width: 6,
                                color: kBackgroundColor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 0),
                                    blurRadius: 15.0)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "YES, SELL!",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: kTextColor,
                                    fontSize: screenUtil.setSp(16.0)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: screenUtil.setHeight(60),
                            width: screenUtil.setWidth(155),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                width: 6,
                              ),
                              gradient: LinearGradient(colors: [
                                kTextColor3,
                                kGradientColor6,
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 0),
                                    blurRadius: 15.0)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: kTextColor8,
                                  fontSize: screenUtil.setSp(16.0),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: screenUtil.screenHeight / 2 -
                    (screenUtil.setHeight(194) / 2)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  void retryInternet() {
    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
        cashoutBloc.add(GetGoldRateEvent(alreadyLogin));
      } else {
        isNetworkConnected = false;
        toastUtil.showMsg(Constant.noInternetMsg, Colors.black, Colors.white,
            12.0, "short", "bottom");
      }
    });
  }
}
