part of 'updatepin_bloc.dart';

@immutable
abstract class UpdatepinState {}

class UpdatepinInitial extends UpdatepinState {}

class UpdateSecurityPinState extends UpdatepinState {
  final ChangePinModel resData;
  final bool isNetworkConnected;

  UpdateSecurityPinState({this.resData, this.isNetworkConnected});
}

class UpdatepinLoadedState extends UpdatepinState {}

class UpdatepinErrorState extends UpdatepinState {}
