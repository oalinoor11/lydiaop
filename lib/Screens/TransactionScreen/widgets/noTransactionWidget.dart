import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';

Widget noTransactionWidget(screenUtil) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Image(
            image: AssetImage(
              ImageConst.noTransactionImg,
            ),
            height: screenUtil.setHeight(107),
            width: screenUtil.setWidth(121),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: screenUtil.setHeight(21)),
          child: Text(
            "No transactions yet!",
            style: TextStyle(
                color: kTextColor,
                fontSize: screenUtil.setSp(16.0),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic),
          ),
        ),
        SizedBox(
          height: screenUtil.setHeight(50),
        )
      ],
    ),
  );
}
