import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Routers/Locator.dart';
import 'package:flutter_app/Routers/NavigationService.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;
final NavigationService _navigationService = locator<NavigationService>();
HelperUtil helperUtil = HelperUtil();

AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

pushNotificationService() async {
  if (Platform.isIOS) {
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      helperUtil.isAlreadyLogin().then((alreadyLogin) {
        if (alreadyLogin == true) {
          _navigationService
              .navigateToWithoutPost(RouteConst.routeNotificationScreen);
        } else {
          _navigationService
              .navigateToWithoutPost(RouteConst.routeMainDashboard);
        }
      });
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            color: Colors.black,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      helperUtil.isAlreadyLogin().then((alreadyLogin) {
        if (alreadyLogin == true) {
          _navigationService
              .navigateToWithoutPost(RouteConst.routeNotificationScreen);
        } else {
          _navigationService
              .navigateToWithoutPost(RouteConst.routeMainDashboard);
        }
      });
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
    if (message != null) {
      helperUtil.isAlreadyLogin().then((alreadyLogin) {
        if (alreadyLogin == true) {
          _navigationService
              .navigateToWithoutPost(RouteConst.routeNotificationScreen);
        } else {
          _navigationService
              .navigateToWithoutPost(RouteConst.routeMainDashboard);
        }
      });
    }
  });
}
