import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/Constant.dart';

Widget availableLidWidget(screenUtil, String walletAddress, bool alreadyLogin) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: Global.availableLidCount,
            builder: (context, value, widget) {
              return Container(
                child: Text(
                  "$value" ?? "0",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenUtil.setSp(42.0),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: screenUtil.setHeight(7), left: 2),
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
          final _price = value * (1 + Constant.buyFee); 
          return Container(
            child: Text(
              "\$ ${_price.toStringAsFixed(2)}",
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
