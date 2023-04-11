import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/DashboardDataModel.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/HomeScreen/widgets/linechartWidget.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';

import 'dashboardInvesmentDetails.dart';
import 'dataSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Widget dashboardWidget(BuildContext context, DashboardDataModel respData,
    screenUtil, showGlow, Timer timer) {
  bool buttonPressed = false;

  List<DataSeries> data = [
    DataSeries(
      year: 2018,
      developers: 10,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    DataSeries(
      year: 2019,
      developers: 30,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    DataSeries(
      year: 2020,
      developers: 20,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    DataSeries(
      year: 2021,
      developers: 60,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    DataSeries(
      year: 2022,
      developers: 50,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];

  return Column(
    children: [
      Container(
        height: screenUtil.setHeight(180),
        margin: EdgeInsets.only(
            left: 20.0, right: 20.0, top: screenUtil.setHeight(4)),
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: kTextColor6.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenUtil.setHeight(8)),
                  child: Text(
                    respData.result.first.gainValue >= 0.00 ? "GAIN" : "LOSE",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kTextColor14,
                        fontSize: screenUtil.setSp(15.5),
                        fontFamily: "Poppins"),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenUtil.setHeight(9)),
                  child: Image(
                    image: AssetImage(
                      respData.result.first.gainValue >= 0.00
                          ? ImageConst.greenUpArrowIcon
                          : ImageConst.redDownArrowIcon,
                    ),
                    height: screenUtil.setHeight(20.0),
                    width: screenUtil.setWidth(20.0),
                  ),
                )
              ],
            ),

            // Chart Part
            Expanded(
              child: LineChatWidget(data, animate: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: screenUtil.setHeight(1), right: 5),
                  child: Text(
                    "\$ ${respData.result.first.gainValue.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kTextColor16,
                        fontSize: screenUtil.setSp(16.0),
                        fontFamily: "Poppins"),
                    textAlign: TextAlign.right,
                  ),
                ),
                double.parse(respData.result.first.deltaGain.toString()) >=
                        0.00
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: screenUtil.setHeight(1), right: 5),
                        child: Text(
                          "+  ${respData.result.first.deltaGain.toStringAsFixed(2)} ( ${respData.result.first.deltaGainPercentage.toStringAsFixed(2)}%)",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kTextColor15,
                              fontSize: screenUtil.setSp(12.0),
                              fontFamily: "Poppins"),
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: screenUtil.setHeight(1), right: 5),
                        child: Text(
                          "${respData.result.first.deltaGain.toStringAsFixed(2)} ( ${respData.result.first.deltaGainPercentage.toStringAsFixed(2)}%)",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              fontSize: screenUtil.setSp(12.0),
                              fontFamily: "Poppins"),
                          textAlign: TextAlign.right,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: screenUtil.setHeight(130),
        margin: EdgeInsets.only(
            left: 20.0, right: 20.0, top: screenUtil.setHeight(10)),
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: kTextColor6.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenUtil.setHeight(2),
            ),
            investmentDetailsRow(
                title: "Lid Purchased",
                amount: "\$${respData.result[0].totalLidPurchased.toString()}",
                screenUtil: screenUtil),
            investmentDetailsRow(
                title: "Lid Sent",
                amount: respData.result[0].totalLidSent.toString(),
                screenUtil: screenUtil),
            investmentDetailsRow(
                title: "Lid Received",
                amount: respData.result[0].totalLidReceived.toString(),
                screenUtil: screenUtil),
            investmentDetailsRow(
                title: "Lid Sold",
                amount: "\$${respData.result[0].totalLidCashout.toString()}",
                screenUtil: screenUtil),
          ],
        ),
      ),
      SizedBox(height: screenUtil.setHeight(15)),
      HelperUtil.glowButtonWithText(
        showGlow: showGlow,
        value: 2,
        iconSize: 150,
        onTap: () {
          if (!buttonPressed) {
            buttonPressed = true;
            showGlow.value = 2;
            Future.delayed(Duration(milliseconds: 500), () {
              Map<String, dynamic> data = {"selectedIndex": 1};
              timer?.cancel();
              Navigator.of(context).pushNamed(RouteConst.routeMainDashboard,
                  arguments: {"data": data});
            });
          }
        },
        btnText: "INVEST MORE",
      ),
    ],
  );
}
