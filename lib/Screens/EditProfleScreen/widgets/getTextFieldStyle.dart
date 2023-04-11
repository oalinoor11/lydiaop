import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

// TextFied Text Style
TextStyle getTextFieldStyle() {
  return TextStyle(
      fontFamily: "Poppins",
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: kTextColor3);
}

// TextField input decoration
InputDecoration getInputDecoration(
    hintText, int from, bool isReadOnly, screenUtil) {
  return InputDecoration(
    focusColor: kTextColor5,
    filled: true,
    hintText: hintText,
    counterText: "",
    contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 0.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(27)),
      borderSide: BorderSide(
          color: isReadOnly ? kTextColor3 : kTextColor,
          width: 1.0,
          style: BorderStyle.solid),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(27)),
      borderSide: BorderSide(
          color: isReadOnly ? kTextColor3 : Colors.white.withOpacity(0.5),
          width: 1.0,
          style: BorderStyle.solid),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(27)),
      borderSide: BorderSide(
          color: isReadOnly ? kTextColor3 : kTextColor5,
          width: 1.0,
          style: BorderStyle.solid),
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
      fontFamily: "HelveticaNeue",
      fontStyle: FontStyle.normal,
    ),
  );
}
