import 'package:flutter/material.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/communityWidget.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key key}) : super(key: key);
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  ScreenUtil screenUtil = ScreenUtil();
  Service service = Service();

  @override
  void initState() {
    super.initState();
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

        return true;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor2,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
          child: HelperUtil.commonAppbar(
            context: context,
            title: "Community",
            onTap: () {
              handleBack();
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: HelperUtil.backgroundGradient(),
          child: Column(
            children: [
              SizedBox(height: screenUtil.setHeight(18)),
              communityItems(
                  image: ImageConst.redditImage,
                  title: "Reddit",
                  screenUtil: screenUtil,
                  onTap: () {
                    openSocialMedia(service.communityUrl);
                  }),
              communityItems(
                  image: ImageConst.facebookImage,
                  title: "Facebbok",
                  screenUtil: screenUtil,
                  onTap: () {
                    openSocialMedia(service.facebookUrl);
                  }),
              communityItems(
                image: ImageConst.instagramImage,
                title: "Instagram",
                screenUtil: screenUtil,
                onTap: () {
                  openSocialMedia(service.instagramurl);
                },
              ),
              communityItems(
                image: ImageConst.twitterImage,
                title: "Twitter",
                screenUtil: screenUtil,
                onTap: () {
                  openSocialMedia(service.twitterUrl);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  openSocialMedia(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void handleBack() {
    Navigator.pop(context);
  }
}
