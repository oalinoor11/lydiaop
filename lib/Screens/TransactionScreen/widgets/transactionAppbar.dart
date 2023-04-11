import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';

import 'transAvailableLidWidget.dart';

// from 0. profile 1. home screen
Widget transactionAppBar(
    context, String profileImage, screenUtil, walletAddress, from) {
  return Container(
    decoration: BoxDecoration(
      color: kAppbarColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          offset: Offset(0, 7),
          blurRadius: 15,
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: screenUtil.setHeight(38.0)),
          child: Row(
            children: [
              Container(
                child: IconButton(
                  icon: Image(
                    image: AssetImage(ImageConst.backArrowIcon),
                    height: screenUtil.setHeight(20),
                    width: screenUtil.setWidth(20),
                  ),
                  onPressed: () {
                    if (from == 1) {
                      Map<String, dynamic> data = {"selectedIndex": 0};
                      Navigator.of(context).pushReplacementNamed(
                          RouteConst.routeMainDashboard,
                          arguments: {"data": data});
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Container(
                child: Text(
                  "Transaction History",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: screenUtil.setSp(17.0),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  HelperUtil.checkInternetConnection().then((internet) {
                    if (internet) {
                      Navigator.of(context)
                          .pushNamed(RouteConst.routeNotificationScreen);
                    } else {
                      ToastUtil().showMsg(Constant.noInternetMsg, Colors.black,
                          Colors.white, 12.0, "short", "bottom");
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: screenUtil.setHeight(15),
                    right: screenUtil.setWidth(12),
                  ),
                  height: screenUtil.setHeight(44),
                  width: screenUtil.setHeight(44),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kBackgroundColor5,
                        kBackgroundColor5,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: kshadowColor3,
                        offset: Offset(-5, -5),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: Image.asset(
                    ImageConst.notificationImg,
                    height: screenUtil.setHeight(44),
                    width: screenUtil.setHeight(44),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HelperUtil.checkInternetConnection().then((internet) {
                    if (internet) {
                      Navigator.of(context)
                          .pushReplacementNamed(RouteConst.routeProfileScreen);
                    } else {
                      ToastUtil().showMsg(Constant.noInternetMsg, Colors.black,
                          Colors.white, 12.0, "short", "bottom");
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: screenUtil.setHeight(15),
                    right: screenUtil.setWidth(18),
                  ),
                  height: screenUtil.setHeight(44),
                  width: screenUtil.setHeight(44),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kBackgroundColor5,
                        kBackgroundColor5,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: kshadowColor3,
                        offset: Offset(-5, -5),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: (profileImage != null && profileImage != "")
                      ? CachedNetworkImage(
                          imageUrl: profileImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            ImageConst.profileDefalutImg,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Image.asset(ImageConst.profileDefalutImg),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        transAvailableLidWidget(screenUtil, walletAddress)
      ],
    ),
  );
}
