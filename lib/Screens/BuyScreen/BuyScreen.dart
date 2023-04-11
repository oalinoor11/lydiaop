import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/ErrorWidgetUtil.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/NoInternetAlertUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/ValidatorUtil.dart';
import 'package:flutter_app/Utils/goldRateCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/getTextfieldStye.dart';
import 'Widgets/payableAmountWidget.dart';
import 'bloc/buyscreen_bloc.dart';

class BuyScreen extends StatefulWidget {
  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  BuyscreenBloc buyBloc = BuyscreenBloc();

  List<String> quantityArray = ["5", "10", "25", "50", "100"];

  final ValueNotifier<String> selQuantity = ValueNotifier<String>("");
  final ValueNotifier<double> payableAmount = ValueNotifier<double>(0.00);
  final ValueNotifier<int> showGlow = ValueNotifier<int>(0);

  bool buttonPressed = false;

  ScreenUtil screenUtil = ScreenUtil();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool alreadyLogin = false;
  bool isNetworkConnected = true;
  var _connectivitySubscription;
  ConnectivityResult previousConRes;

  final TextEditingController amountController = new TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final amountKey = GlobalKey<FormFieldState>();

  String refreshToken = "";
  String lastSavedDate = "";

  AppLifecycleState curretAppState;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    curretAppState = AppLifecycleState.resumed;
    getBasicInfo();
    onNetworkChange();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      refreshToken = prefs.getString("refreshToken") ?? "";

      Global.buyScreenTimer = Timer.periodic(
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
    buyBloc.add(GetGoldRateEvent(alreadyLogin));
  }

  @override
  void dispose() {
    Global.buyScreenTimer?.cancel();
    buyBloc.close();
    selQuantity?.dispose();
    payableAmount?.dispose();
    showGlow?.dispose();
    _connectivitySubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

     @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      Global.buyScreenTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      Global.buyScreenTimer = Timer.periodic(
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
            buyBloc.add(GetGoldRateEvent(alreadyLogin));
          } else {
            isNetworkConnected = true;
            buyBloc.add(GetGoldRateEvent(alreadyLogin));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyscreenBloc, BuyscreenState>(
      cubit: buyBloc,
      builder: (context, state) {
        if (state is BuyscreenLoadingState) {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            body: HelperUtil.loadingStateWidget(),
          );
        } else if (state is BuyscreenLoadedState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              body: state.isNetworkConnected == false
                  ? NoInternetAlertScreen(
                      isFullScreen: false,
                      onTap: retryInternet,
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: HelperUtil.backgroundGradient(),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          onRefresh: () {
                            buyBloc.add(GetGoldRateEvent(alreadyLogin));
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: screenUtil.setHeight(6),
                                ),
                                if (state.resData != null &&
                                    state.resData.result != null)
                                  Container(
                                    height: screenUtil.setHeight(80),
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
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return goldRateCard(screenUtil);
                                        // return buyLeadGoldRateCard(
                                        //     state, screenUtil);
                                      },
                                    ),
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0,
                                          bottom: 6.0,
                                          top: screenUtil.setHeight(18)),
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
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: TextFormField(
                                        onTap: () {},
                                        key: amountKey,
                                        enableInteractiveSelection: false,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        //keyboardType: TextInputType.number,
                                        focusNode: amountFocusNode,
                                        controller: amountController,
                                        cursorColor: kTextColor5,
                                        validator:
                                            ValidatorUtil().validateLidAmount,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                          //DecimalTextInputFormatter()
                                          // WhitelistingTextInputFormatter
                                          //     .digitsOnly,
                                        ],
                                        onChanged: (text) {
                                          selQuantity.value = text;
                                          // payableAmount.value = text == ""
                                          //     ? 0.0
                                          //     : state.goldPerGram *
                                          //         double.parse(
                                          //             selQuantity.value);

                                          payableAmount.value = text == ""
                                              ? 0.0
                                              : state.goldPerGram * ( 1 + Constant.buyFee + Constant.creditFee) *
                                                  double.parse(
                                                      selQuantity.value);
                                          amountKey.currentState.validate();
                                        },
                                        style: getTextStyle(),
                                        decoration: inPutDecoration(
                                            "Enter Lid Quantity", screenUtil),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: screenUtil.setWidth(36),
                                          right: 5.0,
                                          top: screenUtil.setHeight(16)),
                                      height: screenUtil.setHeight(30.0),
                                      child: ValueListenableBuilder(
                                        builder: (BuildContext context,
                                            String seletecdQuantity,
                                            Widget child) {
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: quantityArray.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selQuantity.value =
                                                        quantityArray[index];
                                                    amountController.text =
                                                        selQuantity.value;
                                                    amountKey.currentState
                                                        .validate();
                                                    payableAmount.value = state
                                                            .goldPerGram * ( 1 + Constant.buyFee + Constant.creditFee) *
                                                        double.parse(
                                                            selQuantity.value);
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            new FocusNode());
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  height: screenUtil
                                                      .setHeight(30.0),
                                                  width:
                                                      screenUtil.setWidth(45.0),
                                                  decoration: BoxDecoration(
                                                      color: double.parse(
                                                                  quantityArray[
                                                                      index]) ==
                                                              double.parse((selQuantity
                                                                              .value !=
                                                                          null &&
                                                                      selQuantity
                                                                              .value !=
                                                                          "")
                                                                  ? selQuantity
                                                                      .value
                                                                  : "0")
                                                          ? kTextColor5
                                                          : null,
                                                      border: Border.all(
                                                        width: 1,
                                                        color: kTextColor5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0)),
                                                  child: Center(
                                                    child: Text(
                                                      quantityArray[index],
                                                      style: TextStyle(
                                                          color: double.parse(
                                                                      quantityArray[
                                                                          index]) ==
                                                                  double.parse((selQuantity.value !=
                                                                              null &&
                                                                          selQuantity.value !=
                                                                              "")
                                                                      ? selQuantity
                                                                          .value
                                                                      : "0")
                                                              ? Colors.white
                                                              : kTextColor5,
                                                          fontSize: screenUtil
                                                              .setSp(10.0),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "Poppins"),
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
                                  builder: (context, double payAmount, child) {
                                    return payableAmountWidget(
                                        payAmount, screenUtil, alreadyLogin);
                                  },
                                  valueListenable: payableAmount,
                                ),
                                SizedBox(
                                  height: alreadyLogin == true
                                      ? screenUtil.setHeight(8)
                                      : screenUtil.setHeight(16),
                                ),
                                HelperUtil.glowButtonWithText(
                                  showGlow: showGlow,
                                  value: 1,
                                  onTap: () {
                                    if (!buttonPressed) {
                                      buttonPressed = true;
                                      showGlow.value = 1;
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        HelperUtil.checkInternetConnection()
                                            .then((internet) {
                                          if (internet) {
                                            if (alreadyLogin) {
                                              if (!amountKey.currentState
                                                  .validate()) {
                                                buttonPressed = false;
                                                showGlow.value = 0;
                                                amountFocusNode.requestFocus();
                                              } else {
                                                showGlow.value = 0;
                                                buttonPressed = false;
                                                Map<String, dynamic> data = {
                                                  "lidQuantity":
                                                      selQuantity.value,
                                                  "isFrom": 1,
                                                  "payableAmount":
                                                      " ${payableAmount.value}"
                                                };
                                                Global.buyScreenTimer?.cancel();
                                                Navigator.of(context).pushNamed(
                                                    RouteConst
                                                        .routeEnterPinScreen,
                                                    arguments: {"data": data});
                                              }
                                            } else {
                                              showGlow.value = 0;
                                              buttonPressed = false;
                                              Global.buyScreenTimer?.cancel();

                                              Map<String, dynamic> data = {
                                                "from": 5
                                              };
                                              Navigator.of(context).pushNamed(
                                                  RouteConst.routeLoginPage,
                                                  arguments: {'data': data});
                                            }
                                          } else {
                                            ToastUtil().showMsg(
                                                Constant.noInternetMsg,
                                                Colors.black,
                                                Colors.white,
                                                12.0,
                                                "short",
                                                "bottom");
                                          }
                                        });
                                      });
                                    }
                                  },
                                  btnText: "BUY",
                                ),
                              ],
                            ),
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

  void retryInternet() {
    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
        buyBloc.add(GetGoldRateEvent(alreadyLogin));
      } else {
        isNetworkConnected = false;
        ToastUtil().showMsg(Constant.noInternetMsg, Colors.black, Colors.white,
            12.0, "short", "bottom");
      }
    });
  }
}
