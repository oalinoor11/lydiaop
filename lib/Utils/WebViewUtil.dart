import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print', onMessageReceived: (JavascriptMessage message) {}),
].toSet();

class WebViewUtil extends StatefulWidget {
  final int pageType;
  final String loadUrl;
  final String id;
  final String title;

  const WebViewUtil(
      {Key key, this.pageType = 0, this.loadUrl, this.id, this.title = ""})
      : super(key: key);

  @override
  _WebViewUtilState createState() => _WebViewUtilState();
}

class _WebViewUtilState extends State<WebViewUtil> with WidgetsBindingObserver {
  /* Instance of WebView plugin */
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  ScreenUtil screenUtil = ScreenUtil();

  /* Webview Streams */
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  var currentUrl = '';

  String loadHTMLData(webUrl) {
    return '''
      <html>
        <body onload="document.f.submit();">
          <div class="loader"></div>
          <form id="f" name="f" method="post" action="$webUrl">
          </form>
        </body>
      </html>
     ''';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    setUpWebViewStreams();
  }

  setUpWebViewStreams() {
    flutterWebViewPlugin.close();
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {}
    });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          currentUrl = url;
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) async {
      if (mounted) {
        // Actions like show a info toast.
        // _scaffoldKey.currentState.showSnackBar(
        //     const SnackBar(content: const Text('Webview Destroyed')));
      }
    });
  }

  @override
  void dispose() {
    _onDestroy?.cancel();
    _onUrlChanged?.cancel();
    _onStateChanged?.cancel();
    _onHttpError?.cancel();
    flutterWebViewPlugin?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: WebviewScaffold(
            url: widget.loadUrl,
            clearCache: true,
            resizeToAvoidBottomInset: true,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            withZoom: false,
            withLocalStorage: true,
            hidden: true,
            withJavascript: true,
            initialChild: Container(
              height: screenUtil.screenHeight,
              width: screenUtil.screenWidth,
              color: kBackgroundColor2,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
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
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.title}",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: screenUtil.setSp(17.0),
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
