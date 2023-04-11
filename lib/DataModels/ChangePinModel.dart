class ChangePinModel {
  String status;
  bool ok;
  var code;
  String message;
  String result;

  ChangePinModel({this.status, this.ok, this.code, this.message, this.result});

  ChangePinModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ok = json['ok'];
    code = json['code'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['ok'] = this.ok;
    data['code'] = this.code;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
