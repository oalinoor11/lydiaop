part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionLoadedState extends TransactionState {
  final TransactionModel respData;
  final List<Result> transResult;
  final int page;
  final bool endPage;
  final bool isNetworkConnected;
  bool isLoading;

  TransactionLoadedState({
    this.respData,
    this.transResult,
    this.page,
    this.endPage,
    this.isLoading,
    this.isNetworkConnected,
  });
}

class TransactionErrorState extends TransactionState {}

class NoInternetState extends TransactionState {}
