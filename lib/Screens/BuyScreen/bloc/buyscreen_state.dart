part of 'buyscreen_bloc.dart';

@immutable
abstract class BuyscreenState {}

class BuyscreenInitial extends BuyscreenState {}

class BuyscreenLoadingState extends BuyscreenState {}

class BuyscreenLoadedState extends BuyscreenState {
  final GetGoldRateModel resData;
  final bool isNetworkConnected;
  final double goldPerGram;  

  BuyscreenLoadedState(
      {this.resData, this.isNetworkConnected, this.goldPerGram});
}

class BuyscreenErrorState extends BuyscreenState {}
