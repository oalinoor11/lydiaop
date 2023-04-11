import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget withdrawalWidget(screenUtil, double amount) {
  return Padding(
    padding: EdgeInsets.only(top: screenUtil.setHeight(35.0)),
    child: Column(
      children: [
        Text(
          "Withdrawal Amount",
          style: TextStyle(
              color: Colors.white,
              fontSize: screenUtil.setSp(15),
              fontFamily: "Poppins"),
        ),
        Text(
          "\$$amount",
          style: TextStyle(
              color: kTextColor16,
              fontSize: screenUtil.setSp(48),
              fontFamily: "Poppins"),
        ),
      ],
    ),
  );
}
