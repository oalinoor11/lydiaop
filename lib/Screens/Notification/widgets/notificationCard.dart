import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/NotificationModel.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_svg/svg.dart';

Widget notificationCardWidget(Result notifications, screenUtil) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: screenUtil.setWidth(18), vertical: screenUtil.setHeight(9)),
    height: screenUtil.setHeight(70),
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [
            kButtonColor2,
            kButtonColor1,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.5, 1.0]),
      boxShadow: [
        BoxShadow(
          color: kshadowColor2,
          offset: Offset(-5, -5),
          blurRadius: 15,
        ),
      ],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Image with background
        Flexible(
          flex: 2,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenUtil.setHeight(11),
              horizontal: screenUtil.setWidth(7),
            ),
            height: screenUtil.setHeight(66),
            width: screenUtil.setWidth(66),
            decoration: BoxDecoration(
                color: kBackgroundColor8,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: Offset(0, 0),
                    blurRadius: 15,
                  )
                ],
                shape: BoxShape.circle),
            child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screenUtil.setWidth(12),
                  vertical: screenUtil.setHeight(12),
                ),

// transId is not there means welcome notification
                child: SvgPicture.asset(
                  notifications.transactionId == null
                      ? ImageConst.congratsImg
                      : notifications.transactionId.type == "receive"
                          ? ImageConst.arrowDownImg
                          : ImageConst.exchangeImg,
                  width: screenUtil.setWidth(24),
                  height: screenUtil.setHeight(24),
                  color: kTextColor5.withOpacity(0.8),
                )),
          ),
        ),

        Flexible(
          flex: 5,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "${notifications.toUser}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenUtil.setSp(15),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: screenUtil.setHeight(5),
                ),
                Container(
                  child: Text(
                    "${notifications.description}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: kTextColor3,
                      fontSize: screenUtil.setSp(12),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),

        Flexible(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(right: screenUtil.setWidth(7)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    "${notifications.createdAtDate}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenUtil.setSp(12),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  height: screenUtil.setHeight(12),
                ),
                Container(
                  child: Container(
                    child: notifications.seen == false
                        ? SvgPicture.asset(
                            ImageConst.dotImg,
                            height: screenUtil.setHeight(10),
                            width: screenUtil.setWidth(10),
                            color: kTextColor5.withOpacity(0.8),
                          )
                        : SizedBox(
                            height: screenUtil.setHeight(10),
                            width: screenUtil.setWidth(10),
                          ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
