import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/DataModels/BuyLidPaymentDatamodel.dart';
import 'package:flutter_app/DataModels/SendLidDataModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/enterpin_bloc.dart';
import 'widgets/transactionDetailsRow.dart';

class EnterPinScreen extends StatefulWidget {
  final int
      isFrom; // 1. Buy 2. Cashout 3. From paypal  4. send Lid 5. from send to wallet paypal
  final String lidQuantity;
  final String walletAddress;
  final String note;
  final BuyLidPaymentModel paymentData;
  final String payableAmount;
  final SendLidDataModel sendLidData;

  final String paymentId; // calling api after paypal
  final String token;
  final String payerId;
  final String pin;
  const EnterPinScreen({
    Key key,
    this.isFrom = 1,
    this.lidQuantity,
    this.paymentData,
    this.walletAddress,
    this.note,
    this.payableAmount,
    this.sendLidData,
    this.paymentId,
    this.token,
    this.payerId,
    this.pin,
  }) : super(key: key);
  @override
  _EnterPinScreenState createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final TextEditingController controller1 = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  final TextEditingController controller3 = new TextEditingController();
  final TextEditingController controller4 = new TextEditingController();
  final TextEditingController controller5 = new TextEditingController();
  final TextEditingController controller6 = new TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();

  final ValueNotifier<int> showGlow = ValueNotifier<int>(0);
  String enteredPin = "";
  String pinErrorMsg = "Please Enter 6 digit PIN";

  bool isPinError = false;

  String tokenId = "";
  String walletId = "";

  EnterpinBloc enterPinBloc = EnterpinBloc();

  ToastUtil toastUtil = ToastUtil();

  ScreenUtil screenUtil = ScreenUtil();

  Service service = Service();
  Map<String, dynamic> resData;

  @override
  void initState() {
    super.initState();
    getBasicInfo();

    if (widget.isFrom == 3 || widget.isFrom == 5) {
      Future.delayed(Duration(milliseconds: 200), () {
        getPaymentResponse(widget.isFrom);
      });
    }
  }

  // 3. Buy Lid 5. Send Lid to wallet
  void getPaymentResponse(int from) {
    try {
      HelperUtil.showLoaderDialog(context);
      service
          .executePaymentService(
              paymentId: "${widget.paymentId}",
              token: "G${widget.token}",
              payerId: "${widget.payerId}")
          .then((resObj) {
        resData = resObj;
        Navigator.pop(context);

        if (resData["code"].toString() == "200") {
          if (from == 3) {
            showPaymentSuccessAlert(0);
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);

              Future.delayed(Duration(milliseconds: 500), () {
                transactionSuccessMsg(
                  1,
                  date: widget
                      .paymentData.result.transactionReceipt.createdAtDate
                      .toString(),
                  time: widget
                      .paymentData.result.transactionReceipt.createdAtTime
                      .toString(),
                  totalAmount: widget
                      .paymentData.result.transactionReceipt.amount
                      .toString(),
                  lidQuantity: widget.paymentData.result.transactionReceipt.lid
                      .toString(),
                  transId: widget
                      .paymentData.result.transactionReceipt.transactionId
                      .toString(),
                );
              });
            });
          } else {
            sendLidService();
          }
        } else {
          ToastUtil().showMsg("${resData["message"]}", Colors.black,
              Colors.white, 12.0, "short", "bottom");
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void sendLidService() {
    SendLidDataModel resData;
    HelperUtil.showLoaderDialog(context);
    service
        .sendLidToWalletService(
            note: widget.note,
            walletAddress: widget.walletAddress,
            pin: widget.pin,
            lidQuantity: widget.lidQuantity)
        .then((resObj) {
      resData = resObj;
      Navigator.pop(context);
      if (resData.code.toString() == "200") {
        showPaymentSuccessAlert(1);

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 500), () {
            transactionSuccessMsg(
              2,
              date: resData.result.createdAtDate,
              time: resData.result.createdAtTime,
              lidQuantity: resData.result.lid.toString(),
              transId: resData.result.sId,
              toUserWalletAddress:
                  widget.walletAddress, //widget.sendLidData.result.toUser,
            );
          });
        });
      } else {
        toastUtil.showMsg(resData.message, Colors.black, Colors.white, 12.0,
            "short", "bottom");
      }
    });
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenId = prefs.getString("token") ?? '';
      walletId = prefs.getString("walletId") ?? "";
    });
  }

  @override
  void dispose() {
    showGlow?.dispose();
    enterPinBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnterpinBloc, EnterpinState>(
      cubit: enterPinBloc,
      buildWhen: (prevState, state) {
        if (state is EnterpinInitial) {
          return false;
        }

        if (state is ProceedPaymentState) {
          Navigator.pop(context);
          if (state.isNetworkConnected == true &&
              state.resData.code.toString() == "200") {
            Map<String, dynamic> data = {
              "url": state.resData.result.data.redirectLink,
              "id": Uri.parse(state.resData.result.data.redirectLink)
                  .queryParameters['token'],
              "paymentDate": state.resData,
              "from": 0,
              "pin": "",
              "lidQuantity": "",
              "walletAddress": "",
              "note": "",
            };
            Navigator.of(context).pushNamed(RouteConst.routePaypalWebView,
                arguments: {'data': data});
          } else if (state.isNetworkConnected == false) {
            toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                Colors.white, 12.0, "short", "bottom");
          } else {
            toastUtil.showMsg(state.resData.message, Colors.black, Colors.white,
                12.0, "short", "bottom");
          }
          return false;
        }

        if (state is SendLidToWalletState) {
          Navigator.pop(context);
          if (state.isNetworkConnected == true &&
              state.resData.code.toString() == "200") {
            Map<String, dynamic> data = {
              "url": state.resData.result.url,
              "id":
                  Uri.parse(state.resData.result.url).queryParameters['token'],
              "from": 1,
              "pin": "$enteredPin",
              "lidQuantity": "${widget.lidQuantity}",
              "walletAddress": "${widget.walletAddress}",
              "note": "${widget.note}",
            };

            Navigator.of(context).pushNamed(RouteConst.routePaypalWebView,
                arguments: {'data': data});
          } else if (state.isNetworkConnected == false) {
            toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                Colors.white, 12.0, "short", "bottom");
          } else {
            toastUtil.showMsg(state.resData.message, Colors.black, Colors.white,
                12.0, "short", "bottom");
          }
          return false;
        }

        if (state is CashoutState) {
          Navigator.pop(context);
          if (state.isNetworkConnected == true &&
              state.resData.code.toString() == "200") {
            var totalAmount =
                double.parse(state.resData.result.cashoutLidQuantity) *
                    Global.lidValue.value;

            cashoutSuccessfulAlert(
              date: state.resData.result.createdAtDate,
              time: state.resData.result.createdAtTime,
              transId: state.resData.result.transactionId,
              cashoutLidQuantity:
                  state.resData.result.cashoutLidQuantity.toString(),
              currentLidQuantity:
                  state.resData.result.currentLidQuantity.toString(),
              amount: "$totalAmount",
            );
          } else if (state.isNetworkConnected == false) {
            toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                Colors.white, 12.0, "short", "bottom");
          } else {
            toastUtil.showMsg(state.resData.message, Colors.black, Colors.white,
                12.0, "short", "bottom");
          }
          return false;
        }
        return false;
      },
      builder: (context, state) {
        if (state is EnterpinLoadedState) {
          return WillPopScope(
            onWillPop: () async {
              if (widget.isFrom == 1) {
                Map<String, dynamic> data = {"selectedIndex": 1};
                Navigator.of(context).pushReplacementNamed(
                    RouteConst.routeMainDashboard,
                    arguments: {"data": data});
              } else {
                Navigator.pop(context);
              }
              return true;
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                backgroundColor: kBackgroundColor2,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
                  child: HelperUtil.commonAppbar(
                    context: context,
                    title: "", //widget.isFrom != 3 ? "Require PIN" : "",
                    onTap: () {
                      if (widget.isFrom == 1) {
                        Map<String, dynamic> data = {"selectedIndex": 1};
                        Navigator.of(context).pushReplacementNamed(
                            RouteConst.routeMainDashboard,
                            arguments: {"data": data});
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: HelperUtil.backgroundGradient(),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenUtil.setWidth(18.0),
                        right: screenUtil.setWidth(18.0),
                        top: screenUtil.setHeight(24.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: screenUtil.setHeight(18.0),
                            ),
                            child: Text(
                              "Enter PIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: screenUtil.setSp(15.0),
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: screenUtil.setHeight(5.0)),
                            height: screenUtil.setHeight(80),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: isPinError
                                    ? Colors.red
                                    : kTextColor6.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: enterPinWidget(),
                          ),
                          if (isPinError)
                            Container(
                              padding: EdgeInsets.only(
                                  top: screenUtil.setHeight(8.0),
                                  left: screenUtil.setWidth(12.0)),
                              child: Text(
                                pinErrorMsg,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.red,
                                    fontSize: screenUtil.setSp(14.0),
                                    fontFamily: "Poppins"),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenUtil.setHeight(30)), //  252
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      RouteConst.routeForgotPinScreen);
                                },
                                child: Text(
                                  "Forgot PIN?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: kTextColor5,
                                      fontSize: screenUtil.setSp(16),
                                      fontFamily: "Poppins"),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenUtil.setHeight(152.0)),
                          HelperUtil.glowButtonWithText(
                            showGlow: showGlow,
                            value: 1,
                            onTap: () {
                              showGlow.value = 1;
                              Future.delayed(Duration(milliseconds: 500), () {
                                HelperUtil.checkInternetConnection()
                                    .then((internet) {
                                  if (internet) {
                                    showGlow.value = 0;
                                    validatePin(1);
                                  } else {
                                    showGlow.value = 0;
                                    toastUtil.showMsg(
                                        Constant.noInternetMsg,
                                        Colors.black,
                                        Colors.white,
                                        12.0,
                                        "short",
                                        "bottom");
                                  }
                                });
                              });
                            },
                            btnText: (widget.isFrom == 1 || widget.isFrom == 3)
                                ? "PROCEED TO PAY"
                                : "CONTINUE",
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
            appBar: AppBar(),
          );
        }
      },
    );
  }

  Widget enterPinWidget() {
    return Container(
      child: Row(
        children: [
          pinTextFiled(controller1, focusNode1, focusNode2, null, 1),
          verticalSeparator(),
          pinTextFiled(controller2, focusNode2, focusNode3, focusNode1, 1),
          verticalSeparator(),
          pinTextFiled(controller3, focusNode3, focusNode4, focusNode2, 1),
          verticalSeparator(),
          pinTextFiled(controller4, focusNode4, focusNode5, focusNode3, 1),
          verticalSeparator(),
          pinTextFiled(controller5, focusNode5, focusNode6, focusNode4, 1),
          verticalSeparator(),
          pinTextFiled(controller6, focusNode6, null, focusNode5, 1),
        ],
      ),
    );
  }

  Widget verticalSeparator() {
    return Container(
      width: 1,
      margin: EdgeInsets.only(
        top: screenUtil.setHeight(15.0),
        bottom: screenUtil.setHeight(15.0),
      ),
      decoration: BoxDecoration(
        color: kSeparatorColor1,
      ),
    );
  }

  Widget pinTextFiled(TextEditingController controller, FocusNode currentFnode,
      FocusNode nextFnode, FocusNode prevFnode, int from) {
    return Expanded(
      child: Center(
        child: TextFormField(
          onTap: () {},
          enableInteractiveSelection: false,
          controller: controller,
          cursorColor: kTextColor3,
          maxLength: 1,
          readOnly: (from == 2 && enteredPin.length != 6) ? true : false,
          obscureText: true,
          textAlign: TextAlign.center,
          focusNode: currentFnode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (text) {
            if (nextFnode != null && controller.text != "") {
              nextFnode.requestFocus();
            } else if (controller.text == "") {
              if (prevFnode != null) prevFnode.requestFocus();
            } else {
              FocusScope.of(context).requestFocus(new FocusNode());
              validatePin(2);
            }
          },
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: screenUtil.setSp(20),
            fontWeight: FontWeight.w600,
            color: kTextColor3,
          ),
          decoration: InputDecoration(
            hintText: "-",
            counterText: "",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: screenUtil.setSp(16.0),
              color: kTextColor7,
            ),
          ),
        ),
      ),
    );
  }

  void validatePin(int from) {
    enteredPin = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text +
        controller5.text +
        controller6.text;

    setState(() {
      if (enteredPin.length != 6) {
        isPinError = true;
      } else {
        isPinError = false;
        // 1. Proceed to pay function call on click on button   2. call validation onchange on textfield
        if (from == 1) {
          // Buy Lid Payment
          if (widget.isFrom == 1) {
            HelperUtil.showLoaderDialog(context);
            enterPinBloc.add(ProceedPaymentEvent(
                pin: enteredPin, lidQuantity: widget.lidQuantity));
          } else if (widget.isFrom == 4) {
            HelperUtil.showLoaderDialog(context);

            enterPinBloc.add(SendLidToAnotherWalletEvent(
              pin: enteredPin,
              lidQuantity: widget.lidQuantity,
              note: widget.note,
              walletAddress: widget.walletAddress,
            ));
          } else if (widget.isFrom == 2) {
            // payment screen
            HelperUtil.showLoaderDialog(context);
            enterPinBloc.add(CashoutEvent(
              lidQuantity: widget.lidQuantity,
              pin: enteredPin,
            ));
          } else {
            // cashoutSuccessfulAlert();
          }
        }
      }
    });
  }

  // from 1. buy lid success   from 2. send lid to wallet
  void transactionSuccessMsg(
    int from, {
    String date,
    String time,
    String transId,
    String lidQuantity,
    String totalAmount,
    String toUserWalletAddress,
  }) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
            // Navigator.pop(context);
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenUtil.setWidth(339),
              margin: EdgeInsets.only(
                top: screenUtil.setHeight(95),
                left: screenUtil.setWidth(18),
                right: screenUtil.setWidth(18),
                bottom: screenUtil.setHeight(95),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(colors: [
                    kBackgroundColor2,
                    kBackgroundColor,
                  ], begin: Alignment(-1, -4), end: Alignment(1, 4)),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: screenUtil.setHeight(22)),
                        child: SvgPicture.asset(
                          ImageConst.successImg,
                          width: screenUtil.setWidth(46),
                          height: screenUtil.setHeight(46),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenUtil.setHeight(17)),
                        child: Text(
                          from == 1
                              ? "Your transaction was successful!"
                              : "Your Lid was sent successfully!",
                          style: TextStyle(
                              color: kGradientColor6,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(16.0),
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: screenUtil.setHeight(35),
                            left: screenUtil.setWidth(10),
                            right: screenUtil.setWidth(10)),
                        child: Column(
                          children: [
                            transactionDeatilsRow("Date", "$date", screenUtil),
                            transactionDeatilsRow("Time", "$time", screenUtil),
                            transactionDeatilsRow(
                                "Transaction ID", "$transId", screenUtil),
                            transactionDeatilsRow(
                                "Lid Quantity", "$lidQuantity", screenUtil),
                            if (from == 1)
                              transactionDeatilsRow(
                                  "Total Amount", "$totalAmount", screenUtil),
                          ],
                        ),
                      ),
                      Container(
                        width: screenUtil.setWidth(295),
                        margin: EdgeInsets.only(top: screenUtil.setHeight(23)),
                        child: Text(
                          "A certificate of your gold will be sent to your registered email.",
                          style: TextStyle(
                              color: kTextColor2,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(14.0),
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenUtil.setWidth(9.5),
                            vertical: screenUtil.setHeight(14.0)),
                        child: Center(
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final boxWidth = constraints.constrainWidth();
                              final dashWidth = 5.0;
                              final dashHeight = 1.2;
                              final dashCount =
                                  (boxWidth / (2 * dashWidth)).floor();
                              return Flex(
                                children: List.generate(dashCount, (_) {
                                  return SizedBox(
                                    width: dashWidth,
                                    height: dashHeight,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: kTextColor3),
                                    ),
                                  );
                                }),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                direction: Axis.horizontal,
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: screenUtil.setHeight(5),
                        ),
                        width: screenUtil.setWidth(320),
                        decoration: BoxDecoration(
                          color: kTextColor6,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenUtil.setHeight(8),
                              horizontal: screenUtil.setWidth(34)),
                          child: Text(
                            from == 1
                                ? "$lidQuantity Lid for \$$totalAmount ${double.parse(lidQuantity) <= 1.0 ? "has" : "have"} been added to your wallet!"
                                : "$lidQuantity Lid ${double.parse(lidQuantity) <= 1.0 ? "has" : "have"} been successfully sent to Wallet Address ($toUserWalletAddress)",
                            style: TextStyle(
                                color: kAppbarColor,
                                fontFamily: "Poppins",
                                fontSize: screenUtil.setSp(14.0),
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteConst.routeMainDashboard);
                        },
                        child: Container(
                          height: screenUtil.setHeight(58),
                          width: screenUtil.setWidth(190),
                          margin: EdgeInsets.symmetric(
                              vertical: screenUtil.setHeight(18)),
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
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 0),
                                  blurRadius: 15.0)
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "GO TO HOME",
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
                  ),
                ),
              ),
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

  void cashoutSuccessfulAlert(
      {String date,
      String time,
      String transId,
      String cashoutLidQuantity,
      String currentLidQuantity,
      String amount}) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenUtil.setWidth(339),
              height: screenUtil.setHeight(600),
              margin: EdgeInsets.only(
                top: screenUtil.setHeight(70),
                left: screenUtil.setWidth(18),
                right: screenUtil.setWidth(18),
                bottom: screenUtil.setHeight(70),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    kBackgroundColor2,
                    kBackgroundColor,
                  ], begin: Alignment(-1, -4), end: Alignment(1, 4)),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: screenUtil.setHeight(42)),
                        child: Text(
                          "Congratulations!",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(24.0),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: screenUtil.setHeight(35),
                            left: screenUtil.setWidth(10),
                            right: screenUtil.setWidth(10)),
                        child: Column(
                          children: [
                            transactionDeatilsRow("Date", "$date", screenUtil),
                            transactionDeatilsRow("Time", "$time", screenUtil),
                            transactionDeatilsRow(
                                "Transaction ID", "$transId", screenUtil),
                            transactionDeatilsRow("Sold Lid Quantity",
                                "$cashoutLidQuantity", screenUtil),
                            transactionDeatilsRow("Current Lid Quantity",
                                "$currentLidQuantity", screenUtil),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenUtil.setWidth(9.5),
                            vertical: screenUtil.setHeight(14.0)),
                        child: Center(
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final boxWidth = constraints.constrainWidth();
                              final dashWidth = 5.0;
                              final dashHeight = 1.2;
                              final dashCount =
                                  (boxWidth / (2 * dashWidth)).floor();
                              return Flex(
                                children: List.generate(dashCount, (_) {
                                  return SizedBox(
                                    width: dashWidth,
                                    height: dashHeight,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: kTextColor3),
                                    ),
                                  );
                                }),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                direction: Axis.horizontal,
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: screenUtil.setHeight(5),
                        ),
                        width: screenUtil.setWidth(320),
                        decoration: BoxDecoration(
                          color: kTextColor6,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenUtil.setHeight(8),
                              horizontal: screenUtil.setWidth(12)),
                          child: Text(
                            "$cashoutLidQuantity ${double.parse(cashoutLidQuantity) <= 1.0 ? "Lid" : "Lids"} in the amount of \$$amount have been sold. This amount has been successfully transferred from Wallet Address ($walletId) to linked bank account",
                            style: TextStyle(
                                color: kAppbarColor,
                                fontFamily: "Poppins",
                                fontSize: screenUtil.setSp(14.0),
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteConst.routeMainDashboard);
                        },
                        child: Container(
                          height: screenUtil.setHeight(58),
                          width: screenUtil.setWidth(190),
                          margin: EdgeInsets.symmetric(
                              vertical: screenUtil.setHeight(33)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: Colors.white,
                            border: Border.all(
                              width: 6,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                kTextColor3,
                                kGradientColor6,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 0),
                                  blurRadius: 15.0)
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "GO TO HOME",
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
                  ),
                ),
              ),
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

  void showPaymentSuccessAlert(int from) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenUtil.setWidth(339),
              height: screenUtil.setHeight(189),
              child: Container(
                decoration: BoxDecoration(
                  color: kAppbarColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 0),
                        blurRadius: 15),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          ImageConst.successImg,
                          width: screenUtil.setWidth(56),
                          height: screenUtil.setHeight(59),
                        ),
                      ),
                      Container(
                        child: Text(
                          "THANK YOU",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(24.0),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          from == 0
                              ? "Payment is successful and you will receive the balance shortly"
                              : "Transaction is successful",
                          style: TextStyle(
                              color: kTextColor3,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(16.0),
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
}
