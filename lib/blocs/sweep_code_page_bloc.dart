import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_preference_keys.dart';
import 'package:flutter_uma/common/common_preference_utils.dart';
import 'package:flutter_uma/service/http_util.dart';
import 'package:flutter_uma/vo/commen_vo.dart';
import 'package:flutter_uma/vo/label_msg_vo.dart';
import 'package:flutter_uma/vo/sweep_code_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:rxdart/rxdart.dart';

class SweepCodePageBloc extends BlocBase {

  /// 获取标签信息
  getLabelMsg(String labelNumber, int status, TextEditingController _textEditingController, bool isAdd, TextEditingController scanNumberEditingController) async {
    bool labelNumberIsExist = _getSweepCodeIsExist(labelNumber);
    bool labelNumberIsList = _getSweepCodeIsList(labelNumber, _textEditingController);
    bool isCheckLabel = true;
    if (status == 7 && !isAdd && scanNumberEditingController.text == '') {
      showToast('请输入出库单号');
      _textEditingController.text = '';
      return;
    }
    if (status == 7 && !isAdd) {
      isCheckLabel = false;
    }

    if (labelNumberIsList) {
      showToast('超过规定列表长度');
      return;
    }

    if (labelNumberIsExist) {
      _textEditingController.text = '';
      showToast('请勿重复扫描');
      palyVideo(false);
    } else {
      var formData = {
        'labelNumber': labelNumber,
        'status': status,
        'scanNumber': scanNumberEditingController.text,
        'isCheckLabel': isCheckLabel,
        'isAdd': isAdd
      };
      await HttpUtil().post('getLabelMsg', data: formData).then((val) {
        _textEditingController.text = '';
        if (val != null) {
          LabelMsgVo labelMsgVo = LabelMsgVo.fromJson(val);
          if (labelMsgVo.code == '200') {
            palyVideo(true);
            for (LabelMsgData data in labelMsgVo.data) {
              _saveLabelMsg(data);
            }
          } else {
            palyVideo(false);
            showToast(labelMsgVo.message);
          }
        } else {
          showToast('获取标签信息异常');
        }
      });
    }
  }

  /// 播放音频
  palyVideo(bool isSuccess) async {
    AudioCache audioCache = AudioCache(prefix: 'mp3/');
    audioCache.play(isSuccess ? 'success.mp3' : 'error.mp3');
  }

  /// 是否上存中
  BehaviorSubject<bool> _updateLoadingController = BehaviorSubject<bool>();
  Sink<bool> get _updateLoadingSink => _updateLoadingController.sink;
  Stream<bool> get updateLoadingStream => _updateLoadingController.stream;
  setUpdateLoading(bool showLoading) {
    _updateLoadingSink.add(showLoading);
  }

  /// 上传标签信息
  uploadData(int status, String scanUser, TextEditingController scanNumberEditingController, bool isAdd) async {
    setUpdateLoading(true);
    SweepCodeVo _sweepCodeVo = _sweepCodeVoStr == '{}' ? SweepCodeVo(generalization: [], labelList: []) : SweepCodeVo.fromJson(jsonDecode(_sweepCodeVoStr));
    List<Map<String, dynamic>> labelList = [];
    _sweepCodeVo.labelList.forEach((item) {
      labelList.add({
        'labelNumber': '${item.labelNumber}',
        'scanTime': '${item.scanTime}'
      });
    });
    if (labelList.length == 0) {
      showToast('请扫描标签');
      setUpdateLoading(false);
      return;
    }
    bool isCheckLabel = true;
    if (status == 7 && !isAdd) {
      isCheckLabel = false;
    }
    
    var formData = {
      'labelList': labelList,
      'scanUser': scanUser,
      'status': status,
      'scanNumber': scanNumberEditingController.text,
      'isAdd': isAdd,
      'isCheckLabel': isCheckLabel
    };
    await HttpUtil().post('uploadData', data: formData).then((val) {
      if (null != val) {
        CommonVo commonVo = CommonVo.fromJson(val);
        if (commonVo.code == '200') {
          showToast('数据上传成功');
          cleanSweepCodeRecord();
        } else {
          showToast(commonVo.message);
        }
      } else {
        showToast('数据上传异常');
      }
      setUpdateLoading(false);
    });
  }
  

  /// -----------------------------------------------------------------------------------------
  SweepCodeVo _sweepCodeVo;
  String _sweepCodeVoStr = '{}';
  BehaviorSubject<SweepCodeVo> _sweepCodeVoController = BehaviorSubject<SweepCodeVo>();
  Sink<SweepCodeVo> get _sweepCodeVoSink => _sweepCodeVoController.sink;
  Stream<SweepCodeVo> get sweepCodeVoStream => _sweepCodeVoController.stream;

  String _sweepCodeVokey;
  /// 初始化缓存key
  initSweepCodeVokey(int type, bool isAdd) {
    _sweepCodeVokey = CommonPerferenceKeys.sweepCodeVokey;
    _sweepCodeVokey = '$_sweepCodeVokey'+'_$type'+'_$isAdd';
  }
  /// 获取缓存标签信息
  getSweepCodeVo() {
    CommonPreferenceUtils().getString(key: _sweepCodeVokey, defaultValue: '{}').then((val) {
      _sweepCodeVoStr = val;
      _sweepCodeVo = _sweepCodeVoStr == '{}' ? SweepCodeVo(labelList: [], generalization: []) : SweepCodeVo.fromJson(jsonDecode(_sweepCodeVoStr));
      _sweepCodeVoSink.add(_sweepCodeVo);
    });
  }

  /// 保存标签缓存信息
  _saveLabelMsg(LabelMsgData labelMsgData) {
    bool _included = false; // 此型号是否存在
    bool _isRepeatedScanning = false; // 此标签是否存在
    int _removeIndex = 0;

    LabeInfoVo _labeInfoVo = _getLabeInfoVo(
                                labelMsgData.chemicalFiberLabelInfoVo.labelNumber,
                                labelMsgData.chemicalFiberLabelInfoVo.factPerBagNumber,
                                labelMsgData.chemicalFiberLabelInfoVo.netWeight,
                                labelMsgData.chemicalFiberLabelInfoVo.tare,
                                labelMsgData.chemicalFiberLabelInfoVo.grossWeight
                              );

    for (int i = 0; i < _sweepCodeVo.generalization.length; i++) {
      if (_sweepCodeVo.generalization[i].prodModel == labelMsgData.chemicalFiberProductionInfoVo.prodModel) {
        _included = true;
        _removeIndex = i;
        _sweepCodeVo.generalization[i].labeInfoVo.forEach((labelItem) {
          if (labelItem.labelNumber == labelMsgData.chemicalFiberLabelInfoVo.labelNumber) {
            _isRepeatedScanning = true;
            return;
          }
        });
        if (!_isRepeatedScanning) {
          _sweepCodeVo.generalization[i].labeInfoVo.insert(0,
             _labeInfoVo
          );
        }
      }
    }

    // 新增缓存信息
    if (!_included) {
      _sweepCodeVo.generalization.insert(
        0, 
        Generalization(
          prodModel: labelMsgData.chemicalFiberProductionInfoVo.prodModel,
          prodName: labelMsgData.chemicalFiberProductionInfoVo.prodName,
          prodColor: labelMsgData.chemicalFiberProductionInfoVo.prodColor,
          prodFineness: labelMsgData.chemicalFiberProductionInfoVo.prodFineness,
          labeInfoVo: [
            _labeInfoVo
          ]
        )
      );
    } else {
      Generalization _generalization = _sweepCodeVo.generalization[_removeIndex];
      _sweepCodeVo.generalization.removeAt(_removeIndex);
      _sweepCodeVo.generalization.insert(0, _generalization);
    }

    if (_isRepeatedScanning) {
      showToast('请勿重复扫描');
    } else {
      showToast('扫描成功');
      _sweepCodeVo.labelList.insert(
        0, 
        LabelList(
          labelNumber: _labeInfoVo.labelNumber, 
          scanTime: _labeInfoVo.scanTime, 
          prodColor: labelMsgData.chemicalFiberProductionInfoVo.prodColor, 
          prodFineness: labelMsgData.chemicalFiberProductionInfoVo.prodFineness
        )
      );
      _notifyChanges(_sweepCodeVo);
    }
  }

  /// 生成LabeInfoVo
  LabeInfoVo _getLabeInfoVo(labelNumber, factPerBagNumber, netWeight, tare, grossWeight) {
    return LabeInfoVo(
      labelNumber: labelNumber,
      factPerBagNumber: factPerBagNumber,
      netWeight: netWeight,
      tare: tare,
      grossWeight: grossWeight,
      scanTime: DateUtil.getNowDateMs()
    );
  }

  /// 更新缓存
  _notifyChanges(SweepCodeVo sweepCodeVo) {
    _sweepCodeVoStr = json.encode(sweepCodeVo);
    CommonPreferenceUtils().saveString(key: _sweepCodeVokey, value: _sweepCodeVoStr);
    _sweepCodeVo = SweepCodeVo();
    _sweepCodeVo = sweepCodeVo == null ? SweepCodeVo() : sweepCodeVo;
    _sweepCodeVoSink.add(_sweepCodeVo);
  }

  /// 清空缓存
  cleanSweepCodeRecord() {
    _notifyChanges(SweepCodeVo(generalization: [], labelList: []));
  }

  /// 获取扫描单号是否存在
  bool _getSweepCodeIsExist(String labelNumber) {
    bool _labelNumberIsExis = false;
    SweepCodeVo _sweepCodeVo = _sweepCodeVoStr == '{}' ? SweepCodeVo(generalization: [], labelList: []) : SweepCodeVo.fromJson(jsonDecode(_sweepCodeVoStr));
    _sweepCodeVo.labelList.forEach((item) {
      if (labelNumber == item.labelNumber) {
        _labelNumberIsExis = true;
        return;
      }
    });
    return _labelNumberIsExis;
  }
  /// 获取扫描单号是否存在
  bool _getSweepCodeIsList(String labelNumber, TextEditingController _textEditingController)  {
    bool _labelNumberIsExis = false;
    SweepCodeVo _sweepCodeVo = _sweepCodeVoStr == '{}' ? SweepCodeVo(generalization: [], labelList: []) : SweepCodeVo.fromJson(jsonDecode(_sweepCodeVoStr));
    _textEditingController.addListener(() async {
      getListSize().then((listSize) {
        if (listSize == listSize) {
          _labelNumberIsExis = true;
          return _labelNumberIsExis;
        }
      });
    });
    return _labelNumberIsExis;
  }

  /// 根据标签号删除
  deleteLabelByLabelNumber(String labelNumber) {
    SweepCodeVo _sweepCodeVo = _sweepCodeVoStr == '{}' ? SweepCodeVo(generalization: [], labelList: []) : SweepCodeVo.fromJson(jsonDecode(_sweepCodeVoStr));
    List<LabelList> _labelList = [];
    _sweepCodeVo.labelList.forEach((item) {
      if (item.labelNumber != labelNumber) {
        _labelList.add(item);
      }
    });

    List<Generalization> _generalization = [];
    _sweepCodeVo.generalization.forEach((item) {
      Generalization _tempGeneralization = item;
      if (item.labeInfoVo.length > 1) {
        List<LabeInfoVo> labeInfoVo = [];
        item.labeInfoVo.forEach((labeInfoVoItem) {
          if (labeInfoVoItem.labelNumber != labelNumber) {
            labeInfoVo.add(labeInfoVoItem);
          }
        });
        _tempGeneralization.labeInfoVo = labeInfoVo;
        _generalization.add(_tempGeneralization);
      } else {
        item.labeInfoVo.forEach((labeInfoVoItem) {
          if (labeInfoVoItem.labelNumber != labelNumber) {
            _generalization.add(_tempGeneralization);
          }
        });
      }
    });

    SweepCodeVo _temp = SweepCodeVo(labelList: _labelList, generalization: _generalization);
    _notifyChanges(_temp);
  }

  @override
  void dispose() {
    _sweepCodeVoController.close();
    _updateLoadingController.close();
  }
}