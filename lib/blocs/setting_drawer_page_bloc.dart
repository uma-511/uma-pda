import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_preference_keys.dart';
import 'package:flutter_uma/common/common_preference_utils.dart';
import 'package:rxdart/rxdart.dart';

class SettingDrawerPageBloc extends BlocBase {

  BehaviorSubject<String> _userNameController = BehaviorSubject<String>();
  Sink<String> get _userNameSink => _userNameController.sink;
  Stream<String> get userNameStream => _userNameController.stream;

  getUserName() async {
    String userName = await CommonPreferenceUtils().getString(key: CommonPerferenceKeys.userNameKey);
    _userNameSink.add(userName);
  }

  @override
  void dispose() {
    _userNameController.close();
  }

}