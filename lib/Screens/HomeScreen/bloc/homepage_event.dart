part of 'homepage_bloc.dart';

@immutable
abstract class HomepageEvent {}

class GetGoldRateEvent extends HomepageEvent {
  final bool alreadyLogin;

  GetGoldRateEvent(this.alreadyLogin);
}

class GetDashboardEvent extends HomepageEvent {}
