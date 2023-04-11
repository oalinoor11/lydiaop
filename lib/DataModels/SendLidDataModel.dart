class SendLidDataModel {
  String status;
  bool ok;
  var code;
  String message;
  Result result;

  SendLidDataModel(
      {this.status, this.ok, this.code, this.message, this.result});

  SendLidDataModel.fromJson(Map<String, dynamic> json) {
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
  String sId;
  String fromUser;
  String toUser;
  double goldPrice;
  var lid;
  String type;
  String status;
  String note;
  String createdAt;
  int iV;
  String createdAtDate;
  String createdAtTime;

  Result(
      {this.sId,
      this.fromUser,
      this.toUser,
      this.goldPrice,
      this.lid,
      this.type,
      this.status,
      this.note,
      this.createdAt,
      this.iV,
      this.createdAtDate,
      this.createdAtTime});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fromUser = json['fromUser'];
    toUser = json['toUser'];
    goldPrice = json['goldPrice'];
    lid = json['lid'];
    type = json['type'];
    status = json['status'];
    note = json['note'];
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
    data['goldPrice'] = this.goldPrice;
    data['lid'] = this.lid;
    data['type'] = this.type;
    data['status'] = this.status;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['createdAtDate'] = this.createdAtDate;
    data['createdAtTime'] = this.createdAtTime;
    return data;
  }
}
