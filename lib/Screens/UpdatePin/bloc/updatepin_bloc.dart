import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/ChangePinModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'updatepin_event.dart';
part 'updatepin_state.dart';

class UpdatepinBloc extends Bloc<UpdatepinEvent, UpdatepinState> {
  UpdatepinBloc() : super(UpdatepinLoadedState());

  @override
  Stream<UpdatepinState> mapEventToState(
    UpdatepinEvent event,
  ) async* {
    if (event is UpdateSecurityPinEvent) {
      yield* _mapUpdatePinEventDatatoState(event);
    }
  }

  Stream<UpdatepinState> _mapUpdatePinEventDatatoState(
      UpdateSecurityPinEvent event) async* {
    ChangePinModel resData;
    bool isNetworkConnected = true;

    getNotificationPrefeData() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .changePinService(oldPin: event.oldPin, newPin: event.newPin)
              .then((ChangePinModel respObj) {
            resData = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield UpdatepinInitial();
    await getNotificationPrefeData();
    yield UpdateSecurityPinState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }
}
