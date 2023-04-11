part of 'resetpin_bloc.dart';

@immutable
abstract class ResetpinState {}

class ResetpinInitial extends ResetpinState {}

class ResetpinLoadedState extends ResetpinState {}

class ResetPinUpdateState extends ResetpinState {
  final Map<String, dynamic> resData;
  final isNetworkConnected;

  ResetPinUpdateState({this.resData, this.isNetworkConnected});
}

class ResetpinErrorState extends ResetpinState {}
