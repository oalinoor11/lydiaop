class SetPinModel {
  String status;
  bool ok;
  var code;
  String message;
  var result;

  SetPinModel({this.status, this.ok, this.code, this.message, this.result});

  SetPinModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ok = json['ok'];
    code = json['code'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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
  ProfileImg profileImg;
  bool active;
  bool isDelete;
  String sId;
  String firstName;
  String lastName;
  String email;
  String createdDate;
  String updatedDate;
  int iV;
  String refreshToken;
  String tPinHash;

  Result(
      {this.profileImg,
      this.active,
      this.isDelete,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.createdDate,
      this.updatedDate,
      this.iV,
      this.refreshToken,
      this.tPinHash});

  Result.fromJson(Map<String, dynamic> json) {
    profileImg = json['profileImg'] != null
        ? new ProfileImg.fromJson(json['profileImg'])
        : null;
    active = json['active'];
    isDelete = json['isDelete'];
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    iV = json['__v'];
    refreshToken = json['refreshToken'];
    tPinHash = json['TPinHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileImg != null) {
      data['profileImg'] = this.profileImg.toJson();
    }
    data['active'] = this.active;
    data['isDelete'] = this.isDelete;
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['__v'] = this.iV;
    data['refreshToken'] = this.refreshToken;
    data['TPinHash'] = this.tPinHash;
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
