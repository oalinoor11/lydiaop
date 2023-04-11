import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/HomeScreen/widgets/noInvestementWidget.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';

Widget startInvestment(BuildContext context, bool alreadyLogin, screenUtil,
    showGlow, Timer timer) {
  bool buttonPressed = false;
  return Column(
    children: [
      SizedBox(
        height:
            alreadyLogin ? screenUtil.setHeight(50) : screenUtil.setHeight(70),
      ),
      noInvestmentWidget(screenUtil),
      SizedBox(
        height:
            alreadyLogin ? screenUtil.setHeight(50) : screenUtil.setHeight(80),
      ),
      HelperUtil.glowButtonWithText(
        showGlow: showGlow,
        value: 1,
        onTap: () {
          if (!buttonPressed) {
            buttonPressed = true;
            showGlow.value = 1;
            Future.delayed(Duration(milliseconds: 500), () {
              Map<String, dynamic> data = {"selectedIndex": 1};
              timer?.cancel();
              Navigator.of(context).pushNamed(RouteConst.routeMainDashboard,
                  arguments: {"data": data});
            });
          }
        },
        btnText: "START INVESTING",
      ),
    ],
  );
}
