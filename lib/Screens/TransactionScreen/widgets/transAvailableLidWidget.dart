import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';

Widget transAvailableLidWidget(screenUtil, walletAddress) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: screenUtil.setHeight(6)),
            child: ValueListenableBuilder(
              valueListenable: Global.availableLidCount,
              builder: (context, value, widget) {
                return Container(
                  child: Text(
                    "$value" ?? "0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenUtil.setSp(44.0),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: screenUtil.setHeight(15), left: 2),
            child: Image(
              image: AssetImage(
                ImageConst.lidIcon,
              ),
              height: screenUtil.setHeight(26),
              width: screenUtil.setWidth(26),
            ),
          ),
        ],
      ),
      ValueListenableBuilder(
        valueListenable: Global.currentUsdValue,
        builder: (context, double value, widget) {
          return Container(
            child: Text(
              "\$ ${value.toStringAsFixed(2)}",
              style: TextStyle(
                color: kTextColor,
                fontSize: screenUtil.setSp(16.0),
                fontFamily: "Poppins",
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        },
      ),
    ],
  );
}
