class GetGoldRateModel {
  String status;
  bool ok;
  var code;
  String message;
  Result result;

  GetGoldRateModel(
      {this.status, this.ok, this.code, this.message, this.result});

  GetGoldRateModel.fromJson(Map<String, dynamic> json) {
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
  var perGramGoldRate;
  var deltaGoldValue;
  var deltaGoldPercentage;
  var userBalance;

  Result(
      {this.perGramGoldRate,
      this.deltaGoldValue,
      this.deltaGoldPercentage,
      this.userBalance});

  Result.fromJson(Map<String, dynamic> json) {
    perGramGoldRate = json['perGramGoldRate'];
    deltaGoldValue = json['deltaGoldValue'];
    deltaGoldPercentage = json['deltaGoldPercentage'];
    userBalance = json['userBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['perGramGoldRate'] = this.perGramGoldRate;
    data['deltaGoldValue'] = this.deltaGoldValue;
    data['deltaGoldPercentage'] = this.deltaGoldPercentage;
    data['userBalance'] = this.userBalance;
    return data;
  }
}
