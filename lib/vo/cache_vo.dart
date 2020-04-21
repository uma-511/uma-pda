import 'package:flutter_uma/vo/post_label_record_vo.dart';

class CacheVo {
  String hash;
  List<PostLabelRecordData> recordList;

  CacheVo({this.hash, this.recordList});

  CacheVo.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    if (json['list'] != null) {
      recordList = new List<PostLabelRecordData>();
      json['list'].forEach((v) {
        recordList.add(new PostLabelRecordData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    if (this.recordList != null) {
      data['list'] = this.recordList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<CacheVo> fromJsonList(dynamic maps) {
    List<CacheVo> list = List(maps.length);
    for (int i = 0; i < maps.length; i++) {
      list[i] = CacheVo.fromJson(maps[i]);
    }
    return list;
  }
}