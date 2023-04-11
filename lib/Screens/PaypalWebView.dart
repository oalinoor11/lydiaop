import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/BuyLidPaymentDatamodel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/loaderUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebView extends StatefulWidget {
  final String url;
  final String id;
  final BuyLidPaymentModel paymentDate;
  final int from; // 0. buy  1. from send lid to wallet
  final String pin;
  final String lidQuantity;
  final String walletAddress;
  final String note;
  const PaypalWebView(
      {Key key,
      @required this.url,
      @required this.id,
      this.paymentDate,
      @required this.from,
      this.lidQuantity = "",
      this.note = "",
      this.pin = "",
      this.walletAddress = ""})
      : super(key: key);
  @override
  _PaypalWebViewState createState() => _PaypalWebViewState();
}

class _PaypalWebViewState extends State<PaypalWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();

  Loader loader = Loader();

  bool isLoading = true;

  bool isBackPressed = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isBackPressed == true) {
          handleBackButton();
        } else {
          isBackPressed = true;
          ToastUtil().showMsg("Click back button again to exit from payment",
              Colors.black, Colors.white, 12.0, "short", "bottom");
        }

        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
          child: Container(
            decoration: BoxDecoration(
              color: kAppbarColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 7),
                    blurRadius: 15)
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(
                top: screenUtil.setHeight(54.0),
                bottom: screenUtil.setHeight(15.00),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: screenUtil.setWidth(12.00),
                    ),
                    child: IconButton(
                      icon: Image(
                        image: AssetImage(ImageConst.backArrowIcon),
                        height: screenUtil.setHeight(20),
                        width: screenUtil.setWidth(20),
                      ),
                      onPressed: () {
                        if (isBackPressed == true) {
                          handleBackButton();
                        } else {
                          ToastUtil().showMsg(
                              "Click back button again to exit from payment",
                              Colors.black,
                              Colors.white,
                              12.0,
                              "short",
                              "bottom");
                        }
                        isBackPressed = true;
                        return true;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.contains("intermediate")) {
                  final uri = Uri.parse(request.url);
                  final paymentId = uri.queryParameters['paymentId'];
                  final token = uri.queryParameters['token'];
                  final payerId = uri.queryParameters['PayerID'];

                  Map<String, dynamic> data = {
                    "lidQuantity": "${widget.lidQuantity}",
                    "isFrom": widget.from == 0 ? 3 : 5,
                    "paymentData": widget.paymentDate,
                    "paymentId": "$paymentId",
                    "token": "$token",
                    "payerId": "$payerId",
                    "pin": "${widget.pin}",
                    "walletAddress": widget.walletAddress,
                    "note": widget.note,
                  };
                  Navigator.of(context).pushNamed(
                      RouteConst.routeEnterPinScreen,
                      arguments: {"data": data});
                }
                if (request.url.contains("something/went/wrong")) {
                  paymentFailedAlert();

                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(RouteConst.routeMainDashboard);
                  });
                }

                if (request.url.contains("paypal/error")) {
                  handleBackButton();
                }

                if (request.url.contains("paypal/cancel/update")) {
                  handleBackButton();
                }
                return NavigationDecision.navigate;
              },
            ),
            isLoading
                ? Container(
                    height: screenUtil.screenHeight,
                    width: screenUtil.screenWidth,
                    color: kBackgroundColor2,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }

  handleBackButton() {
    loader.showValueLoader("Cancelling purchase", context);
    Map<String, dynamic> resObj;
    Service().paymentCancelledService(transactionId: widget.id).then((resData) {
      resObj = resData;
      if (resObj['code'].toString() == "200") {
        if (loader.pr.isOpen()) {
          loader.hideValueLoader(context);
        }
        Navigator.of(context)
            .pushReplacementNamed(RouteConst.routeMainDashboard);
      } else {
        if (loader.pr.isOpen()) {
          loader.hideValueLoader(context);
        }
        Navigator.of(context)
            .pushReplacementNamed(RouteConst.routeMainDashboard);
      }
    });
  }

  void paymentFailedAlert() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenUtil.setWidth(339),
              height: screenUtil.setHeight(120),
              child: Container(
                decoration: BoxDecoration(
                  color: kAppbarColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(0, 0),
                        blurRadius: 15),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Payment Failed!",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(24.0),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
}
