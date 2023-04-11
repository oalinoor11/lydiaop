import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/DataModels/GetGoldRateModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Utils/ErrorWidgetUtil.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/NoInternetAlertUtil.dart';
import 'package:flutter_app/Utils/SharedPreferenceUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/checkAppUpdate.dart';
import 'package:flutter_app/Utils/goldRateCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/homepage_bloc.dart';
import 'widgets/dashboardWidget.dart';
import 'widgets/startInvestmentWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  HomepageBloc homeBloc = HomepageBloc();

  ScreenUtil screenUtil = ScreenUtil();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // network connectivity
  bool isNetworkConnected = true;

  var _connectivitySubscription;
  ConnectivityResult previousConRes;

  bool isDashboardScreen = false;
  bool alreadyLogin = false;
  String refreshToken = "";
  String lastSavedDate = "";

  final ValueNotifier<int> showGlow = ValueNotifier<int>(0);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken;

  int counter = 0;
  GetGoldRateModel resData;
  AppLifecycleState curretAppState;
  

  @override
  void initState() {
    super.initState();
    getBasicInfo();
    AppUpdateUtil.checkAppUpdate(context);
    WidgetsBinding.instance.addObserver(this);
    curretAppState = AppLifecycleState.resumed;
    onNetworkChange();
    _firebaseMessaging.getToken().then((String token) {
      fcmToken = token;
      HelperUtil().updateFcmToken(fcmToken);
    });
  }

  void onNetworkChange() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      ConnectivityResult currentConRes = result;
      if (currentConRes != previousConRes) {
        previousConRes = currentConRes;
        setState(() {
          if (result == ConnectivityResult.none) {
            isNetworkConnected = false;
            homeBloc.add(GetGoldRateEvent(alreadyLogin));
          } else {
            isNetworkConnected = true;
            homeBloc.add(GetGoldRateEvent(alreadyLogin));
          }
        });
      }
    });
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      refreshToken = prefs.getString("refreshToken") ?? "";
      lastSavedDate = prefs.getString("lastSavedDate") ?? "";

      Global.homeScreenTimer = Timer.periodic(
          Duration(seconds: 10), (Timer t) => updateGoldValue(alreadyLogin));
    });

    // Refresh Token

    if (alreadyLogin == true && lastSavedDate != null && lastSavedDate != "") {
      final savedDate =
          DateFormat('yyyy-MM-dd').parse(lastSavedDate.toString());

      final currentDate =
          DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
      var dayDifference = currentDate.difference(savedDate).inDays;
      if (dayDifference > 0) {
        HelperUtil().refreshToken(refreshToken);
      }
    } else if (alreadyLogin == true) {
      HelperUtil().refreshToken(refreshToken);
    }

    SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
    _sharedPreference.addSharedPref('navigateHome', "1");

    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
      } else {
        isNetworkConnected = false;
      }
    });
    homeBloc.add(GetGoldRateEvent(alreadyLogin));
  }

  @override
  void dispose() {
    homeBloc.close();
    _connectivitySubscription.cancel();
    showGlow?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Global.homeScreenTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      Global.homeScreenTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      Global.homeScreenTimer = Timer.periodic(
          Duration(seconds: 10), (Timer t) => updateGoldValue(alreadyLogin));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
      cubit: homeBloc,
      builder: (context, state) {
        if (state is HomepageLodingState) {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            body: HelperUtil.loadingStateWidget(),
          );
        } else if (state is HomepageLoadedState) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kBackgroundColor2,
            body: state.isNetworkConnected == false
                ? NoInternetAlertScreen(
                    isFullScreen: false,
                    onTap: retryInternet,
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: HelperUtil.backgroundGradient(),
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      onRefresh: () {
                        homeBloc.add(GetGoldRateEvent(alreadyLogin));
                      },
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenUtil.setHeight(6),
                            ),
                            if (state.resData != null &&
                                state.resData.result != null)
                              Container(
                                height: screenUtil.setHeight(80),
                                margin: EdgeInsets.only(
                                  left: screenUtil.setWidth(5),
                                  right: screenUtil.setWidth(5),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  image: new DecorationImage(
                                    image: new ExactAssetImage(
                                        ImageConst.goldRateCashoutBgImg),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return goldRateCard(screenUtil);
                                  },
                                ),
                              ),
                            (alreadyLogin == true &&
                                    state.dashboardResData.code.toString() ==
                                        "200" &&
                                    state.dashboardResData.result.length > 0)
                                ? dashboardWidget(
                                    context,
                                    state.dashboardResData,
                                    screenUtil,
                                    showGlow,
                                    Global.homeScreenTimer,
                                  )
                                : startInvestment(
                                    context,
                                    alreadyLogin,
                                    screenUtil,
                                    showGlow,
                                    Global.homeScreenTimer,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        } else {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            body: isNetworkConnected == false
                ? NoInternetAlertScreen(
                    isFullScreen: false,
                    onTap: retryInternet,
                  )
                : ErrorWidgetScreen(
                    isFullScreen: false,
                    onTap: retryInternet,
                  ),
          );
        }
      },
    );
  }

  void retryInternet() {
    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
        homeBloc.add(GetGoldRateEvent(alreadyLogin));
      } else {
        isNetworkConnected = false;
        ToastUtil().showMsg(Constant.noInternetMsg, Colors.black, Colors.white,
            12.0, "short", "bottom");
      }
    });
  }
}
