part of 'homepage_bloc.dart';

@immutable
abstract class HomepageState {}

class HomepageInitial extends HomepageState {}

class HomepageLodingState extends HomepageState {}

class HomepageLoadedState extends HomepageState {
  final GetGoldRateModel resData;
  final bool isNetworkConnected;
  final DashboardDataModel dashboardResData;

  HomepageLoadedState(
      {this.resData, this.isNetworkConnected, this.dashboardResData});
}

class HomepageErrorState extends HomepageState {}
