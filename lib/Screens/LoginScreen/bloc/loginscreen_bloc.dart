import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/GoogleAuthModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/SharedPreferenceUtil.dart';
import 'package:meta/meta.dart';

part 'loginscreen_event.dart';
part 'loginscreen_state.dart';

class LoginscreenBloc extends Bloc<LoginscreenEvent, LoginscreenState> {
  LoginscreenBloc() : super(LoginscreenLoadedState());

  @override
  Stream<LoginscreenState> mapEventToState(
    LoginscreenEvent event,
  ) async* {
    if (event is GoogleLoginEvent) {
      yield* _mapGoogleLoginEventDatatoState(event);
    }

    if (event is AppleLoginEvent) {
      yield* _mapAppleLoginEventDatatoState(event);
    }
  }

  Stream<LoginscreenState> _mapGoogleLoginEventDatatoState(
      GoogleLoginEvent event) async* {
    GoogleAuthModel resData;

    bool isNetworkConnected = true;

    getLoginDetailsData() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .googleLoginService(tokenId: event.tokenId)
              .then((GoogleAuthModel respObj) {
            resData = respObj;
            if (resData.code.toString() == "200") {
              SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
              _sharedPreference.addSharedPref('token', resData.result.token);
              _sharedPreference.addSharedPref(
                  'id', resData.result.userData.sId);
              _sharedPreference.addSharedPref(
                  'profileImage', resData.result.userData.profileImg.filePath);
              _sharedPreference.addSharedPref(
                  'firstName', resData.result.userData.firstName);
              _sharedPreference.addSharedPref(
                  'lastName', resData.result.userData.lastName);
              _sharedPreference.addSharedPref(
                  'email', resData.result.userData.email);

              _sharedPreference.addSharedPref(
                  'walletId', resData.result.userData.accountId);
              _sharedPreference.addSharedPref(
                  'refreshToken', resData.result.refreshToken);
            }
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield LoginscreenInitial();
    await getLoginDetailsData();
    yield GoogleLoginState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }

  Stream<LoginscreenState> _mapAppleLoginEventDatatoState(
      AppleLoginEvent event) async* {
    GoogleAuthModel resData;

    bool isNetworkConnected = true;

    getAppleLoginDetailsData() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet != null && internet) {
          isNetworkConnected = true;
          await Service()
              .appleLoginService(
                  tokenId: event.tokenId,
                  firstName: event.firstName,
                  lastName: event.lastName)
              .then((GoogleAuthModel respObj) {
            resData = respObj;
            if (resData.code.toString() == "200") {
              SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
              _sharedPreference.addSharedPref('token', resData.result.token);
              _sharedPreference.addSharedPref(
                  'id', resData.result.userData.sId);
              _sharedPreference.addSharedPref(
                  'profileImage', resData.result.userData.profileImg.filePath);
              _sharedPreference.addSharedPref(
                  'firstName', resData.result.userData.firstName);
              _sharedPreference.addSharedPref(
                  'lastName', resData.result.userData.lastName);
              _sharedPreference.addSharedPref(
                  'email', resData.result.userData.email);

              _sharedPreference.addSharedPref(
                  'walletId', resData.result.userData.accountId);
              _sharedPreference.addSharedPref(
                  'refreshToken', resData.result.refreshToken);
            }
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield LoginscreenInitial();
    await getAppleLoginDetailsData();
    yield AppleLoginState(
        resData: resData, isNetworkConnected: isNetworkConnected);
  }
}
