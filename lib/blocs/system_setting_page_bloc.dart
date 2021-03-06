import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/home_page.dart';
import 'package:flutter_uma/pages/login_page.dart';
import 'package:flutter_uma/service/http_util.dart';
import 'package:flutter_uma/service/service_url.dart';
import 'package:flutter_uma/vo/commen_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class SystemSettingPageBloc extends BlocBase {

  BehaviorSubject<Map<String, String>> _iPAndLabelLengthController = BehaviorSubject<Map<String, String>>();
  Sink<Map<String, String>> get _iPAndLabelLengthSink => _iPAndLabelLengthController.sink;
  Stream<Map<String, String>> get iPAndLabelLengthStream => _iPAndLabelLengthController.stream;

  /// 校验IP并保存IP与标签长度
  saveIPAndLabelLength(BuildContext context, String ip, String labelLength, String listSize) async {
    if (ip.isEmpty) {
      showToast('请填写系统IP/链接');
      return;
    }
    
    if (labelLength.isEmpty) {
      showToast('请填写标签长度');
      return;
    }

    if (listSize.isEmpty) {
      showToast('请填写列表最大输入值');
      return;
    }


    bool checkIPEffective = await _checkIPEffective(ip);
    if (checkIPEffective) {
      setIPAndLabelLength(ip, int.parse(labelLength),int.parse(listSize));
      /// 检查登录状态
      String token = await getToken();
      if (token == null) {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
        return;
      } else {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => route == null);
      }
    } else {
      Navigator.pop(context);
      showToast('系统链接失败');
      return;
    }
  }

  getIPAndLabelLength() async {
    String ip = await getIP();
    int labelLength = await getLabelLength();
    int listSize = await getListSize();
    Map<String, String> tempMap = Map();
    tempMap['ip'] = ip;
    tempMap['labelLength'] = labelLength.toString();
    tempMap['listSize'] = listSize.toString();
    _iPAndLabelLengthSink.add(tempMap);
  }

  /// 校验IP是否有效并缓存
  Future<bool> _checkIPEffective(String ip) async {
    var val = await HttpUtil().get('http://$ip' + servicePath['handheldInit']);
    if (val != null) {
      CommonVo commonVo = CommonVo.fromJson(val);
      if (commonVo.code == '200') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _iPAndLabelLengthController.close();
  }
}