class PersonInfoVo {
  String code;
  String message;
  PersonInfoVoData data;

  PersonInfoVo({this.code, this.message, this.data});

  PersonInfoVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new PersonInfoVoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PersonInfoVoData {
  String id;
  String avatar;
  String account;
  String nikeName;
  int userType;

  PersonInfoVoData({this.id, this.avatar, this.account, this.nikeName, this.userType});

  PersonInfoVoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    account = json['account'];
    nikeName = json['nikeName'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['account'] = this.account;
    data['nikeName'] = this.nikeName;
    data['userType'] = this.userType;
    return data;
  }
}
