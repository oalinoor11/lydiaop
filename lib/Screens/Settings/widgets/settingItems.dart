import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_svg/svg.dart';

// Seetings screen widget image with label
Widget settingItems({String image, String title, Function onTap, screenUtil}) {
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
              child: SvgPicture.asset(
                image,
                color: kTextColor5,
                height: screenUtil.setHeight(20),
                width: screenUtil.setWidth(20),
              )),
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
