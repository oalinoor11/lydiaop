import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, Map<String, dynamic> arg) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arg);
  }

  Future<dynamic> navigateToWithoutPost(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  Future<dynamic> navigateToVideoPlayer(String routeName, int id) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: id);
  }

  Future<dynamic> navigatePushToErrorPage(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
