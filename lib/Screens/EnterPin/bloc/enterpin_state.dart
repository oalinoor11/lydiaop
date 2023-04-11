part of 'enterpin_bloc.dart';

@immutable
abstract class EnterpinState {}

class EnterpinInitial extends EnterpinState {}

class EnterpinLoadedState extends EnterpinState {}

class EnterpinErrorState extends EnterpinState {}

class ProceedPaymentState extends EnterpinState {
  final BuyLidPaymentModel resData;
  final bool isNetworkConnected;

  ProceedPaymentState({this.resData, this.isNetworkConnected});
}

class SendLidToWalletState extends EnterpinState {
  final PaymentChargesModel resData;
  final bool isNetworkConnected;
  SendLidToWalletState({this.resData, this.isNetworkConnected});
}

class CashoutState extends EnterpinState {
  final CashoutModel resData;
  final bool isNetworkConnected;
  CashoutState({this.resData, this.isNetworkConnected});
}
