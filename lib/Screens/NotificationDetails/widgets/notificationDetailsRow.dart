import 'package:flutter/material.dart';

Widget notificationDetailsRow(String key, String value, screenUtil) {
  return Padding(
    padding: EdgeInsets.only(bottom: screenUtil.setHeight(13)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(top: screenUtil.setHeight(1)),
          child: Text(
            "$key",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins",
                fontSize: screenUtil.setSp(14.0),
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: screenUtil.setHeight(1)),
          child: Text(
            "$value",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins",
                fontSize: screenUtil.setSp(16.0),
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
