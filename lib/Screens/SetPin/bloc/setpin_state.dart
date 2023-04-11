part of 'setpin_bloc.dart';

@immutable
abstract class SetpinState {}

class SetpinInitial extends SetpinState {}

class SetpinLoadedState extends SetpinState {}

class SetPinUpdateState extends SetpinState {
  final Map<String, dynamic> resData;
  final isNetworkConnected;

  SetPinUpdateState({this.resData, this.isNetworkConnected});
}

class SetpinErrorState extends SetpinState {}
