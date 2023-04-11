import 'dart:io';
import 'dart:ui';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/SharedPreferenceUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'bloc/loginscreen_bloc.dart';

import 'widgets/signinButtonWidget.dart';

class LoginScreen extends StatefulWidget {
  final int
      from; // 1. from logout // 2. from forgot pin // 3. session expired  // 4. from home screen  //5. from buy screen  6. from trade 7.cashout

  const LoginScreen({Key key, this.from}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginscreenBloc loginBloc = LoginscreenBloc();

  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();
  SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();

  bool isAvailAble = false;

  @override
  void initState() {
    if (Platform.isIOS) {
      checkIsAvailable();
    }
    super.initState();
  }

  Future<void> checkIsAvailable() async {
    isAvailAble = await AppleSignIn.isAvailable();
    setState(() {});
  }

  @override
  void dispose() {
    loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginscreenBloc, LoginscreenState>(
        cubit: loginBloc,
        // ignore: missing_return
        buildWhen: (prevState, state) {
          if (state is LoginscreenInitial) {
            return false;
          }
          if (state is GoogleLoginState) {
            Navigator.pop(context);
            if (state.isNetworkConnected == true &&
                state.resData.code.toString() == "200") {
              if (state.resData.result.userData.pin.toString() == "true") {
                _sharedPreference.addSharedPref("isAppleLogin", "false");
                _sharedPreference.addSharedPref('alreadyLogin', "true");
                Navigator.of(context).pushNamed(RouteConst.routeMainDashboard);
              } else {
                Navigator.of(context).pushNamed(RouteConst.routeSetPinScreen);
              }
            } else if (state.isNetworkConnected == false) {
              toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            } else {
              toastUtil.showMsg(state.resData.message, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
            return false;
          }

          if (state is AppleLoginState) {
            Navigator.pop(context);
            if (state.isNetworkConnected == true &&
                state.resData.code.toString() == "200") {
              if (state.resData.result.userData.pin.toString() == "true") {
                _sharedPreference.addSharedPref("isAppleLogin", "true");
                _sharedPreference.addSharedPref('alreadyLogin', "true");
                Navigator.of(context).pushNamed(RouteConst.routeMainDashboard);
              } else {
                Navigator.of(context).pushNamed(RouteConst.routeSetPinScreen);
              }
            } else if (state.isNetworkConnected == false) {
              toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            } else {
              toastUtil.showMsg(state.resData.message, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
            return false;
          }
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is LoginscreenLoadedState) {
            return WillPopScope(
              // ignore: missing_return
              onWillPop: () {
                handleBack();
              },
              child: Scaffold(
                backgroundColor: kBackgroundColor2,
                body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageConst.noInternetBgImg),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: screenUtil.setHeight(58),
                        ),
                        child: HelperUtil.backButton(
                          context: context,
                          onTap: () {
                            handleBack();
                          },
                        ),
                      ),
                    
                      Container(
                        margin: EdgeInsets.only(
                          left: screenUtil.setWidth(18),
                          top: screenUtil.setHeight(94),
                        ),
                        height: screenUtil.setHeight(57),
                        width: screenUtil.setWidth(57),
                        child: Image.asset(
                          ImageConst.lidIcon,
                          fit: BoxFit.fill,
                          height: screenUtil.setHeight(57),
                          width: screenUtil.setWidth(57),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: screenUtil.setWidth(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "The Gold \nCryptocurrency of \nthe Future.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenUtil.setSp(34),
                                    fontFamily: "Poppins",
                                    color: kTextColor5),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      if (isAvailAble)
                        GestureDetector(
                          onTap: () {
                            signInWithApple();
                          },
                          child: appleSignInButton(
                            icon: ImageConst.appleImage,
                            text: "CONTINUE WITH APPLE",
                            screenUtil: screenUtil,
                          ),
                        ),
                      if (isAvailAble)
                        SizedBox(
                          height: screenUtil.setHeight(30),
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: screenUtil.setHeight(25),
                              left: screenUtil.setWidth(25),
                              right: screenUtil.setWidth(25),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                HelperUtil.checkInternetConnection()
                                    .then((internet) {
                                  if (internet) {
                                    signInWithGoogle();
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
                              child: customButtonWidget(
                                icon: ImageConst.googleLoginImg,
                                text: "CONTINUE WITH GOOGLE",
                                screenUtil: screenUtil,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: isAvailAble
                                  ? screenUtil.setHeight(75)
                                  : screenUtil.setHeight(150),
                              left: screenUtil.setWidth(25),
                              right: screenUtil.setWidth(25),
                            ),
                            child: RichText(
                              text: TextSpan(
                                  text: "I have read and agreed to the\n",
                                  style: TextStyle(
                                    color: kTextColor18,
                                    fontSize: ScreenUtil().setSp(12.5),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Terms and Conditions",
                                      style: TextStyle(
                                        color: kTextColor18,
                                        fontSize: ScreenUtil().setSp(12.5),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          HelperUtil.checkInternetConnection()
                                              .then((internet) {
                                            if (internet) {
                                              Map<String, dynamic> data = {};
                                              data['data'] = {
                                                "webUrl": Service().basicUrl +
                                                    Service().termsCondition,
                                                "title":
                                                    "", // Terms & Conditions
                                                "id": "1"
                                              };
                                              Navigator.of(context).pushNamed(
                                                RouteConst.routeWebViewScreen,
                                                arguments: data,
                                              );
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
                                        },
                                    ),
                                    TextSpan(
                                      text: " and the ",
                                      style: TextStyle(
                                        color: kTextColor18,
                                        fontSize: ScreenUtil().setSp(12.5),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Privacy Policy.",
                                      style: TextStyle(
                                        color: kTextColor18,
                                        fontSize: ScreenUtil().setSp(12.5),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          HelperUtil.checkInternetConnection()
                                              .then((internet) {
                                            if (internet) {
                                              Map<String, dynamic> data = {};
                                              data['data'] = {
                                                "webUrl": Service().basicUrl +
                                                    Service().privacyPolicy,
                                                "title": "", // Privacy Policy
                                                "id": "1"
                                              };
                                              Navigator.of(context).pushNamed(
                                                RouteConst.routeWebViewScreen,
                                                arguments: data,
                                              );
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
                                        },
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  // Sign in with google
  Future signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
        ],
      );
      GoogleSignInAuthentication token;
      try {
        await _googleSignIn.signIn();
        token = await _googleSignIn.currentUser.authentication;
        HelperUtil.checkInternetConnection().then((internet) {
          if (internet) {
            HelperUtil.showLoaderDialog(context);
            loginBloc.add(GoogleLoginEvent(tokenId: token.idToken));
          } else {
            toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                Colors.white, 12.0, "short", "bottom");
          }
        });
      } catch (error) {
        await _googleSignIn.signOut();
      }
    } catch (e) {}
  }

  // SignOut From Google
  Future signOutWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
        ],
      );
      try {
        await _googleSignIn.signOut();
      } catch (error) {}
    } catch (e) {}
  }

  // SignIn With apple
  Future signInWithApple() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (result.status != null) {
        final AppleIdCredential appleIdCredential = result.credential;

        String fName = "";
        String lName = "";
        if (appleIdCredential.fullName.givenName != null)
          fName = appleIdCredential.fullName.givenName;
        if (appleIdCredential.fullName.familyName != null)
          lName = appleIdCredential.fullName.familyName;

        if (result.status == AuthorizationStatus.authorized) {
          HelperUtil.checkInternetConnection().then((internet) {
            if (internet) {
              HelperUtil.showLoaderDialog(context);
              loginBloc.add(AppleLoginEvent(
                tokenId: String.fromCharCodes(appleIdCredential.identityToken),
                firstName: fName,
                lastName: lName,
              ));
            } else {
              toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
          });
        } else if (result.status == AuthorizationStatus.error) {
          toastUtil.showMsg(
              "Sign in failed: ${result.error.localizedDescription}",
              Colors.black,
              Colors.white,
              12.0,
              "short",
              "bottom");
        } else {
          print('User cancelled');
        }
      }
    }
  }

  Future<void> signOutFromApple() async {
    await FirebaseAuth.instance.signOut();
  }

  void handleBack() {
    if (widget.from == 1 || widget.from == 3) {
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard);
    } else if (widget.from == 4) {
      Map<String, dynamic> data = {"selectedIndex": 0};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 5) {
      Map<String, dynamic> data = {"selectedIndex": 1};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 6) {
      Map<String, dynamic> data = {"selectedIndex": 2};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 7) {
      Map<String, dynamic> data = {"selectedIndex": 3};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else {
      Navigator.pop(context);
    }
  }
}
