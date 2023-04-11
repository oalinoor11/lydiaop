import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';

Widget dashedLine(screenUtil) {
  return Container(
    margin: EdgeInsets.only(
      top: screenUtil.setHeight(26),
      bottom: screenUtil.setHeight(33),
    ),
    child: Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = 5.0;
          final dashHeight = 1.2;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: kTextColor3),
                ),
              );
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
          );
        },
      ),
    ),
  );
}
