part of 'buyscreen_bloc.dart';

@immutable
abstract class BuyscreenEvent {}

class GetGoldRateEvent extends BuyscreenEvent {
  final bool alreadyLogin;
  GetGoldRateEvent(this.alreadyLogin);
}
