class NotificationModel {
  String status;
  bool ok;
  int code;
  String message;
  List<Result> result;

  NotificationModel(
      {this.status, this.ok, this.code, this.message, this.result});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ok = json['ok'];
    code = json['code'];
    message = json['message'];
    if (json['result'] != null && json['result'] != "") {
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
    if (this.result != null && this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String sId;
  bool seen;
  TransactionId transactionId;
  String toUser;
  String body;
  String createdAt;
  String createdAtDate;
  String createdAtTime;
  String description;

  Result(
      {this.sId,
      this.seen,
      this.transactionId,
      this.toUser,
      this.body,
      this.createdAt,
      this.createdAtDate,
      this.createdAtTime,this.description});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    seen = json['seen'];
    transactionId = json['transactionId'] != null
        ? new TransactionId.fromJson(json['transactionId'])
        : null;
    toUser = json['toUser'];
    body = json['body'];
    createdAt = json['createdAt'];
    createdAtDate = json['createdAtDate'];
    createdAtTime = json['createdAtTime'];
    description = json['description'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['seen'] = this.seen;
    if (this.transactionId != null) {
      data['transactionId'] = this.transactionId.toJson();
    }
    data['toUser'] = this.toUser;
    data['body'] = this.body;
    data['createdAt'] = this.createdAt;
    data['createdAtDate'] = this.createdAtDate;
    data['createdAtTime'] = this.createdAtTime;
    data['description'] = this.description;
    return data;
  }
}

class TransactionId {
  String sId;
  double goldPrice;
  int lid;
  String type;
  String createdAt;
  String createdAtDate;
  String createdAtTime;

  TransactionId(
      {this.sId,
      this.goldPrice,
      this.lid,
      this.type,
      this.createdAt,
      this.createdAtDate,
      this.createdAtTime});

  TransactionId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    goldPrice = json['goldPrice'];
    lid = json['lid'];
    type = json['type'];
    createdAt = json['createdAt'];
    createdAtDate = json['createdAtDate'];
    createdAtTime = json['createdAtTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['goldPrice'] = this.goldPrice;
    data['lid'] = this.lid;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['createdAtDate'] = this.createdAtDate;
    data['createdAtTime'] = this.createdAtTime;
    return data;
  }
}

