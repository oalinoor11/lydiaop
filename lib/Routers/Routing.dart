import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Screens/BuyScreen/BuyScreen.dart';
import 'package:flutter_app/Screens/CashoutScreen.dart/CashoutScreen.dart';
import 'package:flutter_app/Screens/Community/CommunityScreen.dart';
import 'package:flutter_app/Screens/EditProfleScreen/EditProfileScreen.dart';
import 'package:flutter_app/Screens/EnterPin/EnterPin.dart';
import 'package:flutter_app/Screens/ForgotPin/ForgotPin.dart';
import 'package:flutter_app/Screens/HomeScreen/HomeScreen.dart';
import 'package:flutter_app/Screens/LaunchScreen/LaunchScreen.dart';
import 'package:flutter_app/Screens/LoginScreen/LoginScreen.dart';
import 'package:flutter_app/Screens/Notification/NotificationScreen.dart';
import 'package:flutter_app/Screens/NotificationDetails/NotificationDetailsScreen.dart';
import 'package:flutter_app/Screens/PaypalWebView.dart';
import 'package:flutter_app/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:flutter_app/Screens/ReceiveLid/ReceiveLidScreen.dart';
import 'package:flutter_app/Screens/ResetPin/ResetPin.dart';
import 'package:flutter_app/Screens/ScanQRCode/ScanQRCodeScreen.dart';
import 'package:flutter_app/Screens/SendLid.dart/SendLid.dart';
import 'package:flutter_app/Screens/SetPin/SetPinScreen.dart';
import 'package:flutter_app/Screens/Settings/Settings.dart';
import 'package:flutter_app/Screens/ShareScreen/ShareScreen.dart';
import 'package:flutter_app/Screens/TabbarScreen/TabBarScreen.dart';
import 'package:flutter_app/Screens/TransactionScreen/Transaction.dart';
import 'package:flutter_app/Screens/UpdatePin/UpdatePin.dart';
import 'package:flutter_app/Screens/VerifyEmail/VerifyEmailScreen.dart';
import 'package:flutter_app/Utils/WebViewUtil.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Map<String, dynamic> data = args;
    switch (settings.name) {
      case RouteConst.routeDefault:
        Future.delayed(Duration(microseconds: 100), () {
          FlutterSplashScreen.hide();
        });
        return MaterialPageRoute(builder: (_) => LaunchScreen());
        break;

      case RouteConst.routeLaunchScreen:
        return MaterialPageRoute(builder: (_) => LaunchScreen());
        break;

      case RouteConst.routeLoginPage:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => LoginScreen(
              from: data['data']['from'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => LoginScreen());
        }
        break;

      case RouteConst.routeMainDashboard:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => BottomNavigation(
              selectedIndex: data['data']['selectedIndex'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => BottomNavigation());
        }

        break;

      case RouteConst.routeHomeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;

      case RouteConst.routeBuyScreen:
        return MaterialPageRoute(builder: (_) => BuyScreen());
        break;

      case RouteConst.routeShareScreen:
        return MaterialPageRoute(builder: (_) => ShareScreen());
        break;

      case RouteConst.routeCashoutScreen:
        return MaterialPageRoute(builder: (_) => CashoutScreen());
        break;

      case RouteConst.routeProfileScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(
              from: data['data']['from'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => ProfileScreen());
        }

        break;

      case RouteConst.routeEditProfileScreen:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
        break;

      case RouteConst.routeSettingsScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => SettingScreen(
              from: data['data']['from'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => SettingScreen());
        }

        break;

      case RouteConst.routeTransactionScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => TransactionScreen(
              from: data['data']['from'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => TransactionScreen());
        }
        break;

      case RouteConst.routeSetPinScreen:
        return MaterialPageRoute(builder: (_) => SetPinScreen());
        break;

      case RouteConst.routeForgotPinScreen:
        return MaterialPageRoute(builder: (_) => ForgotPinScreen());
        break;

      case RouteConst.routeVerifyEmailScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(
              emailAddess: data['data']['emailAddess'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => VerifyEmailScreen());
        }
        break;

      case RouteConst.routeUpdatePinScreen:
        return MaterialPageRoute(builder: (_) => UpdatePinScreen());
        break;

      case RouteConst.routeResetPinScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => ResetPinScreen(
              tokenId: data['data']['tokenId'],
            ),
          );
        }
        break;

      case RouteConst.routeEnterPinScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => EnterPinScreen(
              isFrom: data['data']['isFrom'],
              lidQuantity: data['data']['lidQuantity'],
              paymentData: data['data']['paymentData'],
              walletAddress: data['data']['walletAddress'],
              note: data['data']['note'],
              payableAmount: data['data']['payableAmount'],
              sendLidData: data['data']['sendLidData'],
              paymentId: data['data']['paymentId'] ?? "",
              token: data['data']['token'] ?? "",
              payerId: data['data']['payerId'] ?? "",
              pin: data['data']['pin'] ?? "",
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => EnterPinScreen());
        }

        break;

      case RouteConst.routeSendLidScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => SendLidScreen(
              lidQuantity: data['data']['lidQuantity'],
              walletAddress: data['data']['walletAddress'],
              note: data['data']['note'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => SendLidScreen());
        }

        break;

      case RouteConst.routeReceiveLidScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => ReceiveLidScreen(from: data['data']['from']),
          );
        }

        break;

      case RouteConst.routeNotificationDetailsScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => NotificationDetailsScreen(
              transDetails: data['data']['transDetails'],
            ),
          );
        }
        break;

      case RouteConst.routeScanQRCodeScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => ScanQRCodeScreen(
              lidQuantity: data['data']['lidQuantity'],
              walletAddress: data['data']['walletAddress'],
              note: data['data']['note'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => ScanQRCodeScreen());
        }
        break;

      case RouteConst.routeNotificationScreen:
        if (args != "" && args != null) {
          return MaterialPageRoute(
            builder: (_) => NotificationScreen(
              from: data['data']['from'],
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => NotificationScreen());
        }

        break;
      case RouteConst.routeWebViewScreen:
        {
          if (args != "" && args != null) {
            Map<String, dynamic> data;
            data = args;
            return MaterialPageRoute(
              builder: (_) => WebViewUtil(
                loadUrl: data['data']['webUrl'],
                pageType: 0,
                id: data['data']['id'],
                title: data['data']['title'],
              ),
            );
          }
        }
        break;

      case RouteConst.routePaypalWebView:
        {
          if (args != "" && args != null) {
            Map<String, dynamic> data;
            data = args;
            return MaterialPageRoute(
              builder: (_) => PaypalWebView(
                url: data['data']['url'],
                id: data['data']['id'],
                paymentDate: data['data']['paymentDate'],
                from: data['data']['from'],
                pin: data['data']['pin'],
                lidQuantity: data['data']['lidQuantity'],
                walletAddress: data['data']['walletAddress'],
                note: data['data']['note'],
              ),
            );
          }
        }
        break;

      case RouteConst.routeCommunityScreen:
        return MaterialPageRoute(
          builder: (_) => CommunityScreen(),
        );

        break;

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(pageName) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error_outline),
              Text(
                RouteConst.errPageText + pageName.toString(),
                style: TextStyle(fontSize: 18.0),
              )
            ],
          ),
        ),
      );
    });
  }
}
