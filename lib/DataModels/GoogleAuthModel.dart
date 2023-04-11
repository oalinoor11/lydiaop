class GoogleAuthModel {
  String status;
  bool ok;
  var code;
  String message;
  Result result;

  GoogleAuthModel({this.status, this.ok, this.code, this.message, this.result});

  GoogleAuthModel.fromJson(Map<String, dynamic> json) {
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
  String token;
  String refreshToken;
  UserData userData;

  Result({this.token, this.refreshToken, this.userData});

  Result.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    if (this.userData != null) {
      data['userData'] = this.userData.toJson();
    }
    return data;
  }
}

class UserData {
  String sId;
  ProfileImg profileImg;
  String firstName;
  String lastName;
  String email;
  String accountId;
  var pin;

  UserData({
    this.sId,
    this.profileImg,
    this.firstName,
    this.lastName,
    this.email,
    this.accountId,
    this.pin,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImg = json['profileImg'] != null
        ? new ProfileImg.fromJson(json['profileImg'])
        : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    accountId = json['accountId'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.profileImg != null) {
      data['profileImg'] = this.profileImg.toJson();
    }
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['accountId'] = this.accountId;
    data['pin'] = this.pin;
    return data;
  }
}

class ProfileImg {
  String filePath;

  ProfileImg({this.filePath});

  ProfileImg.fromJson(Map<String, dynamic> json) {
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filePath'] = this.filePath;
    return data;
  }
}
