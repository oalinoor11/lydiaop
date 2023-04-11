import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/DashboardDataModel.dart';
import 'package:flutter_app/DataModels/GetGoldRateModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/SharedPreferenceUtil.dart';
import 'package:meta/meta.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageLodingState());

  @override
  Stream<HomepageState> mapEventToState(
    HomepageEvent event,
  ) async* {
    if (event is GetGoldRateEvent) {
      yield* _maptoGetGoldRateEventDatatoState(event);
    }
  }

  Stream<HomepageState> _maptoGetGoldRateEventDatatoState(
      GetGoldRateEvent event) async* {
    GetGoldRateModel resData;
    bool isNetworkConnected = true;

    DashboardDataModel dashboardResData;

    try {
      getGoldRateDetails() async {
        await HelperUtil.checkInternetConnection().then((internet) async {
          if (internet) {
            isNetworkConnected = true;
            await Service()
                .getGoldRateApi(event.alreadyLogin)
                .then((GetGoldRateModel respObj) {
              resData = respObj;
              if (resData.code.toString() == "200" && resData.result != null) {
                Global.availableLidCount.value =
                    resData.result.userBalance.toString();
                Global.lidValue.value =
                    double.parse(resData.result.perGramGoldRate.toString());
                Global.deltaGoldValue.value =
                    double.parse(resData.result.deltaGoldValue.toString());
                Global.deltaGoldPercentage.value =
                    double.parse(resData.result.deltaGoldPercentage.toString());
                Global.currentUsdValue.value =
                    double.parse(Global.availableLidCount.value) *
                            Global.lidValue.value ??
                        0;
              }
            });
          } else {
            isNetworkConnected = false;
          }
        });
      }

      getDashboardDetails() async {
        await HelperUtil.checkInternetConnection().then((internet) async {
          if (internet) {
            await Service()
                .getDashboardSummaryService(event.alreadyLogin)
                .then((DashboardDataModel respObj) {
              dashboardResData = respObj;

              SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
              if (dashboardResData.code.toString() == "200" &&
                  dashboardResData.result.length > 0) {
                _sharedPreference.addSharedPref('cashout', "true");
              } else {
                _sharedPreference.addSharedPref('cashout', "false");
              }
            });
          }
        });
      }

      yield HomepageLodingState();
      await getGoldRateDetails();
      if (event.alreadyLogin) {
        await getDashboardDetails();
      }

      yield HomepageLoadedState(
          resData: resData,
          isNetworkConnected: isNetworkConnected,
          dashboardResData: dashboardResData);
    } catch (e) {
      yield HomepageErrorState();
    }
  }
}
