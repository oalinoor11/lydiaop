import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/Notification/widgets/noNotifications.dart';
import 'package:flutter_app/Utils/ErrorWidgetUtil.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/NoInternetAlertUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/notification_bloc.dart';
import 'widgets/notificationCard.dart';

class NotificationScreen extends StatefulWidget {
  final int
      from; // 4. from home screen  //5. from buy screen  6. from trade 7.cashout

  const NotificationScreen({Key key, this.from = 0}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc notificationBloc = NotificationBloc();

  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // network connectivity
  bool isNetworkConnected = true;
  var _connectivitySubscription;
  ConnectivityResult previousConRes;

  int pageNo = 1;
  int pageSize = 10;
  bool isNetworkConnectd = true;

  @override
  void initState() {
    super.initState();
    onNetworkChange();

    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
      } else {
        isNetworkConnected = false;
      }
    });
    notificationBloc.add(
      GetNotificationsEvent(
        pageNo: pageNo,
        pageSize: pageSize,
        prevData: [],
      ),
    );
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

            notificationBloc.add(
              GetNotificationsEvent(
                pageNo: pageNo,
                pageSize: pageSize,
                prevData: [],
                isNetworkConnected: false,
              ),
            );
          } else {
            isNetworkConnected = true;
            notificationBloc.add(
              GetNotificationsEvent(
                pageNo: pageNo,
                pageSize: pageSize,
                prevData: [],
                isNetworkConnected: false,
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      cubit: notificationBloc,
      buildWhen: (prevState, state) {
        if (state is NotificationInitial) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is NotificationLoadingState) {
          return WillPopScope(
            onWillPop: () async {
              handleBack();
              // Navigator.pushReplacementNamed(
              //     context, RouteConst.routeMainDashboard);
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
                child: HelperUtil.commonAppbar(
                  context: context,
                  title: "Notifications",
                  onTap: () {
                    handleBack();
                    // Navigator.pushReplacementNamed(
                    //     context, RouteConst.routeMainDashboard);
                  },
                ),
              ),
              body: HelperUtil.loadingStateWidget(),
            ),
          );
        } else if (state is NotificationLoadedState) {
          return WillPopScope(
            onWillPop: () async {
              handleBack();
              // Navigator.pushReplacementNamed(
              //     context, RouteConst.routeMainDashboard);
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
                child: HelperUtil.commonAppbar(
                  context: context,
                  title: "Notifications",
                  onTap: () {
                    handleBack();
                    // Navigator.pushReplacementNamed(
                    //     context, RouteConst.routeMainDashboard);
                  },
                ),
              ),
              body: state.isNetworkConnected == false
                  ? NoInternetAlertScreen(
                      isFullScreen: true,
                      onTap: retryInternet,
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: HelperUtil.backgroundGradient(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenUtil.setHeight(25),
                          ),
                          state.notificationResult.length > 0
                              ? Expanded(
                                  child:
                                      NotificationListener<ScrollNotification>(
                                    onNotification:
                                        // ignore: missing_return
                                        (ScrollNotification scrollInfo) {
                                      if (scrollInfo.metrics.pixels ==
                                              scrollInfo
                                                  .metrics.maxScrollExtent &&
                                          state.isLoading == false) {
                                        state.isLoading = true;
                                        HelperUtil.checkInternetConnection()
                                            .then((internet) {
                                          if (internet && !state.endPage) {
                                            isNetworkConnected = true;
                                            notificationBloc.add(
                                                GetNotificationsEvent(
                                                    pageNo: state.page,
                                                    pageSize: pageSize,
                                                    prevData: state
                                                        .notificationResult));
                                          } else {
                                            _refreshController.refreshFailed();
                                            isNetworkConnected = false;
                                          }
                                        });
                                      }
                                    },
                                    child: SmartRefresher(
                                      controller: _refreshController,
                                      enablePullDown: true,
                                      enablePullUp: !state.endPage,
                                      onRefresh: () {
                                        retryInternet();
                                      },
                                      child: ListView.builder(
                                        itemCount:
                                            state.notificationResult.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              notificationBloc.add(
                                                MarkNotificationReadEvent(
                                                    notificationId:
                                                        "${state.notificationResult[index].sId}",
                                                    prevData: state
                                                        .notificationResult,
                                                    pageNo: state.page,
                                                    endPage: state.endPage,
                                                    index: index),
                                              );

                                              if (state
                                                      .notificationResult[index]
                                                      .transactionId !=
                                                  null) {
                                                Map<String, dynamic> data = {
                                                  "transDetails":
                                                      state.notificationResult[
                                                          index],
                                                };
                                                Navigator.of(context).pushNamed(
                                                    RouteConst
                                                        .routeNotificationDetailsScreen,
                                                    arguments: {"data": data});
                                              }
                                            },
                                            child: notificationCardWidget(
                                                state.notificationResult[index],
                                                screenUtil),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: noNotificationWidget(screenUtil),
                                  ),
                                ),
                        ],
                      ),
                    ),
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () async {
              handleBack();
              // Navigator.pushReplacementNamed(
              //     context, RouteConst.routeMainDashboard);
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
                child: HelperUtil.commonAppbar(
                  context: context,
                  title: "Notifications",
                  onTap: () {
                    handleBack();
                    // Navigator.pushReplacementNamed(
                    //     context, RouteConst.routeMainDashboard);
                  },
                ),
              ),
              body: ErrorWidgetScreen(
                isFullScreen: true,
                onTap: retryInternet,
              ),
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
        pageNo = 1;
        notificationBloc.add(
          GetNotificationsEvent(
            pageNo: 1,
            pageSize: pageSize,
            prevData: [],
          ),
        );
      } else {
        isNetworkConnected = false;
        toastUtil.showMsg(Constant.noInternetMsg, Colors.black, Colors.white,
            12.0, "short", "bottom");
      }
    });
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
