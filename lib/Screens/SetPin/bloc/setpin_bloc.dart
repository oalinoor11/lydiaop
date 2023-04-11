import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'setpin_event.dart';
part 'setpin_state.dart';

class SetpinBloc extends Bloc<SetpinEvent, SetpinState> {
  SetpinBloc() : super(SetpinLoadedState());

  @override
  Stream<SetpinState> mapEventToState(
    SetpinEvent event,
  ) async* {
    if (event is SetSecurityPinEvent) {
      yield* _mapSetPinEventDatatoState(event);
    }
  }

  Stream<SetpinState> _mapSetPinEventDatatoState(
      SetSecurityPinEvent event) async* {
    Map<String, dynamic> resData;
    bool isNetworkConnected = true;

    setPinService() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service().setPinService(pin: event.pin).then((respObj) {
            resData = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield SetpinInitial();
    await setPinService();
    yield SetPinUpdateState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }
}
