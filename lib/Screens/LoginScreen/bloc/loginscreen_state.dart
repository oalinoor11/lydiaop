part of 'loginscreen_bloc.dart';

@immutable
abstract class LoginscreenState {}

class LoginscreenInitial extends LoginscreenState {}

class LoginscreenLoadedState extends LoginscreenState {}

class GoogleLoginState extends LoginscreenState {
  final GoogleAuthModel resData;
  final bool isNetworkConnected;

  GoogleLoginState({this.resData, this.isNetworkConnected});
}

class AppleLoginState extends LoginscreenState {
  final GoogleAuthModel resData;
  final bool isNetworkConnected;
  AppleLoginState({this.resData, this.isNetworkConnected});
}
