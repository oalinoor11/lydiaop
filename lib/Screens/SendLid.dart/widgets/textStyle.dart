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
InputDecoration inPutDecoration(
    hintText, int from, BuildContext context, screenUtil,
    {Function onTap}) {
  return InputDecoration(
    focusColor: kTextColor5,
    filled: true,
    hintText: hintText,
    counterText: "",
    suffixIcon: Container(
      margin: const EdgeInsets.only(right: 5),
      child: from == 1
          ? Container(
              height: screenUtil.setHeight(24),
              width: screenUtil.setWidth(24),
              margin: EdgeInsets.only(
                top: screenUtil.setHeight(11),
                bottom: screenUtil.setHeight(12),
                right: screenUtil.setHeight(14),
              ),
              child: Image(
                image: AssetImage(
                  ImageConst.lidIcon,
                ),
                height: screenUtil.setHeight(20),
                width: screenUtil.setWidth(20),
              ),
            )
          : from == 2
              ? GestureDetector(
                  onTap: onTap,
                  child: Container(
                    child: Container(
                      height: screenUtil.setHeight(24),
                      width: screenUtil.setWidth(24),
                      margin: EdgeInsets.only(
                        top: screenUtil.setHeight(12),
                        bottom: screenUtil.setHeight(12),
                        right: screenUtil.setHeight(12),
                      ),
                      child: Image(
                        image: AssetImage(
                          ImageConst.scannerIcon,
                        ),
                        height: screenUtil.setHeight(24),
                        width: screenUtil.setWidth(24),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
    ),
    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: from == 3
          ? BorderRadius.all(Radius.circular(15))
          : BorderRadius.all(Radius.circular(27)),
      borderSide:
          BorderSide(color: kTextColor, width: 2.0, style: BorderStyle.solid),
    ),
    border: OutlineInputBorder(
      borderRadius: from == 3
          ? BorderRadius.all(Radius.circular(15))
          : BorderRadius.all(Radius.circular(27)),
      borderSide: BorderSide(
          color: Colors.white.withOpacity(0.5),
          width: 2.0,
          style: BorderStyle.solid),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: from == 3
          ? BorderRadius.all(Radius.circular(15))
          : BorderRadius.all(Radius.circular(27)),
      borderSide:
          BorderSide(color: kTextColor5, width: 2.0, style: BorderStyle.solid),
    ),
    hintStyle: TextStyle(fontSize: screenUtil.setSp(16.0), color: kTextColor7),
  );
}

// Email, firstname and last name title
Widget textfieldLabel(String name, screenUtil) {
  return Text(
    name,
    style: TextStyle(
      color: Colors.white,
      fontSize: screenUtil.setSp(15),
      fontFamily: "Poppins",
      fontStyle: FontStyle.normal,
    ),
  );
}
