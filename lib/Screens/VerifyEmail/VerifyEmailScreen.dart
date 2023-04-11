import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String emailAddess;
  const VerifyEmailScreen({Key key, this.emailAddess}) : super(key: key);
  
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
            right: screenUtil.setWidth(18.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: screenUtil.setHeight(58.0),
                ),
                child: HelperUtil.backButton(
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: screenUtil.setWidth(18.0),
                    top: screenUtil.setHeight(45)),
                child: Text(
                  "Check your email!",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: screenUtil.setSp(24.0),
                      fontFamily: "Poppins"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: screenUtil.setWidth(18.0),
                  top: screenUtil.setHeight(5.0),
                ),
                child: Text(
                  "We have sent a link to your email address ${widget.emailAddess}",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: kTextColor2,
                      fontSize: screenUtil.setSp(16.0),
                      fontFamily: "Poppins"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: screenUtil.setWidth(18.0),
                  top: screenUtil.setHeight(24.0),
                ),
                child: Text(
                  "Please click on the link to create a new security PIN.",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: kTextColor2,
                      fontSize: screenUtil.setSp(16.0),
                      fontFamily: "Poppins"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: screenUtil.setHeight(82),
                  left: screenUtil.setWidth(18.0),
                ),
                child: Center(
                  child: Image.asset(
                    ImageConst.emailIcon,
                    height: screenUtil.setHeight(92.67),
                    width: screenUtil.setWidth(96.7),
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(
                  left: screenUtil.setWidth(18.0),
                  bottom: screenUtil.setHeight(2.0),
                ),
                child: Center(
                  child: Text(
                    "Didn’t receive the link?",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kTextColor4,
                        fontSize: screenUtil.setSp(13.0),
                        fontFamily: "Poppins"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: screenUtil.setWidth(18.0),
                  bottom: screenUtil.setHeight(45.0),
                ),
                child: Center(
                  child: FlatButton(
                    child: Text(
                      "Resend",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kTextColor5,
                          fontSize: screenUtil.setSp(16.0),
                          fontFamily: "Poppins"),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
