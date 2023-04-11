import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/TransactionModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionLoadingState());

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is GetTransactionDeatilsEvent) {
      yield* _maptoGetTransactionEventDatatoState(event);
    }
  }

  Stream<TransactionState> _maptoGetTransactionEventDatatoState(
      GetTransactionDeatilsEvent event) async* {
    TransactionModel resData;
    List<Result> transResult = [];
    int page = event.pageNo;
    bool isLoading = true;
    bool endPage = false;
    bool isNetworkConnected = true;

    try {
      getTransactionData() async {
        await HelperUtil.checkInternetConnection().then((internet) async {
          if (internet) {
            isNetworkConnected = true;
            await Service()
                .transactionDetailsService(
                    type: event.type,
                    pageNo: event.pageNo,
                    pageSize: event.pageSize,
                    startDate: event.startDate,
                    endDate: event.endDate)
                .then((TransactionModel respObj) {
              resData = respObj;

              if (resData.code.toString() == "200") {
                endPage = false;

                if (respObj.result.length > 0 && event.prevData != null) {
                  event.prevData.addAll(resData.result);
                  transResult = event.prevData;
                } else if (respObj.result.length == 0 &&
                    event.prevData != null) {
                  endPage = true;
                  transResult = event.prevData;
                }
                page++;
                isLoading = false;
              } else {
                endPage = true;
                isLoading = false;
              }
            });
          } else {
            endPage = true;
            isLoading = false;
            isNetworkConnected = false;
          }
        });
      }

      if (event.pageNo == 1) {
        yield TransactionLoadingState();
      } else {
        yield TransactionInitial();
      }

      await getTransactionData();
      yield TransactionLoadedState(
        respData: resData,
        transResult: transResult,
        page: page,
        endPage: endPage,
        isLoading: isLoading,
        isNetworkConnected: isNetworkConnected,
      );
    } catch (e) {
      yield TransactionErrorState();
    }
  }
}
