import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_svg/svg.dart';

Widget chooseProfileWidget(
    {String title, String image, Function onTap, screenUtil}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: screenUtil.setWidth(10)),
          height: screenUtil.setHeight(44),
          width: screenUtil.setWidth(44),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kTextColor3,
          ),
          child: Center(
              child: SvgPicture.asset(
            image,
            color: kTextColor5.withOpacity(0.8),
            height: screenUtil.setHeight(20),
            width: screenUtil.setWidth(20),
          )),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, left: screenUtil.setWidth(10)),
          width: 60,
          child: Text(
            title,
            style: TextStyle(
              color: kTextColor3,
              fontSize: screenUtil.setSp(12),
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
