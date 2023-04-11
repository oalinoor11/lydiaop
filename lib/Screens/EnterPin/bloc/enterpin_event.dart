part of 'enterpin_bloc.dart';

@immutable
abstract class EnterpinEvent {}

class ProceedPaymentEvent extends EnterpinEvent {
  final String lidQuantity;
  final String pin;

  ProceedPaymentEvent({this.lidQuantity, this.pin});
}

class SendLidToAnotherWalletEvent extends EnterpinEvent {
  final String lidQuantity;
  final String pin;
  final String walletAddress;
  final String note;

  SendLidToAnotherWalletEvent(
      {this.lidQuantity, this.pin, this.walletAddress, this.note});
}

class CashoutEvent extends EnterpinEvent {
  final String lidQuantity;
  final String pin;
  CashoutEvent({this.lidQuantity, this.pin});
}
