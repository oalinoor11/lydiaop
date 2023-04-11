import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/ValidatorUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPinScreen extends StatefulWidget {
  @override
  _ForgotPinScreenState createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final TextEditingController emailController = new TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final emailKey = GlobalKey<FormFieldState>();

  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();

  Map<String, dynamic> resData = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenUtil.setHeight(58.0)),
                    child: HelperUtil.backButton(
                      context: context,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenUtil.setWidth(18.0),
                      right: screenUtil.setWidth(18.0),
                      top: screenUtil.setHeight(38.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "FORGOT PIN",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: screenUtil.setSp(24.0),
                                fontFamily: "Poppins"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: screenUtil.setHeight(5.0),
                          ),
                          child: Text(
                            "Don't panic... We are here for you!",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: kTextColor2,
                                fontSize: screenUtil.setSp(16.0),
                                fontFamily: "Poppins"),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        // Email Textfield
                        Container(
                          margin: EdgeInsets.only(
                            top: screenUtil.setHeight(85),
                          ),
                          child: TextFormField(
                            onTap: () {},
                            key: emailKey,
                            focusNode: emailFocusNode,
                            controller: emailController,
                            cursorColor: kTextColor5,
                            keyboardType: TextInputType.emailAddress,
                            validator: ValidatorUtil().validateEmailId,
                            onChanged: (text) {
                              emailKey.currentState.validate();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[  ]')),
                              FilteringTextInputFormatter.deny(RegExp(
                                  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                            ],
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: kTextColor3,
                            ),
                            decoration: InputDecoration(
                              focusColor: kTextColor5,
                              filled: true,
                              hintText: "Enter Email",
                              counterText: "",
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 0.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27)),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 0.5,
                                    style: BorderStyle.solid),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27)),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1.0,
                                    style: BorderStyle.solid),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27)),
                                borderSide: BorderSide(
                                    color: kTextColor5,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: screenUtil.setSp(16.0),
                                  color: kTextColor7),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(
                            top: screenUtil.setHeight(10.0),
                          ),
                          child: Text(
                            "Enter the email associated with your account and we will send a link to reset your security PIN.",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: kTextColor2,
                                fontSize: screenUtil.setSp(16.0),
                                fontFamily: "Poppins"),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                            right: screenUtil.setWidth(20.0),
                            left: screenUtil.setWidth(20.0),
                            top: screenUtil.setHeight(65.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (!emailKey.currentState.validate()) {
                                emailFocusNode.requestFocus();
                              } else {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                HelperUtil.checkInternetConnection()
                                    .then((internet) {
                                  if (internet) {
                                    forgotPinServiceCall(context);
                                  } else {
                                    toastUtil.showMsg(
                                        Constant.noInternetMsg,
                                        Colors.black,
                                        Colors.white,
                                        12.0,
                                        "short",
                                        "bottom");
                                  }
                                });
                              }
                            },
                            child: HelperUtil.buttonWithGradientColor(
                                context: context, text: "SEND"),
                          ),
                        ),
                        /*
                        Container(
                          padding: EdgeInsets.only(
                            top: screenUtil.setHeight(30.0),
                          ),
                          child: Center(
                            child: Text(
                              "Or",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor2,
                                  fontSize: screenUtil.setSp(16.0),
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(
                            top: screenUtil.setHeight(18.0),
                          ),
                          child: Center(
                            child: Text(
                              "Social login can save your time.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor4,
                                  fontSize: screenUtil.setSp(13.0),
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: screenUtil.setHeight(13.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: screenUtil.setHeight(44),
                                width: screenUtil.setWidth(44),
                                decoration: BoxDecoration(
                                  color: kBackgroundColor7,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kshadowColor2,
                                      offset: Offset(-5, -5),
                                      blurRadius: 15.0,
                                    )
                                  ],
                                ),
                                child: Image.asset(
                                  ImageConst.googleImg,
                                  width: screenUtil.setWidth(44),
                                  height: screenUtil.setHeight(44),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: screenUtil.setHeight(36.0),
                          ),
                          child: Center(
                            child: Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor4,
                                  fontSize: screenUtil.setSp(13.0),
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(
                            top: screenUtil.setHeight(8.0),
                          ),
                          child: FlatButton(
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: kTextColor5,
                                    fontSize: screenUtil.setSp(16.0),
                                    fontFamily: "Poppins"),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onPressed: () {
                              HelperUtil.checkInternetConnection()
                                  .then((internet) {
                                if (internet) {
                                  Map<String, dynamic> data = {"from": 2};
                                  Navigator.of(context).pushReplacementNamed(
                                      RouteConst.routeLoginPage,
                                      arguments: {'data': data});
                                } else {
                                  toastUtil.showMsg(
                                      Constant.noInternetMsg,
                                      Colors.black,
                                      Colors.white,
                                      12.0,
                                      "short",
                                      "bottom");
                                }
                              });
                            },
                          ),
                        ),
                        */
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  forgotPinServiceCall(context) async {
    await HelperUtil.checkInternetConnection().then((internet) async {
      if (internet != null && internet) {
        HelperUtil.showLoaderDialog(context);
        await Service()
            .forgotPinService(email: emailController.text)
            .then((respObj) {
          resData = respObj;

          

          if (resData['code'].toString() == "200") {
            Navigator.pop(context);
            toastUtil.showMsg("${resData['result']['message']}", Colors.black,
                Colors.white, 12.0, "short", "bottom");
            Map<String, dynamic> data = {"emailAddess": emailController.text};
            Navigator.of(context).pushNamed(RouteConst.routeVerifyEmailScreen,
                arguments: {'data': data});
          } else {
            Navigator.pop(context);
            toastUtil.showMsg("${resData['message']}", Colors.black,
                Colors.white, 12.0, "short", "bottom");
          }
        });
      } else {
        toastUtil.showMsg(Constant.noInternetMsg, Colors.black, Colors.white,
            12.0, "short", "bottom");
      }
    });
  }
}
