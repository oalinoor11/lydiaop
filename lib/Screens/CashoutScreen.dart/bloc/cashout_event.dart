part of 'cashout_bloc.dart';

@immutable
abstract class CashoutEvent {}

class GetGoldRateEvent extends CashoutEvent {
  final bool alreadyLogin;

  GetGoldRateEvent(this.alreadyLogin);
}
