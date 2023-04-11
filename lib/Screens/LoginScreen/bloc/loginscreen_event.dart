part of 'loginscreen_bloc.dart';

@immutable
abstract class LoginscreenEvent {}

class GoogleLoginEvent extends LoginscreenEvent {
  final String tokenId;

  GoogleLoginEvent({this.tokenId});
}

class AppleLoginEvent extends LoginscreenEvent {
  final String tokenId;
  final String firstName;
  final String lastName;

  AppleLoginEvent({this.tokenId, this.firstName, this.lastName});
}
