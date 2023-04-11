import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorWidgetScreen extends StatelessWidget {
  final Function onTap;
  final bool isFullScreen;
  const ErrorWidgetScreen({Key key, this.onTap, this.isFullScreen = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConst.noInternetBgImg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // image
            Container(
              margin: EdgeInsets.only(
                top: isFullScreen
                    ? screenUtil.setHeight(167)
                    : screenUtil.setHeight(50),
                left: screenUtil.setWidth(117),
                right: screenUtil.setWidth(74),
              ),
              width: screenUtil.setWidth(184),
              height: screenUtil.setHeight(162),
              child: Image.asset(ImageConst.noInternetImg),
            ),

            Container(
              margin: EdgeInsets.only(top: screenUtil.setHeight(24)),
              child: Text(
                "oops!",
                style: TextStyle(
                  fontFamily: "HelveticaNeue",
                  fontSize: screenUtil.setSp(24),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(
                left: screenUtil.setWidth(20),
                right: screenUtil.setWidth(20),
                top: screenUtil.setHeight(42),
              ),
              child: Text(
                "Something went wrong... \nPlease try again!",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: screenUtil.setSp(16),
                  color: kTextColor2,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.only(
                  right: screenUtil.setWidth(42),
                  left: screenUtil.setWidth(42),
                  bottom: isFullScreen
                      ? screenUtil.setHeight(75)
                      : screenUtil.setHeight(40),
                ),
                child: HelperUtil.buttonWithGradientColor(
                    context: context, text: "TRY AGAIN"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
