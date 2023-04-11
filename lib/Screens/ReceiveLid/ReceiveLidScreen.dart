import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveLidScreen extends StatefulWidget {
  final int from;
  // 1=> home screen 2=> buy 3=> trade 4=> cashout 5=> transaction 6=> Receive Lids from another wallet

  const ReceiveLidScreen({Key key, @required this.from}) : super(key: key);
  @override
  _ReceiveLidScreenState createState() => _ReceiveLidScreenState();
}

class _ReceiveLidScreenState extends State<ReceiveLidScreen> {
  bool alreadyLogin = false;
  String walletAddress = "";
  GlobalKey globalKey = new GlobalKey();

  ScreenUtil screenUtil = ScreenUtil();

  final ValueNotifier<int> showGlow = ValueNotifier<int>(0);
  final ValueNotifier<int> showCopyIcon = ValueNotifier<int>(1);

  @override
  void initState() {
    super.initState();
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      walletAddress = prefs.getString("walletId") ?? "";
    });
  }

  @override
  void dispose() {
    showCopyIcon?.dispose();
    showGlow?.dispose();
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
            title: widget.from == 6 ? "Receive Lid" : "",
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
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  margin: EdgeInsets.only(top: screenUtil.setHeight(24)),
                  height: screenUtil.setHeight(448),
                  width: screenUtil.setWidth(339),
                  decoration: BoxDecoration(
                    color: kAppbarColor.withOpacity(0.5),
                    border: Border.all(
                      width: 1,
                      color: kGradientColor6.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Scan Text
                      Container(
                        margin:
                            EdgeInsets.only(top: screenUtil.setHeight(24.0)),
                        child: Text(
                          "Scan",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: screenUtil.setSp(16.0)),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Generated QR Code Form Wallet ID
                      Container(
                        width: screenUtil.setHeight(258),
                        height: screenUtil.setHeight(258),
                        margin: EdgeInsets.only(
                          top: screenUtil.setHeight(19),
                          left: screenUtil.setWidth(40),
                          right: screenUtil.setWidth(40),
                        ),
                        child: QrImage(
                          backgroundColor: Colors.white,
                          data: "lidya:$walletAddress",
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),

                      // Divider
                      Container(
                        margin: EdgeInsets.only(top: screenUtil.setHeight(24)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                height: 0.5,
                                decoration: BoxDecoration(
                                  color: kTextColor9.withOpacity(0.4),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: screenUtil.setSp(16.0),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Flexible(
                              child: Container(
                                height: 0.5,
                                decoration: BoxDecoration(
                                  color: kTextColor9.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Address and copy function

                      Container(
                        margin: EdgeInsets.only(
                          top: screenUtil.setHeight(10),
                          bottom: screenUtil.setHeight(18),
                          left: screenUtil.setWidth(12),
                          right: screenUtil.setWidth(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Wallet address
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "Wallet Address",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: screenUtil.setSp(12.0),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "$walletAddress",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor2,
                                        fontSize: screenUtil.setSp(16.0),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Copy Icon

                            ValueListenableBuilder(
                                valueListenable: showCopyIcon,
                                builder:
                                    (context, isShowCopyIcon, Widget child) {
                                  return isShowCopyIcon == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(
                                              new ClipboardData(
                                                  text: "$walletAddress"),
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
                                            width: screenUtil.setWidth(24),
                                            height: screenUtil.setHeight(24),
                                            child: Image(
                                              image: AssetImage(
                                                ImageConst.copyAddressIcon,
                                              ),
                                              height: screenUtil.setHeight(24),
                                              width: screenUtil.setWidth(24),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              if (widget.from == 6)
                HelperUtil.glowButtonWithText(
                  showGlow: showGlow,
                  value: 1,
                  onTap: () {
                    showGlow.value = 1;
                    showCopyIcon.value = 0;
                    HelperUtil.showLoaderDialog(context);
                    Future.delayed(Duration(milliseconds: 500), () {
                      showCopyIcon.value = 0;
                      showGlow.value = 0;
                      _captureAndSharePng();
                      Navigator.pop(context);
                      showCopyIcon.value = 1;
                    });
                  },
                  btnText: "TRADE",
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Share QR Code
  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      if (Platform.isAndroid) {
        Share.shareFiles([file.path],
            text: "Wallet Address: $walletAddress", subject: "Lidya");
      } else {
        Share.shareFiles([file.path], subject: "Lidya");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void handleBack() {
    if (widget.from == 1) {
      Map<String, dynamic> data = {"selectedIndex": 0};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 2) {
      Map<String, dynamic> data = {"selectedIndex": 1};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 3) {
      Map<String, dynamic> data = {"selectedIndex": 2};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else if (widget.from == 4) {
      Map<String, dynamic> data = {"selectedIndex": 3};
      Navigator.of(context).pushReplacementNamed(RouteConst.routeMainDashboard,
          arguments: {"data": data});
    } else {
      Navigator.pop(context);
    }
  }
}
