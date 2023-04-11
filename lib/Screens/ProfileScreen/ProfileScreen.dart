import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/menuItemWidget.dart';

class ProfileScreen extends StatefulWidget {
  final int
      from; // 4. from home screen  //5. from buy screen  6. from trade 7.cashout

  const ProfileScreen({Key key, this.from = 0}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScreenUtil screenUtil = ScreenUtil();
  String profileImage = "";
  bool alreadyLogin;
  String firstName = "";
  String lastName = "";
  String id = "";
  String walletId = "";

  bool isAppleLogin = false;

  @override
  void initState() {
    super.initState();
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      isAppleLogin = prefs.getString("isAppleLogin") == "true" ? true : false;
      profileImage = prefs.getString("profileImage") ?? "";
      firstName = prefs.getString("firstName") ?? "";
      lastName = prefs.getString("lastName") ?? "";
      id = prefs.getString("id") ?? "";
      walletId = prefs.getString("walletId") ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBack();
        // Navigator.of(context)
        //     .pushReplacementNamed(RouteConst.routeMainDashboard);
        return true;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor2,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            screenUtil.setHeight(224),
          ),
          child: Container(
            width: screenUtil.screenWidth,
            decoration: BoxDecoration(
              color: kAppbarColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenUtil.setHeight(50.0)),
                  child: Row(
                    children: [
                      HelperUtil.backButton(
                        context: context,
                        onTap: () {
                          handleBack();
                          // Navigator.of(context).pushReplacementNamed(
                          //     RouteConst.routeMainDashboard);
                          // Navigator.pop(context);
                        },
                      ),
                      Container(
                        child: Text(
                          "My Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: screenUtil.setSp(17.0),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: screenUtil.setWidth(17)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                // left: screenUtil.setWidth(18),
                                top: screenUtil.setHeight(28),
                              ),
                              child: Text(
                                "$firstName $lastName",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: screenUtil.setSp(18.0),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(5),
                                  ),
                                  // left: screenUtil.setWidth(18)),
                                  child: Text(
                                    "Wallet Address: $walletId",
                                    style: TextStyle(
                                        color: kTextColor3,
                                        fontFamily: "Poppins",
                                        fontSize: screenUtil.setSp(13.0),
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      new ClipboardData(text: "$walletId"),
                                    );
                                    ToastUtil().showMsg(
                                        "Copied to Clipboard",
                                        Colors.black,
                                        Colors.white,
                                        12.0,
                                        "short",
                                        "bottom");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: screenUtil.setWidth(5)),
                                    child: Image(
                                      image: AssetImage(
                                          ImageConst.copyAddressIcon),
                                      height: screenUtil.setHeight(18),
                                      width: screenUtil.setWidth(18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RouteConst.routeEditProfileScreen);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: screenUtil.setHeight(20)),
                                    child: Text(
                                      "View Profile",
                                      style: TextStyle(
                                          color: kTextColor5,
                                          fontFamily: "Poppins",
                                          fontSize: screenUtil.setSp(18.0),
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: screenUtil.setHeight(20),
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        ImageConst.arrowIcon,
                                      ),
                                      height: screenUtil.setHeight(20),
                                      width: screenUtil.setWidth(20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: screenUtil.setHeight(5),
                          right: screenUtil.setWidth(15),
                        ),
                        child: profileImage == ""
                            ? Image.asset(
                                ImageConst.profileDefalutImg,
                                height: screenUtil.setHeight(111),
                                width: screenUtil.setHeight(111),
                                fit: BoxFit.fill,
                              )
                            : CachedNetworkImage(
                                imageUrl: profileImage,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  ImageConst.profileDefalutImg,
                                  fit: BoxFit.fill,
                                ),
                                height: screenUtil.setHeight(111),
                                width: screenUtil.setHeight(111),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 224,
            //width: double.infinity,
            decoration: HelperUtil.backgroundGradient(),
            child: Column(
              children: [
                SizedBox(height: screenUtil.setHeight(18)),
                // Transaction
                menuIconWidget(
                    title: "Transactions",
                    image: ImageConst.transactionImg,
                    screenUtil: screenUtil,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteConst.routeTransactionScreen);
                    }),
                // Gold
                menuIconWidget(
                    image: ImageConst.goldImg,
                    title: "Your Gold",
                    screenUtil: screenUtil,
                    onTap: () {
                      print(Service().basicUrl + Service().goldUrl);
                      Map<String, dynamic> data = {};
                      data['data'] = {
                        "webUrl": Service().basicUrl + Service().goldUrl,
                        "title": "Your Gold",
                        "id": "1"
                      };
                      Navigator.of(context).pushNamed(
                        RouteConst.routeWebViewScreen,
                        arguments: data,
                      );
                    }),

                // Price & Fee
                menuIconWidget(
                    image: ImageConst.goldImg,
                    title: "Price & Fee",
                    screenUtil: screenUtil,
                    onTap: () {
                      print(Service().basicUrl + Service().priceFeeUrl);
                      Map<String, dynamic> data = {};
                      data['data'] = {
                        "webUrl": Service().basicUrl + Service().priceFeeUrl,
                        "title": "Price & Fee",
                        "id": "1"
                      };
                      Navigator.of(context).pushNamed(
                        RouteConst.routeWebViewScreen,
                        arguments: data,
                      );
                    }),

                menuIconWidget(
                    image: ImageConst.vaultImg,
                    title: "Gold Vault",
                    screenUtil: screenUtil,
                    onTap: () {
                      Map<String, dynamic> data = {};
                      data['data'] = {
                        "webUrl": Service().basicUrl + Service().tdsvaultUrl,
                        "title": "",
                        "id": "1"
                      };
                      Navigator.of(context).pushNamed(
                        RouteConst.routeWebViewScreen,
                        arguments: data,
                      );
                    }),
                menuIconWidget(
                    image: ImageConst.redeemIcon,
                    title: "Redeem Your Gold",
                    screenUtil: screenUtil,
                    onTap: () {
                      Map<String, dynamic> data = {};
                      data['data'] = {
                        "webUrl": Service().basicUrl + Service().redeemUrl,
                        "title": "",
                        "id": "1"
                      };
                      Navigator.of(context).pushNamed(
                        RouteConst.routeWebViewScreen,
                        arguments: data,
                      );
                    }),
                menuIconWidget(
                    image: ImageConst.lidIcon,
                    title: "Lidya Coin",
                    screenUtil: screenUtil,
                    onTap: () {
                      ToastUtil().showMsg("Coming Soon", Colors.black,
                          Colors.white, 12.0, "short", "bottom");
                      // Map<String, dynamic> data = {};
                      // data['data'] = {
                      //   "webUrl": Service().basicUrl + Service().lidyaCoinUrl,
                      //   "title": "",
                      //   "id": "1"
                      // };
                      // Navigator.of(context).pushNamed(
                      //   RouteConst.routeWebViewScreen,
                      //   arguments: data,
                      // );
                    }),

                menuIconWidget(
                    title: "Settings",
                    image: ImageConst.settingsImg,
                    screenUtil: screenUtil,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteConst.routeSettingsScreen);
                    }),
                menuIconWidget(
                    image: ImageConst.communityImg,
                    title: "Community",
                    screenUtil: screenUtil,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteConst.routeCommunityScreen);
                    }),
                menuIconWidget(
                    title: "Logout",
                    screenUtil: screenUtil,
                    image: ImageConst.logoutImg,
                    onTap: () => showLogoutAlert()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logout Alert
  void showLogoutAlert() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: screenUtil.setWidth(339),
            height: screenUtil.setHeight(194),
            child: Container(
              decoration: BoxDecoration(
                color: kBackgroundColor9,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 0),
                      blurRadius: 15),
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Are you sure you want to log out?",
                        style: TextStyle(
                            color: kTextColor3,
                            fontFamily: "Poppins",
                            fontSize: screenUtil.setSp(18.0),
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: screenUtil.setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await clearData();
                            Map<String, dynamic> data = {"from": 1};
                            Navigator.of(context).pushReplacementNamed(
                                RouteConst.routeLoginPage,
                                arguments: {'data': data});
                          },
                          child: Container(
                            height: screenUtil.setHeight(60),
                            width: screenUtil.setWidth(155),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                width: 6,
                              ),
                              gradient: LinearGradient(colors: [
                                kTextColor3,
                                kGradientColor6,
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 0),
                                    blurRadius: 15.0)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "YES, LOG OUT!",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: kTextColor8,
                                  fontSize: screenUtil.setSp(16.0),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: screenUtil.setHeight(60),
                            width: screenUtil.setWidth(155),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              gradient: LinearGradient(colors: [
                                kGradientColor3,
                                kGradientColor4,
                              ]),
                              border: Border.all(
                                width: 6,
                                color: kBackgroundColor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 0),
                                    blurRadius: 15.0)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: kTextColor,
                                    fontSize: screenUtil.setSp(16.0)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: screenUtil.screenHeight / 2 -
                    (screenUtil.setHeight(194) / 2)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  // clearing user data
  clearData() async {
    Global.availableLidCount.value = "0";
    Global.lidValue.value = 0.0;
    Global.deltaGoldValue.value = 0.0;
    Global.deltaGoldPercentage.value = 0.0;
    Global.currentUsdValue.value = 0.0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if (isAppleLogin) {
      signOutFromApple();
    } else {
      signOutWithGoogle();
    }

    return true;
  }

  // sign out from apple
  Future<void> signOutFromApple() async {
    await FirebaseAuth.instance.signOut();
  }

  // sign out from google
  Future signOutWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
        ],
      );
      try {
        await _googleSignIn.signOut();
      } catch (error) {}
    } catch (e) {}
  }

  void handleBack() {
    if (widget.from == 4) {
      Map<String, dynamic> data = {"selectedIndex": 0};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 5) {
      Map<String, dynamic> data = {"selectedIndex": 1};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 6) {
      Map<String, dynamic> data = {"selectedIndex": 2};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 7) {
      Map<String, dynamic> data = {"selectedIndex": 3};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else {
      Map<String, dynamic> data = {"selectedIndex": 0};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    }
  }
}
