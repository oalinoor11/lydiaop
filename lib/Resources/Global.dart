import 'dart:async';

import 'package:flutter/material.dart';

class Global {
  static ValueNotifier<String> availableLidCount = ValueNotifier<String>("0");
  static ValueNotifier<double> lidValue = ValueNotifier<double>(0.0);
  static ValueNotifier<double> deltaGoldValue = ValueNotifier<double>(0.0);
  static ValueNotifier<double> deltaGoldPercentage = ValueNotifier<double>(0.0);
  static ValueNotifier<double> currentUsdValue = ValueNotifier<double>(0.0);
  

  static Timer homeScreenTimer;
  static Timer buyScreenTimer;
  static Timer cashoutScreenTimer;

  static String userWalletaddress = "";

  static String appStoreUrl =
      "https://apps.apple.com/us/app/lidya-gold-app/id1572473567";
  static String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.lidyagold.app";

  static String refreshToken = "";
}
