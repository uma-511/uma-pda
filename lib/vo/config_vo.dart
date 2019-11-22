class ConfigVo {
  String code;
  String message;
  List<ConfigData> data;

  ConfigVo({this.code, this.message, this.data});

  ConfigVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ConfigData>();
      json['data'].forEach((v) {
        data.add(new ConfigData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConfigData {
  int id;
  int classifyId;
  String name;
  String value;
  int isDefault;

  ConfigData({this.id, this.classifyId, this.name, this.value, this.isDefault});

  ConfigData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classifyId = json['classifyId'];
    name = json['name'];
    value = json['value'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classifyId'] = this.classifyId;
    data['name'] = this.name;
    data['value'] = this.value;
    data['isDefault'] = this.isDefault;
    return data;
  }
}