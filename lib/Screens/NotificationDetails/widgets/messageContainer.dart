import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget messageContainer(screenUtil) {
  return Container(
    margin: EdgeInsets.only(
      top: screenUtil.setHeight(30),
    ),
    decoration: BoxDecoration(
      color: kTextColor6,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Container(
      margin: EdgeInsets.symmetric(
          vertical: screenUtil.setHeight(9),
          horizontal: screenUtil.setWidth(13)),
      child: Text(
        "A certificate of your gold will be sent to your registered email.",
        style: TextStyle(
            color: kAppbarColor,
            fontFamily: "Poppins",
            fontSize: screenUtil.setSp(14.0),
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
