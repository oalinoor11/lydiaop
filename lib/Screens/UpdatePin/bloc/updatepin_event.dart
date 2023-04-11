part of 'updatepin_bloc.dart';

@immutable
abstract class UpdatepinEvent {}

class UpdateSecurityPinEvent extends UpdatepinEvent {
  final String oldPin;
  final String newPin;

  UpdateSecurityPinEvent({this.oldPin, this.newPin});
}
