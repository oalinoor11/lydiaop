import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter_app/DataModels/BuyLidPaymentDatamodel.dart';
import 'package:flutter_app/DataModels/CashoutModel.dart';
import 'package:flutter_app/DataModels/ChangePinModel.dart';
import 'package:flutter_app/DataModels/DashboardDataModel.dart';
import 'package:flutter_app/DataModels/GetGoldRateModel.dart';
import 'package:flutter_app/DataModels/GoogleAuthModel.dart';
import 'package:flutter_app/DataModels/NotificationModel.dart';
import 'package:flutter_app/DataModels/PaymentChargesModel.dart';
import 'package:flutter_app/DataModels/SendLidDataModel.dart';
import 'package:flutter_app/DataModels/TransactionModel.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Network.dart';

class Service {
  Network _network = new Network();
  // Map<String, String> data = new Map<String, String>();
  Map<String, dynamic> paramsKeyVal = new Map<String, dynamic>();

  Map<String, String> paramsKeyHeaderVal = new Map<String, String>();
  // Map<String, dynamic> paramsKeyHeaderVal = new Map<String, dynamic>();

  Future<Map<String, dynamic>> getDeviceInfo(
      {bool isTokenRequired = true, bool isMultiPart = false}) async {
    Map<String, String> data = new Map<String, String>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (isTokenRequired) {
      if (token != null && token != "") {
        data["Authorization"] = "$token";
      }
    }

    if (isMultiPart == true) {
      data['Content-Type'] =
          'multipart/form-data; boundary=<calculated when request is sent>';
    } else {
      data['Content-Type'] = 'application/json';
    }

    return data;
  }

  //String basicUrl = "https://api.lidya.app:8000";
  // String basicUrl = "https://lidya-api.rejolut.ml";
  //  String basicUrl = "http://13.126.133.192:7000";

  String basicUrl = "https://api.lidya.app";
  //String basicUrl = "https://api-stage.lidya.app";

  /* URL Declaration */
  String googleAuthUrl = "/auth/google";
  String appleAuthUrl = "/auth/apple";

  String setpinURL = "/auth/setpin";
  String changePinURL = "/user/changepin";
  String updateProfileUrl = "/user/update";

  String getGoldRateUrl = "/dashboard/gold/rate";
  String dashboardSummary = "/dashboard/summary";
  String userTransactionHistoryUser = "/user/transaction/history";
  String createPaymentUrl = "/payment/paypal/receive";
  String canceledPaymentUrl = "/payment/paypal/cancel/update";
  String executePaymentUrl = "/payment/paypal/execute";
  String sendLidToWalletUrl = "/nft/transfer";
  String resetPinRequestUrl = "/auth/resetpinrequest";
  String cashoutUrl = "/payment/paypal/payout";
  String resetPinUrl = "/auth/resetpin";
  String refreshTokenUrl = "/auth/refreshtoken/";
  String notificationListUrl = "/notification/list";
  String notificationMarkUrl = "/notification/mark";
  String updateFcmTokenUrl = "/notification/token";
  String paymentChargesUrl = "/payment/paypal/charges";

  String privacyPolicy = "/public/privacypolicy";
  String termsCondition = "/public/t&c";
  String goldUrl = "/public/gold";
  String lidyaCoinUrl = "/public/lidyacoin";
  String tdsvaultUrl = "/public/tdsvault";
  String redeemUrl = "/public/redeem";
  String priceFeeUrl = "/public/priceFee";

  String communityUrl = "https://www.reddit.com/user/selimlahoud";
  String facebookUrl = "https://www.facebook.com/LidyaGoldApp/?ref=pages";
  String instagramurl =
      "https://www.instagram.com/p/CYVUq90Mtzp/?utm_medium=share_sheet";
  String twitterUrl = "https://twitter.com/lidyagoldapp";

  // Google login API integration
  Future<GoogleAuthModel> googleLoginService({String tokenId}) async {
    return getDeviceInfo(isTokenRequired: false).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["idToken"] = "$tokenId";
      return _network
          .post("$basicUrl$googleAuthUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new GoogleAuthModel.fromJson(res);
      });
    });
  }

  // Apple login API integration
  Future<GoogleAuthModel> appleLoginService(
      {String tokenId, String firstName, String lastName}) async {
    return getDeviceInfo(isTokenRequired: false).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["idToken"] = "$tokenId";
      paramsKeyVal["firstName"] = "$firstName";
      paramsKeyVal["lastName"] = "$lastName";
      return _network
          .post("$basicUrl$appleAuthUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new GoogleAuthModel.fromJson(res);
      });
    });
  }

  // Set Pin API integration
  Future<Object> setPinService({String pin}) async {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["pin"] = "$pin";
      return _network
          .post("$basicUrl$setpinURL",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // Change Pin API integration
  Future<ChangePinModel> changePinService({String oldPin, String newPin}) {
    return getDeviceInfo().then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["oldPin"] = "$oldPin";
      paramsKeyVal["newPin"] = "$newPin";
      return _network
          .put("$basicUrl$changePinURL",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new ChangePinModel.fromJson(res);
      });
    });
  }

  // Get Gold Price API integration
  Future<GetGoldRateModel> getGoldRateApi(bool istokenRequired) {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      return _network
          .get("$basicUrl$getGoldRateUrl", headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new GetGoldRateModel.fromJson(res);
      });
    });
  }

  // Get dashboard summary
  Future<DashboardDataModel> getDashboardSummaryService(bool istokenRequired) {
    return getDeviceInfo(isTokenRequired: istokenRequired).then((devResp) {
      paramsKeyHeaderVal = devResp;
      return _network
          .get("$basicUrl$dashboardSummary", headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new DashboardDataModel.fromJson(res);
      });
    });
  }

  // Update Profile image
  Future<StreamedResponse> updateProfileService(
      {String firstName,
      String lastName,
      String profileImage,
      String type}) async {
    return getDeviceInfo(isMultiPart: true).then((devResp) async {
      var request =
          MultipartRequest('PUT', Uri.parse("$basicUrl$updateProfileUrl"));

      if (profileImage != null && profileImage != "") {
        request.files
            .add(await MultipartFile.fromPath('profileImg', profileImage));
      }
      request.fields['firstName'] = '$firstName';
      request.fields['lastName'] = '$lastName';
      request.fields['type'] = '$type';

      request.headers.addAll(devResp);
      return request.send().then((response) {
        return response;
      });
    });
  }

  // create payment
  Future<BuyLidPaymentModel> creatPaymentService(
      {String pin, String lidQuantity}) async {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["pin"] = "$pin";
      paramsKeyVal["lidQuantity"] = "$lidQuantity";

      return _network
          .post("$basicUrl$createPaymentUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new BuyLidPaymentModel.fromJson(res);
      });
    });
  }

  // Transaction Screen API
  Future<TransactionModel> transactionDetailsService(
      {int pageNo,
      int pageSize,
      String type,
      String startDate,
      String endDate}) {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;

      String _pageNo = "?pageNo=$pageNo";
      String _pageSize = "&pageSize=$pageSize";
      String _type = type != "" ? "&type=$type" : "";
      String _startDate = startDate != "" ? "&startDate=$startDate" : "";
      String _endDate = endDate != "" ? "&endDate=$endDate" : "";
      return _network
          .get(
              "$basicUrl$userTransactionHistoryUser$_pageNo$_pageSize$_type$_startDate$_endDate",
              headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new TransactionModel.fromJson(res);
      });
    });
  }

  // cancel Payment
  Future<Object> paymentCancelledService({String transactionId}) {
    return getDeviceInfo().then((devResp) {
      paramsKeyHeaderVal = devResp;
      String transId = "?transactionId=$transactionId";
      return _network
          .get("$basicUrl$canceledPaymentUrl$transId",
              headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // execute Payment
  Future<Object> executePaymentService(
      {String paymentId, String payerId, String token}) {
    return getDeviceInfo().then((devResp) {
      paramsKeyHeaderVal = devResp;

      String paymntId = "?paymentId=$paymentId";
      String tokenId = "&token=$token";
      String payer = "&PayerID=$payerId";

      return _network
          .get("$basicUrl$executePaymentUrl$paymntId$tokenId$payer",
              headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // send lid to wallet
  Future<SendLidDataModel> sendLidToWalletService(
      {String pin,
      String lidQuantity,
      String walletAddress,
      String note}) async {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["pin"] = "$pin";
      paramsKeyVal["lidQuantity"] = "$lidQuantity";
      paramsKeyVal["toUser"] = "$walletAddress";
      paramsKeyVal["note"] = "$note";

      return _network
          .post("$basicUrl$sendLidToWalletUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new SendLidDataModel.fromJson(res);
      });
    });
  }

  // Reset Pin Email
  Future<Object> forgotPinService({String email}) async {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["email"] = "$email";

      return _network
          .post("$basicUrl$resetPinRequestUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // cashout API
  Future<CashoutModel> cashoutService({String pin, String lidQuantity}) async {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["pin"] = "$pin";
      paramsKeyVal["lidQuantity"] = "$lidQuantity";

      return _network
          .post("$basicUrl$cashoutUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new CashoutModel.fromJson(res);
      });
    });
  }

  // Reset Pin Email
  Future<Object> resetPinService({String token, String pin}) async {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["token"] = "$token";
      paramsKeyVal["pin"] = "$pin";
      return _network
          .post("$basicUrl$resetPinUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // Refresh Token  API
  Future<Object> refreshTokenService({String refreshToken}) async {
    return getDeviceInfo(isTokenRequired: false).then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["refreshToken"] = "$refreshToken";
      return _network
          .post("$basicUrl$refreshTokenUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // Notification Listing
  Future<NotificationModel> getNotificationListService(
      {int pageNo, int pageSize}) {
    return getDeviceInfo(isTokenRequired: true).then((devResp) {
      paramsKeyHeaderVal = devResp;
      String _pageNo = "?pageNo=$pageNo";
      String _pageSize = "&pageSize=$pageSize";
      return _network
          .get("$basicUrl$notificationListUrl$_pageNo$_pageSize",
              headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new NotificationModel.fromJson(res);
      });
    });
  }

  // Notification mark
  Future<Object> notificationMarkService(String notificationId) {
    return getDeviceInfo().then((devResp) {
      paramsKeyHeaderVal = devResp;
      String _id = "?id=$notificationId";
      return _network
          .get("$basicUrl$notificationMarkUrl$_id", headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // Update FCM
  Future<Object> updateFcmService(String token) {
    return getDeviceInfo().then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["token"] = "$token";
      return _network
          .post("$basicUrl$updateFcmTokenUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return res;
      });
    });
  }

  // Paypal Payment Charges
  Future<PaymentChargesModel> getPaymentChargesService(
      {String pin, String lidQuantity, String walletAddress, String note}) {
    return getDeviceInfo().then((devResp) {
      paramsKeyHeaderVal = devResp;
      paramsKeyVal["pin"] = "$pin";
      paramsKeyVal["lidQuantity"] = "$lidQuantity";
      paramsKeyVal["toUser"] = "$walletAddress";
      paramsKeyVal["note"] = "$note";
      return _network
          .post("$basicUrl$paymentChargesUrl",
              body: json.encode(paramsKeyVal), headers: paramsKeyHeaderVal)
          .then((dynamic res) {
        return new PaymentChargesModel.fromJson(res);
      });
    });
  }
}
