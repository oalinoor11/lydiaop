import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/GetGoldRateModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget goldRateCard(ScreenUtil screenUtil) {
  return Container(
    height: screenUtil.setHeight(80),
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            top: screenUtil.setHeight(25),
            left: screenUtil.setWidth(15),
            right: screenUtil.setWidth(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: screenUtil.setWidth(22),
                ),
                child: Text(
                  "Gold Gram",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: screenUtil.setSp(15.5),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: Global.lidValue,
                builder: (context, value, widget) {
                  final _price = value * (1 + Constant.buyFee);
                  return Container(
                    child: Text(
                      "\$ ${_price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: screenUtil.setSp(24.0),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: Global.deltaGoldValue,
                builder: (context, value, widget) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: screenUtil.setWidth(23),
                    ),
                    child: (value >= 0.00)
                        ? Row(
                            children: [
                              Text(
                                "+ ${value.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: kTextColor15,
                                  fontSize: screenUtil.setSp(12.0),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              ValueListenableBuilder(
                                valueListenable: Global.deltaGoldPercentage,
                                builder: (context, deltaValue, widget) {
                                  return Text(
                                    " ( ${deltaValue.toStringAsFixed(2)}%)",
                                    style: TextStyle(
                                      color: kTextColor15,
                                      fontSize: screenUtil.setSp(12.0),
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.end,
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Image.asset(
                                  ImageConst.greenArrowIcon,
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "${value.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: screenUtil.setSp(12.0),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              ValueListenableBuilder(
                                valueListenable: Global.deltaGoldPercentage,
                                builder: (context, deltaValue, widget) {
                                  return Text(
                                    " ( ${deltaValue.toStringAsFixed(2)}%)",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenUtil.setSp(12.0),
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Image.asset(
                                  ImageConst.redArrowIcon,
                                ),
                              )
                            ],
                          ),
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

void updateGoldValue(alreadyLogin) {
  GetGoldRateModel resData;

  HelperUtil.checkInternetConnection().then((internet) async {
    if (internet) {
      await Service()
          .getGoldRateApi(alreadyLogin)
          .then((GetGoldRateModel respObj) {
        resData = respObj;
        if (resData.code.toString() == "200" && resData.result != null) {
          Global.availableLidCount.value =
              resData.result.userBalance.toString();
          Global.lidValue.value =
              double.parse(resData.result.perGramGoldRate.toString());
          Global.deltaGoldValue.value =
              double.parse(resData.result.deltaGoldValue.toString());
          Global.deltaGoldPercentage.value =
              double.parse(resData.result.deltaGoldPercentage.toString());
          Global.currentUsdValue.value =
              double.parse(Global.availableLidCount.value) *
                      Global.lidValue.value ??
                  0;
        }
      });
    }
  });
}
