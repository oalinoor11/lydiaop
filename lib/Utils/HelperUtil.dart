import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/SharedPreferenceUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperUtil {
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Widget buttonWithGradientColor({BuildContext context, String text}) {
    return Container(
      height: ScreenUtil().setHeight(92.0),
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new ExactAssetImage(ImageConst.gradientBtnBgImg),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: "Poppins",
                color: kTextColor,
                fontSize: ScreenUtil().setSp(16.0),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Background gradient color
  static BoxDecoration backgroundGradient() {
    return BoxDecoration(
      gradient: LinearGradient(colors: [
        kGradientColor1,
        kGradientColor2,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    );
  }

  // settings appbar
  static PreferredSize commonAppbar(
      {BuildContext context, String title, Function onTap}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(ScreenUtil().setHeight(85)),
      child: Container(
        decoration: BoxDecoration(
          color: kAppbarColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 7),
                blurRadius: 15)
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(54.0),
            bottom: ScreenUtil().setHeight(15.00),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(12.00),
                ),
                child: IconButton(
                    icon: Image(
                      image: AssetImage(ImageConst.backArrowIcon),
                      height: ScreenUtil().setHeight(20),
                      width: ScreenUtil().setWidth(20),
                    ),
                    onPressed: onTap),
              ),
              Container(
                child: Text(
                  "$title",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: ScreenUtil().setSp(17.0),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget loadingStateWidget() {
    return Container(
      width: double.infinity,
      decoration: HelperUtil.backgroundGradient(),
      child: Center(
        child: Container(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  // Common back button
  static Widget backButton({BuildContext context, Function onTap}) {
    return Container(
      child: IconButton(
        icon: Image(
          image: AssetImage(ImageConst.backArrowIcon),
          height: ScreenUtil().setHeight(20),
          width: ScreenUtil().setWidth(20),
        ),
        onPressed: onTap,
      ),
    );
  }

  // Loading widget with loader
  static Widget loadingWidget() {
    return Container(
      width: double.infinity,
      decoration: HelperUtil.backgroundGradient(),
      child: Center(
        child: Container(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  // Update FCM Token
  updateFcmToken(String fcmToken) async {
    await HelperUtil.checkInternetConnection().then((internet) async {
      if (internet != null && internet) {
        await Service().updateFcmService("$fcmToken").then((respObj) {});
      }
    });
  }

  // Refresh Token
  refreshToken(String refreshToken) async {
    await HelperUtil.checkInternetConnection().then((internet) async {
      Map<String, dynamic> resData;
      if (internet != null && internet) {
        await Service()
            .refreshTokenService(refreshToken: "$refreshToken")
            .then((respObj) {
          if (resData != null && resData["code"].toString() == "200") {
            SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
            _sharedPreference.addSharedPref(
                'token', resData["result"]["token"]);
            _sharedPreference.addSharedPref('lastSavedDate',
                "${DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())}");
          }
        });
      }
    });
  }

  Future<bool> isAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("alreadyLogin") == "true" ? true : false;
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
          alignment: FractionalOffset.center,
          height: 80.0,
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ))),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: () async => false);
      },
    );
  }

  static Widget glowButtonWithText(
      {showGlow, int value, Function onTap, String btnText, int iconSize}) {
    ScreenUtil screenUtil = ScreenUtil();
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: showGlow,
          builder: (context, isShowGlow, Widget child) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 4),
                height: screenUtil.setHeight(iconSize ?? 165), //165,
                width: screenUtil.setHeight(iconSize ?? 165), //165,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    matchTextDirection: true,
                    repeat: ImageRepeat.noRepeat,
                    image: AssetImage(
                      ImageConst.coinbgIcon,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenUtil.setHeight(32)),
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.center,
                          matchTextDirection: true,
                          repeat: ImageRepeat.noRepeat,
                          image: AssetImage(
                            isShowGlow == value
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            child: Center(
              child: Text(
                btnText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kTextColor,
                  fontFamily: "Poppins",
                  fontSize: screenUtil.setSp(17.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^\d*\.?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
