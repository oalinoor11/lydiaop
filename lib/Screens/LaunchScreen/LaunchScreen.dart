import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Network/DynamicLinkService.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/PushNotification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
    pushNotificationService();
    _dynamicLinkService.handleDynamicLinks().then((_) {});
    Future.delayed(Duration(seconds: 5, milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: screenUtil.screenHeight,
          width: screenUtil.screenWidth,
          child: GifView.asset(
            ImageConst.coinGifIcon,
            height: screenUtil.screenHeight,
            width: screenUtil.screenWidth,
            fit: BoxFit.contain,
            frameRate: 10,
            loop: false,
          ),
          // child: Image(
          //   image: AssetImage(
          //     ImageConst.coinGifIcon,
          //   ),
          //   fit: BoxFit.cover,
          //   height: screenUtil.screenHeight,
          //   width: screenUtil.screenWidth,
          // ),
        ),
      ),
    );
  }
}
