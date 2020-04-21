class PostLabelRecordVo {
  String code;
  String message;
  PostLabelRecordData data;

  PostLabelRecordVo({this.code, this.message, this.data});

  PostLabelRecordVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new PostLabelRecordData.fromJson(json['data']) : null;
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

class PostLabelRecordData {
  String hash;
  String number;
  String name;
  String specs;
  String width;
  String color;
  String labelNum;
  int quantity;
  String refundNum;
  String deliveryNum;

  PostLabelRecordData(
      {this.hash,
      this.number,
      this.name,
      this.specs,
      this.width,
      this.color,
      this.labelNum,
      this.quantity,
      this.refundNum,
      this.deliveryNum});

  PostLabelRecordData.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    number = json['number'];
    name = json['name'];
    specs = json['specs'];
    width = json['width'];
    color = json['color'];
    labelNum = json['labelNum'];
    quantity = json['quantity'];
    refundNum = json['refundNum'];
    deliveryNum = json['deliveryNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['number'] = this.number;
    data['name'] = this.name;
    data['specs'] = this.specs;
    data['width'] = this.width;
    data['color'] = this.color;
    data['labelNum'] = this.labelNum;
    data['quantity'] = this.quantity;
    data['refundNum'] = this.refundNum;
    data['deliveryNum'] = this.deliveryNum;
    return data;
  }
}