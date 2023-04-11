class DashboardDataModel {
  String status;
  bool ok;
  var code;
  String message;
  List<Result> result;

  DashboardDataModel(
      {this.status, this.ok, this.code, this.message, this.result});

  DashboardDataModel.fromJson(Map<String, dynamic> json) {
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
  var gainValue;
  var deltaGain;
  var deltaGainPercentage;
  var lidSent;
  var lidReceived;
  var totalInvestment;
  var totalCashout;
  var totalLidPurchased;
  var totalLidReceived;
  var totalLidCashout;
  var totalLidSent;

  Result(
      {this.gainValue,
      this.deltaGain,
      this.deltaGainPercentage,
      this.lidSent,
      this.lidReceived,
      this.totalInvestment,
      this.totalCashout,
      this.totalLidPurchased,
      this.totalLidReceived,
      this.totalLidCashout,
      this.totalLidSent});

  Result.fromJson(Map<String, dynamic> json) {
    gainValue = json['gainValue'];
    deltaGain = json['deltaGain'];
    deltaGainPercentage = json['deltaGainPercentage'];
    lidSent = json['lidSent'];
    lidReceived = json['lidReceived'];
    totalInvestment = json['totalInvestment'];
    totalCashout = json['totalCashout'];
    totalLidPurchased = json['totalLidPurchased'];
    totalLidReceived = json['totalLidReceived'];
    totalLidCashout = json['totalLidCashout'];
    totalLidSent = json['totalLidSent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gainValue'] = this.gainValue;
    data['deltaGain'] = this.deltaGain;
    data['deltaGainPercentage'] = this.deltaGainPercentage;
    data['lidSent'] = this.lidSent;
    data['lidReceived'] = this.lidReceived;
    data['totalInvestment'] = this.totalInvestment;
    data['totalCashout'] = this.totalCashout;
    data['totalLidPurchased'] = this.totalLidPurchased;
    data['totalLidReceived'] = this.totalLidReceived;
    data['totalLidCashout'] = this.totalLidCashout;
    data['totalLidSent'] = this.totalLidSent;
    return data;
  }
}
