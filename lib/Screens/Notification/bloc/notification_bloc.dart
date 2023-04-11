import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/DataModels/NotificationModel.dart';
import 'package:flutter_app/Network/Service.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationLoadingState());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is GetNotificationsEvent) {
      yield* _maptoGetNotificationsDatatoState(event);
    }

    if (event is MarkNotificationReadEvent) {
      yield* _maptoMarkNotificationReadDatatoState(event);
    }
  }

  Stream<NotificationState> _maptoGetNotificationsDatatoState(
      GetNotificationsEvent event) async* {
    NotificationModel resData;
    List<Result> notificationResult = [];
    int page = event.pageNo;
    bool isLoading = true;
    bool endPage = false;
    bool isNetworkConnected = true;

    try {
      getNotificationsData() async {
        await HelperUtil.checkInternetConnection().then((internet) async {
          if (internet) {
            isNetworkConnected = true;
            await Service()
                .getNotificationListService(
                    pageNo: event.pageNo, pageSize: event.pageSize)
                .then((NotificationModel respObj) {
              resData = respObj;

              if (resData.code.toString() == "200") {
                endPage = false;

                if (respObj.result.length > 0 && event.prevData != null) {
                  event.prevData.addAll(resData.result);
                  notificationResult = event.prevData;
                } else if (respObj.result.length == 0 &&
                    event.prevData != null) {
                  endPage = true;
                  notificationResult = event.prevData;
                }
                page++;
                isLoading = false;
              } else {
                endPage = true;
                isLoading = false;
              }
            });
          } else {
            endPage = true;
            isLoading = false;
            isNetworkConnected = false;
          }
        });
      }

      if (event.pageNo == 1) {
        yield NotificationLoadingState();
      } else {
        yield NotificationInitial();
      }

      await getNotificationsData();
      yield NotificationLoadedState(
        respData: resData,
        notificationResult: notificationResult,
        page: page,
        endPage: endPage,
        isLoading: isLoading,
        isNetworkConnected: isNetworkConnected,
      );
    } catch (e) {
      yield NotificationErrorState();
    }
  }

  Stream<NotificationState> _maptoMarkNotificationReadDatatoState(
      MarkNotificationReadEvent event) async* {
    Map<String, dynamic> resData;
    bool isNetworkConnected = true;
    getLoginDetailsData() async {
      await HelperUtil.checkInternetConnection().then((internet) async {
        if (internet) {
          isNetworkConnected = true;
          await Service()
              .notificationMarkService(event.notificationId)
              .then((respObj) {
            resData = respObj;

            if (resData != null && resData['code'].toString() == "200") {
              event.prevData[event.index].seen = true;
            }
          });
        } else {
          isNetworkConnected = false;
        }
      });
    }

    yield NotificationInitial();
    await getLoginDetailsData();
    yield NotificationLoadedState(
      respData: event.resData,
      notificationResult: event.prevData,
      page: event.pageNo,
      endPage: event.endPage,
      isLoading: false,
      isNetworkConnected: isNetworkConnected,
    );
  }
}
