import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget payableAmountWidget(
    double payableAmount, screenUtil, bool alreadyLogin) {
  return Padding(
    padding: EdgeInsets.only(
        top: alreadyLogin == true
            ? screenUtil.setHeight(25.0)
            : screenUtil.setHeight(40.0)),
    child: Column(
      children: [
        Text(
          "Payable Amount",
          style: TextStyle(
              color: Colors.white,
              fontSize: screenUtil.setSp(15),
              fontFamily: "Poppins"),
        ),
        
        Text(
          "\$${payableAmount.toStringAsFixed(2)}",
          style: TextStyle(
              color: kTextColor16,
              fontSize: screenUtil.setSp(48),
              fontFamily: "Poppins"),
        ),
        Text("This incluces 3% merchant fee", style: TextStyle(color: Colors.amber),),
      ],
    ),
  );
}
