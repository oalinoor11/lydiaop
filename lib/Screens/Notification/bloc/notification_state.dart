part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  NotificationModel respData;
  List<Result> notificationResult;
  final int page;
  final bool endPage;
  final bool isNetworkConnected;
  bool isLoading;

  NotificationLoadedState({
    this.respData,
    this.notificationResult,
    this.page,
    this.endPage,
    this.isLoading,
    this.isNetworkConnected,
  });
}

class NotificationErrorState extends NotificationState {}

// class NotificationInitial extends NotificationState {}
