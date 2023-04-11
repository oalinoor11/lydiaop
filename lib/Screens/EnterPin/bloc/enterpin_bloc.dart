import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/BuyLidPaymentDatamodel.dart';
import 'package:flutter_app/DataModels/CashoutModel.dart';
import 'package:flutter_app/DataModels/PaymentChargesModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'enterpin_event.dart';
part 'enterpin_state.dart';

class EnterpinBloc extends Bloc<EnterpinEvent, EnterpinState> {
  EnterpinBloc() : super(EnterpinLoadedState());

  @override
  Stream<EnterpinState> mapEventToState(
    EnterpinEvent event,
  ) async* {
    if (event is ProceedPaymentEvent) {
      yield* _mapProceedPaymentEventDatatoState(event);
    }

    if (event is SendLidToAnotherWalletEvent) {
      yield* _mapSendLidToWalletEventDatatoState(event);
    }

    if (event is CashoutEvent) {
      yield* _mapCashoutEventDatatoState(event);
    }
  }

  Stream<EnterpinState> _mapProceedPaymentEventDatatoState(
      ProceedPaymentEvent event) async* {
    BuyLidPaymentModel resData;
    bool isNetworkConnected = true;

    createPayment() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .creatPaymentService(
                  pin: event.pin, lidQuantity: event.lidQuantity)
              .then((BuyLidPaymentModel respObj) {
            resData = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield EnterpinInitial();
    await createPayment();
    yield ProceedPaymentState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }

  Stream<EnterpinState> _mapSendLidToWalletEventDatatoState(
      SendLidToAnotherWalletEvent event) async* {
    PaymentChargesModel resData;
    bool isNetworkConnected = true;

    sendLidToWallet() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .getPaymentChargesService(
                  pin: event.pin,
                  lidQuantity: event.lidQuantity,
                  walletAddress: event.walletAddress,
                  note: event.note)
              .then((PaymentChargesModel respObj) {
            resData = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield EnterpinInitial();
    await sendLidToWallet();
    yield SendLidToWalletState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }

  Stream<EnterpinState> _mapCashoutEventDatatoState(CashoutEvent event) async* {
    CashoutModel resData;
    bool isNetworkConnected = true;

    sendLidToWallet() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .cashoutService(pin: event.pin, lidQuantity: event.lidQuantity)
              .then((CashoutModel respObj) {
            resData = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield EnterpinInitial();
    await sendLidToWallet();
    yield CashoutState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }
}
