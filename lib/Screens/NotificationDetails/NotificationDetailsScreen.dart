import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/NotificationModel.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Screens/NotificationDetails/widgets/dashedLine.dart';
import 'package:flutter_app/Screens/NotificationDetails/widgets/notificationDetailsRow.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/messageContainer.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final Result transDetails;

  const NotificationDetailsScreen({Key key, this.transDetails})
      : super(key: key);
  @override
  _NotificationDetailsScreenState createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  ScreenUtil screenUtil = ScreenUtil();

  bool isNetworkConnectd = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
        child: HelperUtil.commonAppbar(
          context: context,
          title: "Notifications",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: HelperUtil.backgroundGradient(),
        child: Container(
          margin: EdgeInsets.only(
              left: screenUtil.setWidth(18.0),
              right: screenUtil.setWidth(18.0)),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: screenUtil.setHeight(33)),
                child: Text(
                  "${widget.transDetails.body}",
                  style: TextStyle(
                      color: kTextColor3,
                      fontFamily: "Poppins",
                      fontSize: screenUtil.setSp(16.0),
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              dashedLine(screenUtil),
              notificationDetailsRow("Transaction ID",
                  "${widget.transDetails.transactionId.sId}", screenUtil),
              notificationDetailsRow("Lid Quantity",
                  "${widget.transDetails.transactionId.lid}", screenUtil),
              notificationDetailsRow(
                  "Date",
                  "${widget.transDetails.transactionId.createdAtDate}",
                  screenUtil),
              notificationDetailsRow(
                  "Time",
                  "${widget.transDetails.transactionId.createdAtTime}",
                  screenUtil),
              messageContainer(screenUtil),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    right: screenUtil.setWidth(20),
                    left: screenUtil.setWidth(20),
                    bottom: screenUtil.setHeight(48),
                  ),
                  child: HelperUtil.buttonWithGradientColor(
                      context: context, text: "OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
