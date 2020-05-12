class DeliveryListVo {
  String code;
  String message;
  List<DeliveryList> data;

  DeliveryListVo({this.code, this.message, this.data});

  DeliveryListVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<DeliveryList>();
      json['data'].forEach((v) {
        data.add(new DeliveryList.fromJson(v));
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

class DeliveryList {
  String deliveryNum;
  String customer;
  int id;

  DeliveryList({this.deliveryNum, this.customer});

  DeliveryList.fromJson(Map<String, dynamic> json) {
    deliveryNum = json['deliveryNum'];
    customer = json['customer'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryNum'] = this.deliveryNum;
    data['customer'] = this.customer;
    data['id'] = this.id;
    return data;
  }
}
