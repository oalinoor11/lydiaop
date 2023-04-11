import 'package:flutter/material.dart';

Widget transactionDeatilsRow(String key, String value, screenUtil) {
  return Padding(
    padding: EdgeInsets.only(bottom: screenUtil.setHeight(13)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(top: screenUtil.setHeight(1)),
            child: Text(
              "$key",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: screenUtil.setSp(14.0),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 6,
          child: Container(
            margin: EdgeInsets.only(top: screenUtil.setHeight(1)),
            child: Text(
              value.contains("PAYID-")
                  ? value.replaceAll("PAYID-", "")
                  : "$value",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: screenUtil.setSp(16.0),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
