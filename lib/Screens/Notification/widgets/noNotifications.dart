import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';

Widget noNotificationWidget(screenUtil) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Image(
            image: AssetImage(
              ImageConst.noNotificationIcon,
            ),
            height: screenUtil.setHeight(107),
            width: screenUtil.setWidth(121),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: screenUtil.setHeight(21)),
          child: Text(
            "No Notifications yet!",
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
