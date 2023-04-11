part of 'setpin_bloc.dart';

@immutable
abstract class SetpinEvent {}

class SetSecurityPinEvent extends SetpinEvent {
  final String pin;

  SetSecurityPinEvent({this.pin});
}
