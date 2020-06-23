import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_preference_keys.dart';
import 'package:flutter_uma/common/common_preference_utils.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/service/http_util.dart';
import 'package:flutter_uma/vo/cache_vo.dart';
import 'package:flutter_uma/vo/delivery_list_vo.dart';
import 'package:flutter_uma/vo/post_label_record_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SweepCodePageBloc extends BlocBase {

  BehaviorSubject<DeliveryListVo> _deliveryListVoController = BehaviorSubject<DeliveryListVo>();
  Sink<DeliveryListVo> get _deliveryListVoSink => _deliveryListVoController.sink;
  Stream<DeliveryListVo> get deliveryListVoStream => _deliveryListVoController.stream;

  /// 插入方式：true 在头部插入，false 在最后添加
  bool _sort = false;
  BehaviorSubject<bool> _sortController = BehaviorSubject<bool>();
  Sink<bool> get _sortSink => _sortController.sink;
  Stream<bool> get sortStream => _sortController.stream;
  setSort() {
    _sort = !_sort;
    _sortSink.add(_sort);
  }

  /// 车间入仓、返仓
  postLabelRecord(String orderNo, String type, TextEditingController textEditingController) async {
    await getToken().then((token) async {
      var data = {
        'orderNo': orderNo,
        'type': type
      };
      await HttpUtil(token: token).post('postLabelRecord', data: data).then((val) {
        PostLabelRecordVo postLabelRecordVo = PostLabelRecordVo.fromJson(val);
        if (postLabelRecordVo.code == '200') {
          showToast('上传成功');
          _saveLabelMsg(postLabelRecordVo.data);
        } else {
          showToast(postLabelRecordVo.message);
        }
      });
    });
    textEditingController.text = '';
  }

  /// 获取客户列表
  deliveryList() async {
    await HttpUtil().post('deliveryList').then((val) {
      DeliveryListVo deliveryListVo = DeliveryListVo.fromJson(val);
      if (deliveryListVo.code == '200') {
        _deliveryListVoSink.add(deliveryListVo);
      } else {
        showToast(deliveryListVo.message);
      }
    });
  }

  /// 车间出仓
  delivery(String deliveryNum, String orderNo, TextEditingController textEditingController) async {
    if (deliveryNum != '') {
      await getToken().then((token) async {
        var data = {
          'deliveryNum': deliveryNum,
          'orderNo': orderNo
        };
        await HttpUtil(token: token).post('delivery', data: data).then((val) {
          PostLabelRecordVo postLabelRecordVo = PostLabelRecordVo.fromJson(val);
          if (postLabelRecordVo.code == '200') {
            showToast('上传成功');
            _saveLabelMsg(postLabelRecordVo.data);
          } else {
            showToast(postLabelRecordVo.message);
          }
        });
      });
    } else {
      showToast('请选择客户');
    }
    textEditingController.text = '';
  }

  ///---------------------------------------------------------------------------------------------------
  String _cacheVokey;
  List<CacheVo> _cacheVo;
  String _cacheVoStr = '[]';
  BehaviorSubject<List<CacheVo>> _cacheVoController = BehaviorSubject<List<CacheVo>>();
  Sink<List<CacheVo>> get _cacheVoSink => _cacheVoController.sink;
  Stream<List<CacheVo>> get cacheVoStream => _cacheVoController.stream;

  /// 初始化缓存key
  initSweepCodeVokey(String type) {
    _cacheVokey = CommonPerferenceKeys.sweepCodeVokey;
    _cacheVokey = '$_cacheVokey'+'_$type';
  }

  /// 获取缓存标签信息
  getSweepCodeVo() {
    CommonPreferenceUtils().getString(key: _cacheVokey, defaultValue: '[]').then((val) {
      _cacheVoStr = val;
      _cacheVo = _cacheVoStr == '[]' ? [] : CacheVo.fromJsonList(jsonDecode(_cacheVoStr));
      _cacheVoSink.add(_cacheVo);
    });
  }

  /// 保存上传成功的标签信息
  _saveLabelMsg(PostLabelRecordData postLabelRecordData) {
    /// 此 hash 是否存在
    bool _hashExiste = false;
    /// 当hash 存在时，记录存在的下标
    int _hashExisteIndex = 0;
    /// 临时下标
    int _tempIndex = 0;
    _cacheVo.forEach((item) {
      if (postLabelRecordData.hash == item.hash) {
        _hashExiste = true;
        _hashExisteIndex = _tempIndex;
      }
      _tempIndex++;
    });
    if (_hashExiste) {
      _sort ? 
        _cacheVo[_hashExisteIndex].recordList.insert(0, postLabelRecordData) :
        _cacheVo[_hashExisteIndex].recordList.add(postLabelRecordData);
    } else {
      List<PostLabelRecordData> tempList = [];
      tempList.add(postLabelRecordData);
      _sort ? 
        _cacheVo.insert(0, CacheVo(
            hash: postLabelRecordData.hash,
            recordList: tempList
          )) :
        _cacheVo.add(CacheVo(
            hash: postLabelRecordData.hash,
            recordList: tempList
          )); 
    }
    _notifyChanges(_cacheVo);
  }

  /// 更新缓存
  _notifyChanges(List<CacheVo> cacheVos) {
    _cacheVoStr = json.encode(cacheVos);
    CommonPreferenceUtils().saveString(key: _cacheVokey, value: _cacheVoStr);
    _cacheVo = [];
    _cacheVo = cacheVos == null ? [] : cacheVos;
    _cacheVoSink.add(_cacheVo);
  }

  /// 清空缓存
  cleanCacheVo() {
    _notifyChanges([]);
    showToast('清空成功');
  }

  @override
  void dispose() {
    _cacheVoController.close();
    _deliveryListVoController.close();
    _sortController.close();
  }
}