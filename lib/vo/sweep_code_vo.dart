class SweepCodeVo {
  List<Generalization> generalization;
  List<LabelList> labelList;

  SweepCodeVo({this.generalization, this.labelList});

  SweepCodeVo.fromJson(Map<String, dynamic> json) {
    if (json['generalization'] != null) {
      generalization = new List<Generalization>();
      json['generalization'].forEach((v) {
        generalization.add(new Generalization.fromJson(v));
      });
    }
    if (json['labelList'] != null) {
      labelList = new List<LabelList>();
      json['labelList'].forEach((v) {
        labelList.add(new LabelList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generalization != null) {
      data['generalization'] =
          this.generalization.map((v) => v.toJson()).toList();
    }
    if (this.labelList != null) {
      data['labelList'] = this.labelList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Generalization {
  String prodModel;
  String prodName;
  String prodColor;
  String prodFineness;
  List<LabeInfoVo> labeInfoVo;

  Generalization(
      {this.prodModel,
      this.prodName,
      this.prodColor,
      this.prodFineness,
      this.labeInfoVo});

  Generalization.fromJson(Map<String, dynamic> json) {
    prodModel = json['prodModel'];
    prodName = json['prodName'];
    prodColor = json['prodColor'];
    prodFineness = json['prodFineness'];
    if (json['labeInfoVo'] != null) {
      labeInfoVo = new List<LabeInfoVo>();
      json['labeInfoVo'].forEach((v) {
        labeInfoVo.add(new LabeInfoVo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prodModel'] = this.prodModel;
    data['prodName'] = this.prodName;
    data['prodColor'] = this.prodColor;
    data['prodFineness'] = this.prodFineness;
    if (this.labeInfoVo != null) {
      data['labeInfoVo'] = this.labeInfoVo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabeInfoVo {
  String labelNumber;
  int factPerBagNumber;
  double netWeight;
  double tare;
  double grossWeight;
  int scanTime;

  LabeInfoVo(
      {this.labelNumber,
      this.factPerBagNumber,
      this.netWeight,
      this.tare,
      this.grossWeight,
      this.scanTime});

  LabeInfoVo.fromJson(Map<String, dynamic> json) {
    labelNumber = json['labelNumber'];
    factPerBagNumber = json['factPerBagNumber'];
    netWeight = json['netWeight'];
    tare = json['tare'];
    grossWeight = json['grossWeight'];
    scanTime = json['scanTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelNumber'] = this.labelNumber;
    data['factPerBagNumber'] = this.factPerBagNumber;
    data['netWeight'] = this.netWeight;
    data['tare'] = this.tare;
    data['grossWeight'] = this.grossWeight;
    data['scanTime'] = this.scanTime;
    return data;
  }
}

class LabelList {
  String labelNumber;
  int scanTime;
  String prodColor;
  String prodFineness;

  LabelList({this.labelNumber, this.scanTime, this.prodColor, this.prodFineness});

  LabelList.fromJson(Map<String, dynamic> json) {
    labelNumber = json['labelNumber'];
    scanTime = json['scanTime'];
    prodColor = json['prodColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelNumber'] = this.labelNumber;
    data['scanTime'] = this.scanTime;
    data['prodFineness'] = this.prodFineness;
    return data;
  }
}