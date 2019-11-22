import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/home_page.dart';
import 'package:flutter_uma/pages/login_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SystemSettingPageBloc extends BlocBase {

  BehaviorSubject<Map<String, String>> _iPAndLabelLengthController = BehaviorSubject<Map<String, String>>();
  Sink<Map<String, String>> get _iPAndLabelLengthSink => _iPAndLabelLengthController.sink;
  Stream<Map<String, String>> get iPAndLabelLengthStream => _iPAndLabelLengthController.stream;

  /// 校验IP并保存IP与标签长度
  saveIPAndLabelLength(BuildContext context, String ip, String labelLength) async {
    if (ip.isEmpty) {
      showToast('请填写系统IP/链接');
      return;
    }
    
    if (labelLength.isEmpty) {
      showToast('请填写标签长度');
      return;
    }

    bool checkIPEffective = _checkIPEffective();
    if (checkIPEffective) {
      setIPAndLabelLength(ip, int.parse(labelLength));
      /// 检查登录状态
      String token = await getToken();
      if (token == null) {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
        return;
      } else {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => route == null);
      }
    } else {
      showToast('系统链接失败');
    }
  }

  getIPAndLabelLength() async {
    String ip = await getIP();
    int labelLength = await getLabelLength();
    Map<String, String> tempMap = Map();
    tempMap['ip'] = ip;
    tempMap['labelLength'] = labelLength.toString();
    _iPAndLabelLengthSink.add(tempMap);
  }



  /// 校验IP是否有效并缓存
  bool _checkIPEffective() {

    return true;
  }

  @override
  void dispose() {
    _iPAndLabelLengthController.close();
  }
}