import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/SendLid.dart/widgets/textStyle.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/ValidatorUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/sendLidAppbar.dart';

class SendLidScreen extends StatefulWidget {
  final String lidQuantity;
  final String walletAddress;
  final String note;

  const SendLidScreen(
      {Key key, this.lidQuantity = "", this.walletAddress = "", this.note = ""})
      : super(key: key);
  @override
  _SendLidScreenState createState() => _SendLidScreenState();
}

class _SendLidScreenState extends State<SendLidScreen> {
  ScreenUtil screenUtil = ScreenUtil();
  final TextEditingController amountController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController noteController = new TextEditingController();

  final ValueNotifier<double> totalAmount = ValueNotifier<double>(0.00);

  final FocusNode amountFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();

  final amountKey = GlobalKey<FormFieldState>();
  final addressKey = GlobalKey<FormFieldState>();  final noteKey = GlobalKey<FormFieldState>();

  ToastUtil toastUtil = ToastUtil();
  String walletAddress = "";
  final ValueNotifier<int> showGlow = ValueNotifier<int>(0);
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    getBasicInfo();
    amountController.text = widget.lidQuantity;
    addressController.text = widget.walletAddress;
    noteController.text = widget.note;
  }

  @override
  void dispose() {
    buttonPressed = false;
    totalAmount?.dispose();
    showGlow?.dispose();
    super.dispose();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      walletAddress = prefs.getString("walletId") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenUtil.setHeight(172)), //220
          child: sendLidAppBar(context, screenUtil, walletAddress)),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: HelperUtil.backgroundGradient(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              width: double.infinity,
              child: Form(
                autovalidate: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        left: screenUtil.setWidth(18),
                        right: screenUtil.setWidth(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: screenUtil.setHeight(24),
                            ),
                            child: textfieldLabel(
                                "Enter Lid Quantity", screenUtil),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: TextFormField(
                                    onTap: () {},
                                    key: amountKey,
                                    //keyboardType: TextInputType.number,
                                    focusNode: amountFocusNode,
                                    controller: amountController,
                                    cursorColor: kTextColor5,
                                    validator:
                                        ValidatorUtil().validateLidAmount,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                      //DecimalTextInputFormatter()
                                    ],
                                    onChanged: (text) {
                                      totalAmount.value = text == ""
                                          ? 0.00
                                          : Global.lidValue.value *
                                              double.parse(text);
                                      amountKey.currentState.validate();
                                    },
                                    style: getTextStyle(),
                                    decoration: inPutDecoration(
                                        "Enter Lid Quantity",
                                        1,
                                        context,
                                        screenUtil),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: ValueListenableBuilder(
                                    valueListenable: totalAmount,
                                    builder: (context, value, widget) {
                                      return Text(
                                        "Lid value \$ ${value.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: kTextColor14,
                                          fontSize: screenUtil.setSp(15),
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(24),
                                  ),
                                  child: textfieldLabel(
                                      "Wallet Address", screenUtil),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: TextFormField(
                                    onTap: () {},
                                    key: addressKey,
                                    focusNode: addressFocusNode,
                                    controller: addressController,
                                    cursorColor: kTextColor5,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    // keyboardType: TextInputType.text,
                                    validator:
                                        ValidatorUtil().validateWalletAddess,
                                    onChanged: (text) {
                                      addressKey.currentState.validate();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r"\s\s")),
                                      FilteringTextInputFormatter.deny(RegExp(
                                          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                    ],
                                    style: getTextStyle(),
                                    decoration: inPutDecoration(
                                        "Wallet Address",
                                        2,
                                        context,
                                        screenUtil, onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());

                                      Map<String, dynamic> data = {
                                        "lidQuantity": amountController.text,
                                        "walletAddress": addressController.text,
                                        "note": noteController.text,
                                      };

                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        Navigator.of(context).pushNamed(
                                            RouteConst.routeScanQRCodeScreen,
                                            arguments: {'data': data});
                                      });
                                    }),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(24),
                                  ),
                                  child: textfieldLabel("Note", screenUtil),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: TextFormField(
                                    onTap: () {},
                                    maxLines: 2,
                                    key: noteKey,
                                    focusNode: noteFocusNode,
                                    validator: ValidatorUtil().validateNote,
                                    controller: noteController,
                                    cursorColor: kTextColor5,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    onChanged: (text) {
                                      noteKey.currentState.validate();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(
                                          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                    ],
                                    style: getTextStyle(),
                                    decoration: inPutDecoration(
                                        "Note", 3, context, screenUtil),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenUtil.setHeight(20)),
                    HelperUtil.glowButtonWithText(
                      showGlow: showGlow,
                      value: 1,
                      onTap: () {
                        if (!buttonPressed) {
                          showGlow.value = 1;
                          buttonPressed = true;

                          Future.delayed(Duration(milliseconds: 500), () {
                            if (!amountKey.currentState.validate()) {
                              showGlow.value = 0;
                              buttonPressed = false;
                              amountFocusNode.requestFocus();
                            } else if (!addressKey.currentState.validate()) {
                              showGlow.value = 0;
                              buttonPressed = false;
                              addressFocusNode.requestFocus();
                            } else if (!noteKey.currentState.validate()) {
                              showGlow.value = 0;
                              buttonPressed = false;
                              noteFocusNode.requestFocus();
                            } else {
                              if (double.parse(amountController.text) >
                                  double.parse(
                                      Global.availableLidCount.value)) {
                                showGlow.value = 0;
                                buttonPressed = false;
                                toastUtil.showMsg(
                                    "Insufficient balance of Lid to transfer",
                                    Colors.black,
                                    Colors.white,
                                    12.0,
                                    "short",
                                    "bottom");
                              } else {
                                showGlow.value = 0;
                                buttonPressed = false;
                                Map<String, dynamic> data = {
                                  "lidQuantity": amountController.text,
                                  "isFrom": 4,
                                  "walletAddress": addressController.text,
                                  "note": noteController.text
                                };
                                Navigator.of(context).pushNamed(
                                    RouteConst.routeEnterPinScreen,
                                    arguments: {"data": data});
                              }
                            }
                          });
                        }
                      },
                      btnText: "SEND",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
