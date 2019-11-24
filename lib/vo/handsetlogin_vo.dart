class HandsetloginVo {
  String code;
  String message;
  HandsetloginVoData data;

  HandsetloginVo({this.code, this.message, this.data});

  HandsetloginVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new HandsetloginVoData.fromJson(json['data']) : null;
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

class HandsetloginVoData {
  String token;
  User user;

  HandsetloginVoData({this.token, this.user});

  HandsetloginVoData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String username;
  String avatar;
  String email;
  String phone;
  String dept;
  String job;
  bool enabled;
  int createTime;
  List<String> roles;

  User(
      {this.username,
      this.avatar,
      this.email,
      this.phone,
      this.dept,
      this.job,
      this.enabled,
      this.createTime,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    dept = json['dept'];
    job = json['job'];
    enabled = json['enabled'];
    createTime = json['createTime'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['dept'] = this.dept;
    data['job'] = this.job;
    data['enabled'] = this.enabled;
    data['createTime'] = this.createTime;
    data['roles'] = this.roles;
    return data;
  }
}
