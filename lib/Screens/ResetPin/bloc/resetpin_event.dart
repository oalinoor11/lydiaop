part of 'resetpin_bloc.dart';

@immutable
abstract class ResetpinEvent {}

class ReSetSecurityPinEvent extends ResetpinEvent {
  final String pin;
  final String token;

  ReSetSecurityPinEvent({this.pin, this.token});
}
