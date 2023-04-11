import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();

  bool alreadyLogin = false;

  final ValueNotifier<int> showGlow =
      ValueNotifier<int>(0); // 1. show send lid Glow  2. show Receive Lid Glow
  bool buttonPressed = false;
  @override
  void initState() {
    super.initState();
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
    });
  }

  @override
  void dispose() {
    buttonPressed = false;
    // shareBloc.close();
    showGlow?.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: showGlow,
                  builder: (context, isShowGlow, Widget child) {
                    return Center(
                      child: Container(
                        height: screenUtil.setHeight(160),
                        width: screenUtil.setHeight(160),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            matchTextDirection: true,
                            repeat: ImageRepeat.noRepeat,
                            image: AssetImage(
                              ImageConst.sharebgIcon,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenUtil.setHeight(28)),
                          child: GestureDetector(
                            onTap: () {
                              if (!buttonPressed) {
                                buttonPressed = true;
                                showGlow.value = 1;

                                Future.delayed(Duration(milliseconds: 500), () {
                                  HelperUtil.checkInternetConnection()
                                      .then((internet) {
                                    if (internet) {
                                      if (alreadyLogin) {
                                        buttonPressed = false;
                                        showGlow.value = 0;
                                        Navigator.of(context).pushNamed(
                                            RouteConst.routeSendLidScreen);
                                      } else {
                                        buttonPressed = false;
                                        showGlow.value = 0;
                                        Navigator.of(context).pushNamed(
                                            RouteConst.routeLoginPage);
                                      }
                                    } else {
                                      buttonPressed = false;
                                      showGlow.value = 0;
                                      toastUtil.showMsg(
                                        Constant.noInternetMsg,
                                        Colors.black,
                                        Colors.white,
                                        12.0,
                                        "short",
                                        "bottom",
                                      );
                                    }
                                  });
                                });
                              }
                            },
                            child: Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  matchTextDirection: true,
                                  repeat: ImageRepeat.noRepeat,
                                  image: AssetImage(
                                    showGlow.value == 1
                                        ? ImageConst.selSendLid
                                        : ImageConst.sendLid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: screenUtil.setHeight(150)),
                  child: Center(
                    child: Text(
                      "Send Lids to another wallet",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kTextColor14,
                        fontFamily: "Poppins",
                        fontSize: screenUtil.setSp(14.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: alreadyLogin
                  ? screenUtil.setHeight(60)
                  : screenUtil.setHeight(75),
            ),
            Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: showGlow,
                  builder: (context, isShowGlow, Widget child) {
                    return Center(
                      child: Container(
                        height: screenUtil.setHeight(160),
                        width: screenUtil.setHeight(160),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            matchTextDirection: true,
                            repeat: ImageRepeat.noRepeat,
                            image: AssetImage(
                              ImageConst.sharebgIcon,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenUtil.setHeight(28)),
                          child: GestureDetector(
                            onTap: () {
                              if (!buttonPressed) {
                                buttonPressed = true;
                                showGlow.value = 2;

                                Future.delayed(Duration(milliseconds: 500), () {
                                  HelperUtil.checkInternetConnection()
                                      .then((internet) {
                                    if (internet) {
                                      if (alreadyLogin) {
                                        showGlow.value = 0;
                                        buttonPressed = false;
                                        Map<String, dynamic> data = {"from": 6};
                                        Navigator.of(context).pushNamed(
                                            RouteConst.routeReceiveLidScreen,
                                            arguments: {"data": data});
                                      } else {
                                        showGlow.value = 0;
                                        buttonPressed = false;
                                        Navigator.of(context).pushNamed(
                                            RouteConst.routeLoginPage);
                                      }
                                    } else {
                                      showGlow.value = 0;
                                      buttonPressed = false;
                                      toastUtil.showMsg(
                                        Constant.noInternetMsg,
                                        Colors.black,
                                        Colors.white,
                                        12.0,
                                        "short",
                                        "bottom",
                                      );
                                    }
                                  });
                                });
                              }
                            },
                            child: Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  matchTextDirection: true,
                                  repeat: ImageRepeat.noRepeat,
                                  image: AssetImage(
                                    showGlow.value == 2
                                        ? ImageConst.selReceiveLid
                                        : ImageConst.receiveLid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: screenUtil.setHeight(150)),
                  child: Center(
                    child: Text(
                      "Receive Lids from another wallet",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kTextColor14,
                          fontFamily: "Poppins",
                          fontSize: screenUtil.setSp(14.0)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
