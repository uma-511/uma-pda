import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/service/service_method.dart';
import 'package:flutter_uma/vo/config_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SweepCodePageDetailBloc extends BlocBase {

  ConfigVo _configVo;
  BehaviorSubject<List<ConfigData>> _configDataController = BehaviorSubject<List<ConfigData>>();
  Sink<List<ConfigData>> get _configDataSink => _configDataController.sink;
  Stream<List<ConfigData>> get configDataStream => _configDataController.stream;

  Future<List<ConfigData>> getConfigs() {
    return requestPost('getConfigs').then((val) {
      _configVo = ConfigVo.fromJson(val);
      if (_configVo.code == '200') {
        _configDataSink.add(_configVo.data);
      } else {
        showToast(_configVo.message);
      }
      return _configVo.data;
    });
  }

  @override
  void dispose() {
    _configDataController.close();
  }
}