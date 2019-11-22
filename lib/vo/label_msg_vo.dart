class LabelMsgVo {
  String code;
  String message;
  LabelMsgData data;

  LabelMsgVo({this.code, this.message, this.data});

  LabelMsgVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new LabelMsgData.fromJson(json['data']) : null;
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

class LabelMsgData {
  ChemicalFiberLabelInfoVo chemicalFiberLabelInfoVo;
  ChemicalFiberProductionInfoVo chemicalFiberProductionInfoVo;

  LabelMsgData({this.chemicalFiberLabelInfoVo, this.chemicalFiberProductionInfoVo});

  LabelMsgData.fromJson(Map<String, dynamic> json) {
    chemicalFiberLabelInfoVo = json['chemicalFiberLabelInfoVo'] != null
        ? new ChemicalFiberLabelInfoVo.fromJson(
            json['chemicalFiberLabelInfoVo'])
        : null;
    chemicalFiberProductionInfoVo =
        json['chemicalFiberProductionInfoVo'] != null
            ? new ChemicalFiberProductionInfoVo.fromJson(
                json['chemicalFiberProductionInfoVo'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chemicalFiberLabelInfoVo != null) {
      data['chemicalFiberLabelInfoVo'] = this.chemicalFiberLabelInfoVo.toJson();
    }
    if (this.chemicalFiberProductionInfoVo != null) {
      data['chemicalFiberProductionInfoVo'] =
          this.chemicalFiberProductionInfoVo.toJson();
    }
    return data;
  }
}

class ChemicalFiberLabelInfoVo {
  String labelNumber;
  int factPerBagNumber;
  double netWeight;
  double tare;
  double grossWeight;

  ChemicalFiberLabelInfoVo(
      {this.labelNumber,
      this.factPerBagNumber,
      this.netWeight,
      this.tare,
      this.grossWeight});

  ChemicalFiberLabelInfoVo.fromJson(Map<String, dynamic> json) {
    labelNumber = json['labelNumber'];
    factPerBagNumber = json['factPerBagNumber'];
    netWeight = json['netWeight'];
    tare = json['tare'];
    grossWeight = json['grossWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelNumber'] = this.labelNumber;
    data['factPerBagNumber'] = this.factPerBagNumber;
    data['netWeight'] = this.netWeight;
    data['tare'] = this.tare;
    data['grossWeight'] = this.grossWeight;
    return data;
  }
}

class ChemicalFiberProductionInfoVo {
  String prodModel;
  String prodName;
  String prodColor;
  String prodFineness;

  ChemicalFiberProductionInfoVo(
      {this.prodModel, this.prodName, this.prodColor, this.prodFineness});

  ChemicalFiberProductionInfoVo.fromJson(Map<String, dynamic> json) {
    prodModel = json['prodModel'];
    prodName = json['prodName'];
    prodColor = json['prodColor'];
    prodFineness = json['prodFineness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prodModel'] = this.prodModel;
    data['prodName'] = this.prodName;
    data['prodColor'] = this.prodColor;
    data['prodFineness'] = this.prodFineness;
    return data;
  }
}