import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/ErrorWidgetUtil.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_app/Utils/noInternetAlertUtil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/transaction_bloc.dart';
import 'widgets/noTransactionWidget.dart';
import 'widgets/transactionAppbar.dart';
import 'widgets/transactionCard.dart';

class TransactionScreen extends StatefulWidget {
  final int from; // 0. From Profile 1. From Home Screen

  const TransactionScreen({Key key, this.from = 0}) : super(key: key);
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  ScreenUtil screenUtil = ScreenUtil();
  TransactionBloc transactionBloc = TransactionBloc();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ToastUtil toastUtil = ToastUtil();
  int selFilterOption = 0; // 1.Buy 2.Trade(send/receive) 3.cashout

  String radioItem = "";

  bool alreadyLogin = false;
  String walletAddress = "";
  String profileImage = "";

  // network connectivity
  bool isNetworkConnected = true;
  var _connectivitySubscription;
  ConnectivityResult previousConRes;

  // Group Value for Radio Button.
  int selId = 0;
  String selStartDate = "dd/mm/yy";
  String selEndDate = "dd/mm/yy";

  DateTime selectedStartDate;
  DateTime selectedEndDate;
  int pageNo = 1;
  int pageSize = 10;
  String type = "";
  String startDate = "";
  String endDate = "";

  List<FilterOption> fList = [
    FilterOption(index: 1, name: "Purchased", postName: "buy"),
    FilterOption(index: 2, name: "Sent", postName: "send"),
    FilterOption(index: 3, name: "Received", postName: "receive"),
    FilterOption(index: 4, name: "Cashed Out", postName: "cashout"),
  ];

  @override
  void initState() {
    super.initState();
    getBasicInfo();

    onNetworkChange();

    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
      } else {
        isNetworkConnected = false;
      }
    });
    transactionBloc.add(
      GetTransactionDeatilsEvent(
        pageNo: pageNo,
        pageSize: pageSize,
        startDate: startDate,
        endDate: endDate,
        type: type,
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

            transactionBloc.add(
              GetTransactionDeatilsEvent(
                pageNo: pageNo,
                pageSize: pageSize,
                startDate: startDate,
                endDate: endDate,
                type: type,
                prevData: [],
                isNetworkConnected: false,
              ),
            );
          } else {
            isNetworkConnected = true;
            transactionBloc.add(
              GetTransactionDeatilsEvent(
                pageNo: pageNo,
                pageSize: pageSize,
                startDate: startDate,
                endDate: endDate,
                type: type,
                prevData: [],
                isNetworkConnected: false,
              ),
            );
          }
        });
      }
    });
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      profileImage = prefs.getString("profileImage") ?? "";
      walletAddress = prefs.getString("walletId") ?? "";
    });
  }

  void retryInternet() {
    HelperUtil.checkInternetConnection().then((internet) {
      if (internet) {
        isNetworkConnected = true;
        transactionBloc.add(
          GetTransactionDeatilsEvent(
            pageNo: pageNo,
            pageSize: pageSize,
            startDate: startDate,
            endDate: endDate,
            type: type,
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

  @override
  void dispose() {
    transactionBloc?.close();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void updateSelectedFiterOption(int option) {
    setState(() {
      selFilterOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      cubit: transactionBloc,
      buildWhen: (prevState, state) {
        if (state is TransactionInitial) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is TransactionLoadingState) {
          return WillPopScope(
            onWillPop: () async {
              if (widget.from == 1) {
                Map<String, dynamic> data = {"selectedIndex": 0};
                Navigator.of(context).pushReplacementNamed(
                    RouteConst.routeMainDashboard,
                    arguments: {"data": data});
              } else {
                Navigator.pop(context);
              }
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  screenUtil.setHeight(175), // 220
                ),
                child: transactionAppBar(context, profileImage, screenUtil,
                    walletAddress, widget.from),
              ),
              body: HelperUtil.loadingWidget(),
            ),
          );
        } else if (state is TransactionLoadedState) {
          return WillPopScope(
            onWillPop: () async {
              if (widget.from == 1) {
                Map<String, dynamic> data = {"selectedIndex": 0};
                Navigator.of(context).pushReplacementNamed(
                    RouteConst.routeMainDashboard,
                    arguments: {"data": data});
              } else {
                Navigator.pop(context);
              }
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(
                  screenUtil.setHeight(175),
                ),
                child: transactionAppBar(context, profileImage, screenUtil,
                    walletAddress, widget.from),
              ),
              body: state.isNetworkConnected == false
                  ? NoInternetAlertScreen(
                      isFullScreen: false,
                      onTap: retryInternet,
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: HelperUtil.backgroundGradient(),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenUtil.setHeight(24),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: screenUtil.setWidth(18),
                                  right: screenUtil.setWidth(18)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      "RECENT TRANSACTIONS",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins",
                                        fontSize: screenUtil.setSp(16.0),
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        ImageConst.filterImg,
                                        color: kTextColor5.withOpacity(0.8),
                                        height: screenUtil.setHeight(18),
                                        width: screenUtil.setWidth(18),
                                      ),
                                      onPressed: () {
                                        clearAllFilters(2);
                                        showFilterBottomModalSheet();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenUtil.setHeight(18),
                            ),
                            state.transResult.length > 0
                                ? Expanded(
                                    child: NotificationListener<
                                        ScrollNotification>(
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
                                              transactionBloc.add(
                                                  GetTransactionDeatilsEvent(
                                                      pageNo: state.page,
                                                      pageSize: pageSize,
                                                      startDate: startDate,
                                                      endDate: endDate,
                                                      type: type,
                                                      prevData:
                                                          state.transResult));
                                            } else {
                                              _refreshController
                                                  .refreshFailed();
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
                                          clearAllFilters(1);
                                        },
                                        child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          itemCount: state.transResult.length,
                                          itemBuilder: (context, index) {
                                            String transType =
                                                "${state.transResult[index].type}";

                                            return transactionCard(
                                                state.transResult[index],
                                                transType,
                                                screenUtil);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: noTransactionWidget(screenUtil),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () async {
              if (widget.from == 1) {
                Map<String, dynamic> data = {"selectedIndex": 0};
                Navigator.of(context).pushReplacementNamed(
                    RouteConst.routeMainDashboard,
                    arguments: {"data": data});
              } else {
                Navigator.pop(context);
              }
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(screenUtil.setHeight(175)),
                child: transactionAppBar(context, profileImage, screenUtil,
                    walletAddress, widget.from),
              ),
              body: ErrorWidgetScreen(
                isFullScreen: false,
                onTap: retryInternet,
              ),
            ),
          );
        }
      },
    );
  }

  // Filter pop up
  showFilterBottomModalSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: Container(
            height: screenUtil.setHeight(460),
            decoration: BoxDecoration(
              color: kBackgroundColor3,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return LimitedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 80,
                            height: 3,
                            decoration: BoxDecoration(
                              color: kTextColor5,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // From date
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          "Start date",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenUtil.setSp(15.0),
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          selectStartDate(context);
                                        },
                                        child: Container(
                                          height: screenUtil.setHeight(44),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: selStartDate == "dd/mm/yy"
                                                  ? 0.5
                                                  : 1,
                                              color: kTextColor3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(27.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Text(
                                                  selStartDate,
                                                  style: TextStyle(
                                                    color: selStartDate ==
                                                            "dd/mm/yy"
                                                        ? kTextColor7
                                                        : Colors.white,
                                                    fontSize:
                                                        screenUtil.setSp(16.0),
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Image(
                                                image: AssetImage(
                                                    ImageConst.dateIcon),
                                                height:
                                                    screenUtil.setHeight(18),
                                                width: screenUtil.setWidth(18),
                                                color:
                                                    selStartDate == "dd/mm/yy"
                                                        ? kTextColor9
                                                            .withOpacity(0.4)
                                                        : kTextColor9
                                                            .withOpacity(1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          "End date",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenUtil.setSp(15.0),
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (selectedStartDate != null) {
                                            Navigator.pop(context);
                                            selectDateEnd(context);
                                          } else {
                                            toastUtil.showMsg(
                                                "Please select start date first",
                                                Colors.black,
                                                Colors.white,
                                                12.0,
                                                "short",
                                                "bottom");
                                          }
                                        },
                                        child: Container(
                                          height: screenUtil.setHeight(44),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: selEndDate == "dd/mm/yy"
                                                  ? 0.5
                                                  : 1,
                                              color: kTextColor3,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(27.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Text(
                                                  selEndDate,
                                                  style: TextStyle(
                                                    color:
                                                        selEndDate == "dd/mm/yy"
                                                            ? kTextColor7
                                                            : Colors.white,
                                                    fontSize:
                                                        screenUtil.setSp(16.0),
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Image(
                                                image: AssetImage(
                                                  ImageConst.dateIcon,
                                                ),
                                                color: selEndDate == "dd/mm/yy"
                                                    ? kTextColor9
                                                        .withOpacity(0.4)
                                                    : kTextColor9
                                                        .withOpacity(1),
                                                height:
                                                    screenUtil.setHeight(18),
                                                width: screenUtil.setWidth(18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Theme(
                            data: Theme.of(context).copyWith(
                                unselectedWidgetColor: kBackgroundColor4,
                                disabledColor: kBackgroundColor4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: fList
                                  .map((data) => Container(
                                        height: screenUtil.setHeight(50),
                                        child: RadioListTile(
                                          activeColor: kTextColor5,
                                          title: Text(
                                            data.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenUtil.setSp(16.0),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          groupValue: selId,
                                          value: data.index,
                                          onChanged: (val) {
                                            setState(() {
                                              radioItem = data.name;
                                              selId = data.index;
                                              type = data.postName;
                                            });
                                          },
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                HelperUtil.checkInternetConnection()
                                    .then((internet) {
                                  if (internet) {
                                    if (selectedStartDate != null &&
                                        selectedEndDate == null) {
                                      toastUtil.showMsg(
                                          "Please select end date",
                                          Colors.black,
                                          Colors.white,
                                          12.0,
                                          "short",
                                          "bottom");
                                    } else {
                                      Navigator.pop(context);
                                      transactionBloc.add(
                                          GetTransactionDeatilsEvent(
                                              pageNo: 1,
                                              pageSize: pageSize,
                                              startDate: startDate,
                                              endDate: endDate,
                                              type: type,
                                              prevData: []));
                                    }
                                  } else {
                                    toastUtil.showMsg(
                                        Constant.noInternetMsg,
                                        Colors.black,
                                        Colors.white,
                                        12.0,
                                        "short",
                                        "bottom");
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(20)),
                                height: screenUtil.setHeight(60),
                                width: screenUtil.setWidth(300),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 6,
                                  ),
                                  gradient: LinearGradient(colors: [
                                    kGradientColor5,
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
                                    "APPLY",
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
                          ),

                          Padding(
                            padding:
                                EdgeInsets.only(top: screenUtil.setHeight(2)),
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  HelperUtil.checkInternetConnection()
                                      .then((internet) {
                                    if (internet) {
                                      Navigator.pop(context);
                                      clearAllFilters(1);
                                    } else {
                                      toastUtil.showMsg(
                                          Constant.noInternetMsg,
                                          Colors.black,
                                          Colors.white,
                                          12.0,
                                          "short",
                                          "bottom");
                                    }
                                  });
                                },
                                child: Text(
                                  "Clear All",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: kTextColor5,
                                      fontSize: screenUtil.setSp(16),
                                      fontFamily: "Poppins"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // 1. clear filter and service  2. only clear filter items
  void clearAllFilters(int from) {
    selStartDate = "dd/mm/yy";
    selEndDate = "dd/mm/yy";
    selectedStartDate = null;
    selectedEndDate = null;
    pageNo = 1;
    type = "";
    startDate = "";
    endDate = "";
    selId = 0;

    if (from == 1) {
      transactionBloc.add(
        GetTransactionDeatilsEvent(
          pageNo: pageNo,
          pageSize: pageSize,
          startDate: startDate,
          endDate: endDate,
          type: type,
          prevData: [],
        ),
      );
    }
  }

  // select Start date
  Future<Null> selectStartDate(BuildContext context) async {
    if (selectedStartDate == null) {
      selectedStartDate = DateTime.now();
    }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(hours: 1)),
      firstDate: DateTime(2008),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kTextColor5,
              onPrimary: Colors.white,
              surface: kTextColor5,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      var _formatter = new DateFormat('dd-MM-yyyy');
      setState(() {
        selectedStartDate = picked;
        selEndDate = "dd/mm/yy";
        selStartDate = _formatter.format(picked);
        endDate = "";
        startDate = DateFormat('yyyy-MM-dd').format(picked);
        showFilterBottomModalSheet();
      });
    } else {
      showFilterBottomModalSheet();
    }
  }

  // Select End Date
  Future<Null> selectDateEnd(BuildContext context) async {
    if (selectedStartDate != null) {
      selectedEndDate = selectedStartDate;
    } else {
      selectedEndDate = DateTime.now();
    }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.add(Duration(hours: 1)),
      firstDate: selectedEndDate,
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kTextColor5,
              onPrimary: Colors.white,
              surface: kTextColor5,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      var _formatter = new DateFormat('dd-MM-yyyy');

      setState(() {
        selEndDate = _formatter.format(picked);
        endDate = DateFormat('yyyy-MM-dd').format(picked);
        showFilterBottomModalSheet();
      });
    } else {
      showFilterBottomModalSheet();
    }
  }
}

class FilterOption {
  String name;
  int index;
  String postName;
  FilterOption({this.name, this.index, this.postName});
}
