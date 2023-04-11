class PaymentChargesModel {
  String status;
  bool ok;
  var code;
  String message;
  Result result;

  PaymentChargesModel(
      {this.status, this.ok, this.code, this.message, this.result});

  PaymentChargesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ok = json['ok'];
    code = json['code'];
    message = json['message'];
    result = (json['result'] != null && json['result'] != "")
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
  String paymentId;
  String url;

  Result({this.paymentId, this.url});

  Result.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentId'] = this.paymentId;
    data['url'] = this.url;
    return data;
  }
}
