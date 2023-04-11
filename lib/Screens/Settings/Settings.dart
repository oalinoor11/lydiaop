import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/settingItems.dart';

class SettingScreen extends StatefulWidget {
  final int from;

  const SettingScreen({Key key, this.from = 0})
      : super(
            key:
                key); // 4. from home screen  //5. from buy screen  6. from trade 7.cashout
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool alreadyLogin = false;

  ScreenUtil screenUtil = ScreenUtil();

  bool isAvailAble = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      checkIsAvailable();
    }
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
    });
  }

  Future<void> checkIsAvailable() async {
    isAvailAble = await AppleSignIn.isAvailable();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (alreadyLogin) {
          Navigator.of(context)
              .pushReplacementNamed(RouteConst.routeProfileScreen);
        } else {
          handleBack();
          // Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor2,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
          child: HelperUtil.commonAppbar(
            context: context,
            title: "Settings",
            onTap: () {
              if (alreadyLogin) {
                Navigator.of(context)
                    .pushReplacementNamed(RouteConst.routeProfileScreen);
              } else {
                handleBack();
                // Navigator.pop(context);
              }
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: HelperUtil.backgroundGradient(),
          child: Column(
            children: [
              SizedBox(height: screenUtil.setHeight(18)),
              if (alreadyLogin)
                settingItems(
                    image: ImageConst.securityPinImg,
                    title: "Update Security PIN",
                    screenUtil: screenUtil,
                    onTap: () {
                      settingsClickAction(1);
                    }),
              // settingItems(
              //     image: ImageConst.communityImg,
              //     title: "Community",
              //     screenUtil: screenUtil,
              //     onTap: () {
              //       settingsClickAction(2);
              //     }),
              if (alreadyLogin)
                settingItems(
                    image: ImageConst.supportImg,
                    title: "Support",
                    screenUtil: screenUtil,
                    onTap: () {
                      settingsClickAction(3);
                    }),
              settingItems(
                image: ImageConst.privacyPolicyImg,
                title: "Privacy Policy",
                screenUtil: screenUtil,
                onTap: () {
                  settingsClickAction(4);
                },
              ),
              settingItems(
                  image: ImageConst.termsConditionImg,
                  title: "Terms & Conditions",
                  screenUtil: screenUtil,
                  onTap: () {
                    settingsClickAction(5);
                  }),
              settingItems(
                  image: ImageConst.loginImg,
                  title: "Login",
                  screenUtil: screenUtil,
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteConst.routeLoginPage);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // from 1.update pin 2.community 3.support 4.privacy 5.terms and condition
  void settingsClickAction(int from) {
    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        if (from == 1) {
          Navigator.of(context)
              .pushReplacementNamed(RouteConst.routeUpdatePinScreen);
        } else if (from == 2) {
          Map<String, dynamic> data = {};
          data['data'] = {
            "webUrl": Service().communityUrl,
            "title": "Community", // Privacy Policy
            "id": "1"
          };
          Navigator.of(context).pushNamed(
            RouteConst.routeWebViewScreen,
            arguments: data,
          );
        } else if (from == 3) {
          sendMail();
        } else if (from == 4) {
          Map<String, dynamic> data = {};
          data['data'] = {
            "webUrl": Service().basicUrl + Service().privacyPolicy,
            "title": "", // Privacy Policy
            "id": "1"
          };
          Navigator.of(context).pushNamed(
            RouteConst.routeWebViewScreen,
            arguments: data,
          );
        } else if (from == 5) {
          HelperUtil.checkInternetConnection().then((internet) {
            if (internet) {
              Map<String, dynamic> data = {};
              data['data'] = {
                "webUrl": Service().basicUrl + Service().termsCondition,
                "title": "", // Terms & Conditions
                "id": "1"
              };
              Navigator.of(context).pushNamed(
                RouteConst.routeWebViewScreen,
                arguments: data,
              );
            } else {
              ToastUtil().showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
          });
        }
      } else {
        ToastUtil().showMsg(Constant.noInternetMsg, Colors.black, Colors.white,
            12.0, "short", "bottom");
      }
    });
  }

  sendMail() async {
    const url = 'mailto:admin@lidya.app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void handleBack() {
    if (widget.from == 4) {
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
