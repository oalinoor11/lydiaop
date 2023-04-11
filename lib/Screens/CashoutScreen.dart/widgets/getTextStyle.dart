import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';

TextStyle getTextStyle() {
  return TextStyle(
      fontFamily: "Poppins",
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: kTextColor3);
}

// TextField input decoration
InputDecoration inPutDecoration(hintText, screenUtil) {
  return InputDecoration(
    focusColor: kTextColor5,
    filled: true,
    hintText: hintText,
    counterText: "",
    suffixIcon: Container(
      margin: const EdgeInsets.only(right: 5),
      child: Container(
        margin: EdgeInsets.only(
          top: screenUtil.setHeight(4),
          bottom: screenUtil.setHeight(8),
          right: screenUtil.setHeight(12),
        ),
        child: Image(
          image: AssetImage(
            ImageConst.lidIcon,
          ),
          height: screenUtil.setHeight(20),
          width: screenUtil.setWidth(20),
        ),
      ),
    ),
    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(27)),
      borderSide:
          BorderSide(color: kTextColor, width: 2.0, style: BorderStyle.solid),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(27)),
      borderSide: BorderSide(
          color: Colors.white.withOpacity(0.5),
          width: 2.0,
          style: BorderStyle.solid),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(27)),
      borderSide:
          BorderSide(color: kTextColor5, width: 2.0, style: BorderStyle.solid),
    ),
    hintStyle: TextStyle(fontSize: screenUtil.setSp(16.0), color: kTextColor7),
  );
}
