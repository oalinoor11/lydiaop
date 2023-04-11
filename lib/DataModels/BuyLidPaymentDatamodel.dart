class BuyLidPaymentModel {
  String status;
  bool ok;
  var code;
  String message;
  Result result;

  BuyLidPaymentModel(
      {this.status, this.ok, this.code, this.message, this.result});

  BuyLidPaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ok = json['ok'];
    code = json['code'];
    message = json['message'];
    result = json['result'] != null && json['result'] != ""
        ? new Result.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['ok'] = this.ok;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  Data data;
  TransactionReceipt transactionReceipt;

  Result({this.data, this.transactionReceipt});

  Result.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    transactionReceipt = json['transactionReceipt'] != null
        ? new TransactionReceipt.fromJson(json['transactionReceipt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.transactionReceipt != null) {
      data['transactionReceipt'] = this.transactionReceipt.toJson();
    }
    return data;
  }
}

class Data {
  String transactionId;
  String redirectLink;

  Data({this.transactionId, this.redirectLink});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    redirectLink = json['redirect_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['redirect_link'] = this.redirectLink;
    return data;
  }
}

class TransactionReceipt {
  String sId;
  String fromUser;
  String toUser;
  var lid;
  double amount;
  String type;
  double goldPrice;
  String status;
  String transactionId;
  String createdAt;
  int iV;
  String createdAtDate;
  String createdAtTime;

  TransactionReceipt(
      {this.sId,
      this.fromUser,
      this.toUser,
      this.lid,
      this.amount,
      this.type,
      this.goldPrice,
      this.status,
      this.transactionId,
      this.createdAt,
      this.iV,
      this.createdAtDate,
      this.createdAtTime});

  TransactionReceipt.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fromUser = json['fromUser'];
    toUser = json['toUser'];
    lid = json['lid'];
    amount = json['amount'];
    type = json['type'];
    goldPrice = json['goldPrice'];
    status = json['status'];
    transactionId = json['transactionId'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    createdAtDate = json['createdAtDate'];
    createdAtTime = json['createdAtTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fromUser'] = this.fromUser;
    data['toUser'] = this.toUser;
    data['lid'] = this.lid;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['goldPrice'] = this.goldPrice;
    data['status'] = this.status;
    data['transactionId'] = this.transactionId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['createdAtDate'] = this.createdAtDate;
    data['createdAtTime'] = this.createdAtTime;
    return data;
  }
}
