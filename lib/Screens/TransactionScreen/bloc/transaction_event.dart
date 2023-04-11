part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class GetTransactionDeatilsEvent extends TransactionEvent {
  final int pageNo;
  final int pageSize;
  final String type;
  final String startDate;
  final String endDate;
  final List<Result> prevData;
  final bool isNetworkConnected;

  GetTransactionDeatilsEvent({
    this.pageNo,
    this.pageSize,
    this.type,
    this.startDate,
    this.endDate,
    this.prevData,
    this.isNetworkConnected,
  });
}
