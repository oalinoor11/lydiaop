import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'editprofile_event.dart';
part 'editprofile_state.dart';

class EditprofileBloc extends Bloc<EditprofileEvent, EditprofileState> {
  EditprofileBloc() : super(EditprofileLoadedState());

  @override
  Stream<EditprofileState> mapEventToState(
    EditprofileEvent event,
  ) async* {
    if (event is UpdateProfileDetailsEvent) {
      yield* _mapSetPinEventDatatoState(event);
    }
  }

  Stream<EditprofileState> _mapSetPinEventDatatoState(
      UpdateProfileDetailsEvent event) async* {
    bool isNetworkConnected = true;
    StreamedResponse profileResp;
    getNotificationPrefeData() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;

          await Service()
              .updateProfileService(
                  firstName: event.firtsName,
                  lastName: event.lastName,
                  profileImage: event.imagePath,
                  type: event.type)
              .then((StreamedResponse respObj) {
            profileResp = respObj;
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield EditprofileInitial();
    await getNotificationPrefeData();
    yield UploadProfileState(
        profileResp: profileResp, isNetworkConnected: isNetworkConnected);
  }
}
