import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/BuyScreen/BuyScreen.dart';
import 'package:flutter_app/Screens/CashoutScreen.dart/CashoutScreen.dart';
import 'package:flutter_app/Screens/ShareScreen/ShareScreen.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/availableLidWidget.dart';
import 'Widgets/customNavigationBar.dart';
import '../HomeScreen/HomeScreen.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigation({Key key, this.selectedIndex = 0}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  ScreenUtil screenUtil = ScreenUtil();
  int selectedItem = 0;
  bool alreadyLogin = false;
  String profileImage = "";
  String walletAddress = "";
  DateTime backButtonPressedTime;
  ToastUtil toastUtil = ToastUtil();
  final tab = [
    HomeScreen(),
    BuyScreen(),
    ShareScreen(),
    CashoutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedIndex;
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      profileImage = prefs.getString("profileImage") ?? "";
      walletAddress = prefs.getString("walletId") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime currentTime = DateTime.now();
        if (backButtonPressedTime == null ||
            currentTime.difference(backButtonPressedTime) >
                Duration(seconds: 3)) {
          backButtonPressedTime = currentTime;
          toastUtil.showMsg("Double back to exit", Colors.black, Colors.white,
              12.0, "short", "bottom");
          return false;
        } else {
          exit(0);
        }
        // return true;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor2,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(alreadyLogin == true
              ? screenUtil.setHeight(160) // 215
              : screenUtil.setHeight(85)),
          child: Container(
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
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: alreadyLogin == true
                        ? screenUtil.setHeight(0)
                        : screenUtil.setHeight(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: screenUtil.setWidth(18),
                          top: screenUtil.setHeight(44),
                        ),
                        child: Image(
                          image: AssetImage(
                            ImageConst.textLogoImg,
                          ),
                          height: screenUtil.setHeight(48),
                          width: screenUtil.setWidth(150),
                        ),
                      ),
                      Spacer(),
                      // Wallet
                      GestureDetector(
                        onTap: () {
                          dismissTimer();
                          if (alreadyLogin == true) {
                            Map<String, dynamic> data = {
                              "from": selectedItem == 0
                                  ? 1
                                  : selectedItem == 1
                                      ? 2
                                      : selectedItem == 2
                                          ? 3
                                          : 4
                            };
                            Navigator.of(context).pushNamed(
                                RouteConst.routeReceiveLidScreen,
                                arguments: {"data": data});
                          } else {
                            Map<String, dynamic> data = {
                              "from": selectedItem == 0
                                  ? 4
                                  : selectedItem == 1
                                      ? 5
                                      : selectedItem == 2
                                          ? 6
                                          : 7
                            };
                            Navigator.of(context).pushNamed(
                                RouteConst.routeLoginPage,
                                arguments: {'data': data});
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: screenUtil.setHeight(44),
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
                            ImageConst.walletImage,
                            height: screenUtil.setHeight(44),
                            width: screenUtil.setHeight(44),
                          ),
                        ),
                      ),
                      // Notification
                      GestureDetector(
                        onTap: () {
                          dismissTimer();
                          if (alreadyLogin == true) {
                            Map<String, dynamic> data = {
                              "from": selectedItem == 0
                                  ? 4
                                  : selectedItem == 1
                                      ? 5
                                      : selectedItem == 2
                                          ? 6
                                          : 7
                            };
                            Navigator.of(context).pushNamed(
                                RouteConst.routeNotificationScreen,
                                arguments: {'data': data});
                          } else {
                            Map<String, dynamic> data = {
                              "from": selectedItem == 0
                                  ? 4
                                  : selectedItem == 1
                                      ? 5
                                      : selectedItem == 2
                                          ? 6
                                          : 7
                            };
                            Navigator.of(context).pushNamed(
                                RouteConst.routeLoginPage,
                                arguments: {'data': data});
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: screenUtil.setHeight(44),
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
                      // Profile
                      alreadyLogin == true
                          ? GestureDetector(
                              onTap: () {
                                dismissTimer();
                                Map<String, dynamic> data = {
                                  "from": selectedItem == 0
                                      ? 4
                                      : selectedItem == 1
                                          ? 5
                                          : selectedItem == 2
                                              ? 6
                                              : 7
                                };
                                Navigator.of(context).pushNamed(
                                    RouteConst.routeProfileScreen,
                                    arguments: {'data': data});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: screenUtil.setHeight(44),
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
                                child: profileImage == ""
                                    ? Image.asset(ImageConst.profileDefalutImg)
                                    : CachedNetworkImage(
                                        imageUrl: profileImage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          ImageConst.profileDefalutImg,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                dismissTimer();

                                Map<String, dynamic> data = {
                                  "from": selectedItem == 0
                                      ? 4
                                      : selectedItem == 1
                                          ? 5
                                          : selectedItem == 2
                                              ? 6
                                              : 7
                                };
                                Navigator.of(context).pushNamed(
                                    RouteConst.routeSettingsScreen,
                                    arguments: {'data': data});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: screenUtil.setHeight(44),
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
                                child: Image.asset(
                                  ImageConst.personImg,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                if (alreadyLogin == true)
                  availableLidWidget(screenUtil, walletAddress, alreadyLogin)
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          iconList: [
            ImageConst.homeTabIcon,
            ImageConst.buyTabIcon,
          
            ImageConst.cashoutTabIcon,
            ImageConst.shareTabIcon,
          ],
          iconListFill: [
            ImageConst.homeSelTabIcon,
            ImageConst.buySelTabIcon,
            ImageConst.cashoutSeltabIcon,
            ImageConst.shareselTabIcon,
          ],
          iconTitle: [
            "Home",
            "Buy",
            "Trade",
            "Sell",
          ],
          onChange: (val) async {
            setState(() {
              selectedItem = val;
            });
          },
          defaultSelectedIndex: selectedItem,
        ),
        body: tab[selectedItem],
      ),
    );
  }

  void dismissTimer() {
    if (selectedItem == 0) {
      Global.homeScreenTimer?.cancel();
    } else if (selectedItem == 1) {
      Global.buyScreenTimer?.cancel();
    } else if (selectedItem == 3) {
      Global.cashoutScreenTimer?.cancel();
    }
  }
}
