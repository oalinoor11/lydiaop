import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/GetGoldRateModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Resources/Global.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'cashout_event.dart';
part 'cashout_state.dart';

class CashoutBloc extends Bloc<CashoutEvent, CashoutState> {
  CashoutBloc() : super(CashoutLoadingState());

  @override
  Stream<CashoutState> mapEventToState(
    CashoutEvent event,
  ) async* {
    if (event is GetGoldRateEvent) {
      yield* _maptoGetGoldRateEventDatatoState(event);
    }
  }

  Stream<CashoutState> _maptoGetGoldRateEventDatatoState(
      GetGoldRateEvent event) async* {
    GetGoldRateModel resData;
    bool isNetworkConnected = true;

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

      yield CashoutLoadingState();
      await getGoldRateDetails();
      yield CashoutLoadedState(
          resData: resData, isNetworkConnected: isNetworkConnected);
    } catch (e) {
      yield CashoutErrorState();
    }
  }
}
