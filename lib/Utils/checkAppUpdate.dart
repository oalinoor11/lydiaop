import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/PrintUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SharedPreferenceUtil.dart';

class AppUpdateUtil {
  static checkAppUpdate(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String lasUpdateAlertTime = prefs.getString("lasUpdateAlertTime") ?? "";

    if (lasUpdateAlertTime != null && lasUpdateAlertTime != "") {
      final savedDate =
          DateFormat('yyyy-MM-dd').parse(lasUpdateAlertTime.toString());

      final currentDate =
          DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
      var dayDifference = currentDate.difference(savedDate).inDays;

      if (dayDifference > 0) {
        versionCheck(context);
      }
    } else {
      versionCheck(context);
    }
  }

  static versionCheck(context) async {
    //Get Current installed version of app

    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    PrintUtil print = PrintUtil();
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    bool enableForceUpdate = false;

    try {
      await remoteConfig.ensureInitialized();
      await remoteConfig.fetch();
      await remoteConfig.activate();

      if (Platform.isIOS) {
        double newVersion = double.parse(remoteConfig
            .getString('ios_app_version')
            .trim()
            .replaceAll(".", ""));
        enableForceUpdate =
            remoteConfig.getBool('enable_ios_force_update') ?? false;
        // appstoreUrl = remoteConfig.getString("") ?? "";

        if (newVersion > currentVersion) {
          showUpdateAlert(context, enableForceUpdate, Global.appStoreUrl,
              info.version, remoteConfig.getString('ios_app_version'));
        }
        print.printMsg('newVersion:$newVersion');
        print.printMsg('currentVersion:$currentVersion');
      } else {
        double newVersion = double.parse(remoteConfig
            .getString('android_app_version')
            .trim()
            .replaceAll(".", ""));
        enableForceUpdate =
            remoteConfig.getBool('enable_android_force_update') ?? false;
        // playstoreUrl = remoteConfig.getString("playstore_url") ?? "";

        if (newVersion > currentVersion) {
          showUpdateAlert(context, enableForceUpdate, Global.playStoreUrl,
              info.version, remoteConfig.getString('android_app_version'));
          print.printMsg('newVersion:$newVersion');
          print.printMsg('currentVersion:$currentVersion');
        }
        print.printMsg('newVersion:$newVersion');
        print.printMsg('currentVersion:$currentVersion');
      }
    } catch (exception) {
      print.printMsg(
          'Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  static showUpdateAlert(
      context, enableForceUpdate, url, currentVerson, newVersion) {
    ScreenUtil screenUtil = ScreenUtil();
    SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            if (enableForceUpdate) {
              return showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      "Do you want to exit the app?",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(18.0),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: new Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(17.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                      FlatButton(
                        child: new Text(
                          'No',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(17.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              _sharedPreference.addSharedPref('lasUpdateAlertTime',
                  "${DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())}");
              Navigator.of(context).pop(false);
            }
            return true;
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: screenUtil.setWidth(339),
              height: enableForceUpdate
                  ? screenUtil.setHeight(480)
                  : screenUtil.setHeight(590),
              margin: EdgeInsets.only(
                left: screenUtil.setWidth(18),
                right: screenUtil.setWidth(18),
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
                        margin: EdgeInsets.only(
                          top: screenUtil.setHeight(48),
                          left: screenUtil.setWidth(35),
                        ),
                        child: Image.asset(
                          ImageConst.updateAppImg,
                          width: screenUtil.setWidth(125),
                          height: screenUtil.setHeight(120),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenUtil.setHeight(17)),
                        child: Text(
                          "UPDATE APP ?",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(24.0),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenUtil.setHeight(1)),
                        child: Text(
                          "An updated version of Lidya is now available! \nCurrent version $currentVerson \nNew Version $newVersion",
                          style: TextStyle(
                              color: kGradientColor6,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(16.0),
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: screenUtil.setWidth(4.0),
                          left: screenUtil.setWidth(2.0),
                          top: screenUtil.setHeight(18.0),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: HelperUtil.buttonWithGradientColor(
                              context: context, text: "UPDATE NOW"),
                        ),
                      ),
                      if (!enableForceUpdate)
                        Padding(
                          padding: EdgeInsets.only(
                            right: screenUtil.setWidth(24.0),
                            left: screenUtil.setWidth(24.0),
                            top: screenUtil.setWidth(18.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _sharedPreference.addSharedPref(
                                  'lasUpdateAlertTime',
                                  "${DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())}");
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(
                                      screenUtil.setHeight(27))),
                              height: screenUtil.setHeight(44),
                              child: Center(
                                child: Text(
                                  'Later',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: kTextColor,
                                    fontSize: ScreenUtil().setSp(16.0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!enableForceUpdate)
                        Padding(
                          padding: EdgeInsets.only(
                            right: screenUtil.setWidth(24.0),
                            left: screenUtil.setWidth(24.0),
                            top: screenUtil.setWidth(18.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _sharedPreference.addSharedPref(
                                  'lasUpdateAlertTime',
                                  "${DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())}");
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: kTextColor17),
                                  borderRadius: BorderRadius.circular(
                                      screenUtil.setHeight(27))),
                              height: screenUtil.setHeight(44),
                              child: Center(
                                child: Text(
                                  'Ignore',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: kTextColor17,
                                    fontSize: ScreenUtil().setSp(16.0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
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
}
