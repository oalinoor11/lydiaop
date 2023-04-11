import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'resetpin_event.dart';
part 'resetpin_state.dart';

class ResetpinBloc extends Bloc<ResetpinEvent, ResetpinState> {
  ResetpinBloc() : super(ResetpinLoadedState());

  @override
  Stream<ResetpinState> mapEventToState(
    ResetpinEvent event,
  ) async* {
    if (event is ReSetSecurityPinEvent) {
      yield* _mapReSetPinEventDatatoState(event);
    }
  }

  Stream<ResetpinState> _mapReSetPinEventDatatoState(
      ReSetSecurityPinEvent event) async* {
    Map<String, dynamic> resData;
    bool isNetworkConnected = true;

    reSetPinService() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .resetPinService(pin: event.pin, token: event.token)
              .then((respObj) {
            resData = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield ResetpinInitial();
    await reSetPinService();
    yield ResetPinUpdateState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }
}
