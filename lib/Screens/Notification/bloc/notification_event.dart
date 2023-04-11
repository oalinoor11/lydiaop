part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetNotificationsEvent extends NotificationEvent {
  final int pageNo;
  final int pageSize;
  final List<Result> prevData;
  final bool isNetworkConnected;

  GetNotificationsEvent({
    this.pageNo,
    this.pageSize,
    this.prevData,
    this.isNetworkConnected,
  });
}

class MarkNotificationReadEvent extends NotificationEvent {
  final String notificationId;
  List<Result> prevData;
  final int pageNo;
  NotificationModel resData;
  final bool endPage;
  final int index;

  MarkNotificationReadEvent({
    this.notificationId,
    this.prevData,
    this.pageNo,
    this.resData,
    this.endPage,
    this.index,
  });
}
