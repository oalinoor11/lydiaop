import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customButtonWidget({
  String icon,
  String text,
  ScreenUtil screenUtil,
}) {
  return Container(
    height: screenUtil.setHeight(46),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      color: kBackgroundColor7,
      boxShadow: [
        BoxShadow(
          color: kshadowColor2,
          offset: Offset(0, 0),
          blurRadius: 15,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: screenUtil.setWidth(15),
            top: screenUtil.setHeight(11),
            bottom: screenUtil.setHeight(11),
          ),
          child: Image(
            image: AssetImage(icon),
            height: screenUtil.setHeight(20),
            width: screenUtil.setWidth(20),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: kTextColor,
              fontSize: screenUtil.setSp(17),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget appleSignInButton({String icon, String text, ScreenUtil screenUtil}) {
  return Container(
    margin: EdgeInsets.only(
      left: screenUtil.setWidth(25),
      right: screenUtil.setWidth(25),
    ),
    height: screenUtil.setHeight(46),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kshadowColor2,
          offset: Offset(0, 0),
          blurRadius: 15,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: screenUtil.setWidth(16),
            top: screenUtil.setHeight(11),
            bottom: screenUtil.setHeight(11),
          ),
          child: Image(
            image: AssetImage(icon),
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: screenUtil.setSp(17)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
