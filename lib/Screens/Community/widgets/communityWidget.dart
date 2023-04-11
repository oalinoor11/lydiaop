import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

// Community screen widget image with label
Widget communityItems(
    {String image, String title, Function onTap, screenUtil}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(
          top: screenUtil.setHeight(18), bottom: screenUtil.setHeight(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: screenUtil.setWidth(18),
            ),
            child: Image.asset(
              image,
              height: screenUtil.setHeight(26),
              width: screenUtil.setWidth(26),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenUtil.setWidth(13),
            ),
            child: Text(
              title,
              style: TextStyle(
                  color: kTextColor5.withOpacity(0.8),
                  fontFamily: "Poppins",
                  fontSize: screenUtil.setSp(16.0),
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    ),
  );
}
