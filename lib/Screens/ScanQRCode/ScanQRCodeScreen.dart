import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';

class ScanQRCodeScreen extends StatefulWidget {
  final String lidQuantity;
  final String walletAddress;
  final String note;

  const ScanQRCodeScreen(
      {Key key, this.lidQuantity, this.walletAddress, this.note})
      : super(key: key);
  @override
  _ScanQRCodeScreenState createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  ToastUtil toastUtil = ToastUtil();
  ScreenUtil screenUtil = ScreenUtil();

  bool getRes = false;

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //read QR code from image
  final picker = ImagePicker();

  File selectedImage;

  String walletAddress = "";

  @override
  void initState() {
    super.initState();
    walletAddress = widget.walletAddress;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
        child: HelperUtil.commonAppbar(
          context: context,
          title: "Send Lid",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: HelperUtil.backgroundGradient(),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenUtil.setHeight(24)),
                  child: Text(
                    "Scan & Send",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: screenUtil.setSp(16),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: screenUtil.setHeight(17)),
                      height: screenUtil.setWidth(281),
                      width: screenUtil.setWidth(281),
                      child: Image.asset(
                        ImageConst.qrCodeIcon,
                        height: screenUtil.setHeight(274),
                        width: screenUtil.setWidth(281),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: screenUtil.setHeight(26),
                          right: screenUtil.setHeight(24),
                          bottom: screenUtil.setHeight(24),
                          top: screenUtil.setHeight(44)),
                      height: screenUtil.setWidth(230),
                      width: screenUtil.setWidth(230),
                      child: _buildQrView(context),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: screenUtil.setHeight(15)),
                  child: Text(
                    "Scanning",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: screenUtil.setSp(16),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            )),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> data = {
                  "lidQuantity": widget.lidQuantity,
                  "walletAddress": walletAddress,
                  "note": widget.note
                };
                Navigator.of(context).pushReplacementNamed(
                    RouteConst.routeSendLidScreen,
                    arguments: {'data': data});
              },
              child: Container(
                height: screenUtil.setHeight(58),
                width: screenUtil.setWidth(200),
                margin: EdgeInsets.only(bottom: screenUtil.setHeight(36)),
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
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 0),
                        blurRadius: 15.0)
                  ],
                ),
                child: Center(
                  child: Text(
                    "CANCEL SCANNING",
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: screenUtil.setHeight(70),
        decoration: BoxDecoration(
          color: kAppbarColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(0, -7),
              blurRadius: 15,
            ),
            BoxShadow(
              color: kshadowColor2,
              offset: Offset(-5, -5),
              blurRadius: 15,
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            _getPhotoByGallery();
          },
          child: Container(
            margin: EdgeInsets.only(
              top: screenUtil.setHeight(23),
              bottom: screenUtil.setHeight(23),
              left: screenUtil.setHeight(18),
            ),
            height: screenUtil.setHeight(24),
            width: screenUtil.setWidth(24),
            child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  ImageConst.selectGalleryImg,
                  color: kTextColor5,
                  height: screenUtil.setHeight(24),
                  width: screenUtil.setWidth(24),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.transparent,
        borderRadius: 0,
        borderLength: 0,
        borderWidth: 0,
        cutOutSize: screenUtil.setHeight(230),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        String scannedData = "${scanData.code}";
        if (scannedData != null && scannedData != "" && getRes == false) {
          if (scannedData.contains("lidya:")) {
            getRes = true;
            walletAddress = scannedData.replaceAll("lidya:", "");
            Map<String, dynamic> data = {
              "lidQuantity": widget.lidQuantity,
              "walletAddress": walletAddress,
              "note": widget.note
            };
            Navigator.of(context).pushReplacementNamed(
                RouteConst.routeSendLidScreen,
                arguments: {'data': data});
          } else {
            toastUtil.showMsg("Wallet Details not Found", Colors.black,
                Colors.white, 12.0, "short", "bottom");
          }
        }
      });
    });
  }

  // Fetch QR Code Data
  void _getPhotoByGallery() {
    Stream.fromFuture(picker.getImage(source: ImageSource.gallery))
        .flatMap((file) {
      return Stream.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
    }).listen((data) {
      String walletData = data;
      if (walletData != null && walletData != "") {
        if (walletData.contains("lidya:")) {
          walletAddress = walletData.replaceAll("lidya:", "");
          Map<String, dynamic> data = {
            "lidQuantity": widget.lidQuantity,
            "walletAddress": walletAddress,
            "note": widget.note
          };
          Navigator.of(context).pushReplacementNamed(
              RouteConst.routeSendLidScreen,
              arguments: {'data': data});
        } else {
          toastUtil.showMsg("Wallet Details not Found", Colors.black,
              Colors.white, 12.0, "short", "bottom");
        }
      }
    }).onError((error, stackTrace) {
      print(error);
      toastUtil.showMsg("Wallet Details not Found", Colors.black, Colors.white,
          12.0, "short", "bottom");
    });
  }
}
