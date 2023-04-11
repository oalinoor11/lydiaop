class TransactionModel {
  String status;
  bool ok;
  int code;
  String message;
  List<Result> result;

  TransactionModel(
      {this.status, this.ok, this.code, this.message, this.result});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ok = json['ok'];
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['ok'] = this.ok;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String sId;
  String fromUser;
  String toUser;
  var lid;
  String type;
  String transactionId;
  String createdAt;
  String month;
  int date;
  String title;

  Result(
      {this.sId,
      this.fromUser,
      this.toUser,
      this.lid,
      this.type,
      this.transactionId,
      this.createdAt,
      this.month,
      this.date,
      this.title});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fromUser = json['fromUser'];
    toUser = json['toUser'];
    lid = json['lid'];
    type = json['type'];
    transactionId = json['transactionId'];
    createdAt = json['createdAt'];
    month = json['month'];
    date = json['date'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fromUser'] = this.fromUser;
    data['toUser'] = this.toUser;
    data['lid'] = this.lid;
    data['type'] = this.type;
    data['transactionId'] = this.transactionId;
    data['createdAt'] = this.createdAt;
    data['month'] = this.month;
    data['date'] = this.date;
    data['title'] = this.title;
    return data;
  }
}
