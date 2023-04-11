class CashoutModel {
  String status;
  bool ok;
  var code;
  String message;
  Result result;

  CashoutModel({this.status, this.ok, this.code, this.message, this.result});

  CashoutModel.fromJson(Map<String, dynamic> json) {
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
  String transactionId;
  String createdAtDate;
  String createdAtTime;
  var cashoutLidQuantity;
  var currentLidQuantity;

  Result(
      {this.transactionId,
      this.createdAtDate,
      this.createdAtTime,
      this.cashoutLidQuantity,
      this.currentLidQuantity});

  Result.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    createdAtDate = json['createdAtDate'];
    createdAtTime = json['createdAtTime'];
    cashoutLidQuantity = json['cashoutLidQuantity'];
    currentLidQuantity = json['currentLidQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['createdAtDate'] = this.createdAtDate;
    data['createdAtTime'] = this.createdAtTime;
    data['cashoutLidQuantity'] = this.cashoutLidQuantity;
    data['currentLidQuantity'] = this.currentLidQuantity;
    return data;
  }
}
