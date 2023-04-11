import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';

Widget sendLidAppBar(context, screenUtil, walletAddress) {
  return Container(
    decoration: BoxDecoration(
      color: kAppbarColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          offset: Offset(0, 7),
          blurRadius: 15,
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: screenUtil.setHeight(38.0)),
          child: Row(
            children: [
              Container(
                child: IconButton(
                  icon: Image(
                    image: AssetImage(ImageConst.backArrowIcon),
                    height: screenUtil.setHeight(20),
                    width: screenUtil.setWidth(20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                child: Text(
                  "Send Lid",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: screenUtil.setSp(17.0),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenUtil.setHeight(3)),
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
                  margin:
                      EdgeInsets.only(top: screenUtil.setHeight(12), left: 2),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   child: Text(
                //     "Wallet Address: $walletAddress",
                //     style: TextStyle(
                //       color: kTextColor,
                //       fontSize: screenUtil.setSp(16.0),
                //       fontFamily: "Poppins",
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                // ),

                ValueListenableBuilder(
                  valueListenable: Global.lidValue,
                  builder: (context, double value, widget) {
                    double currentUsdValue =
                        double.parse(Global.availableLidCount.value) * value ?? 0;
                    return Container(
                      child: Text(
                        "Current USD Value: \$${currentUsdValue.toStringAsFixed(2)}",
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
            )
          ],
        )
      ],
    ),
  );
}
