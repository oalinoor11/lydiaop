import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget investmentDetailsRow({String title, String amount, screenUtil}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: Padding(
          padding: EdgeInsets.only(top: screenUtil.setHeight(8.5)),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: kTextColor14,
                fontSize: screenUtil.setSp(14.0),
                fontFamily: "Poppins"),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      if (amount.contains("Lid"))
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(top: screenUtil.setHeight(9.7)),
            child: Text(
              amount.split("Lid")[0] + "Lid",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kTextColor16,
                  fontSize: screenUtil.setSp(14.0),
                  fontFamily: "Poppins"),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      Expanded(
        flex: 4,
        child: Padding(
          padding: EdgeInsets.only(top: screenUtil.setHeight(9.7)),
          child: Text(
            (amount.contains("Lid")) ? amount.split("Lid")[1] : "$amount",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: kTextColor16,
                fontSize: screenUtil.setSp(14.0),
                fontFamily: "Poppins"),
            textAlign: TextAlign.end,
          ),
        ),
          ],
  );
}
