part of 'cashout_bloc.dart';

@immutable
abstract class CashoutState {}

class CashoutInitial extends CashoutState {}

class CashoutLoadingState extends CashoutState {}

class CashoutLoadedState extends CashoutState {
  final GetGoldRateModel resData;
  final bool isNetworkConnected;

  CashoutLoadedState({this.resData, this.isNetworkConnected});
}

class CashoutErrorState extends CashoutState {}
