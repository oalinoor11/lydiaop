import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/TransactionModel.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget transactionCard(Result transaction, String transType, screenUtil) {
  transType = "buy";
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0, top: 10),
    child: Container(
      margin: EdgeInsets.only(
        left: screenUtil.setWidth(16),
        right: screenUtil.setWidth(16),
      ),
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
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: screenUtil.setWidth(9),
                right: screenUtil.setWidth(9),
                top: screenUtil.setHeight(12),
                bottom: screenUtil.setHeight(12)),
            height: screenUtil.setHeight(48),
            width: screenUtil.setWidth(48),
            decoration: BoxDecoration(
              color: kGradientColor5,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "${transaction.date}",
                    style: TextStyle(
                      color: kTextColor10,
                      fontSize: screenUtil.setSp(18.0),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: screenUtil.setWidth(48),
                  child: Text(
                    "${transaction.month}",
                    style: TextStyle(
                      color: kTextColor10,
                      fontSize: screenUtil.setSp(12.0),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "${transaction.title}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenUtil.setSp(16.0),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  child: Text(
                    "${transaction.sId}",
                    style: TextStyle(
                      color: kTextColor3,
                      fontSize: screenUtil.setSp(11.5),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(right: screenUtil.setWidth(9)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "${transaction.lid}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenUtil.setSp(16.0),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: screenUtil.setHeight(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: (transaction.type == "Purchased" ||
                              transaction.type == "Received")
                          ? kTextColor12
                          : kTextColor11,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        "${transaction.type}",
                        style: TextStyle(
                          color: (transaction.type == "Purchased" ||
                                  transaction.type == "Received")
                              ? kTextColor12
                              : kTextColor11,
                          fontSize: screenUtil.setSp(13.0),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
