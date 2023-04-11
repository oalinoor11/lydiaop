import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget noInvestmentWidget(screenUtil) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(left: screenUtil.setWidth(30)),
        child: Image(
          image: AssetImage(
            "assets/images/no_investment.png",
          ),
          height: screenUtil.setHeight(107),
          width: screenUtil.setWidth(121),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: screenUtil.setHeight(9)),
        child: Text(
          "No investment yet!",
          style: TextStyle(
              color: kTextColor,
              fontSize: screenUtil.setSp(16.0),
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic),
        ),
      )
    ],
  );
}
