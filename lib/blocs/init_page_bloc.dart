import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/home_page.dart';
import 'package:flutter_uma/pages/login_page.dart';
import 'package:flutter_uma/pages/system_setting_page.dart';

class InitPageBloc extends BlocBase {

  /// 初始化
  initPage(BuildContext context) async {

    /// 检查是否已设置IP与标签长度
    String ip = await getIP();
    int labelLength = await getLabelLength();
    if (ip == null || labelLength == null) {
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => SystemSettingPage()), (route) => route == null);
      return;
    }

    /// 检查登录状态
    String token = await getToken();
    if (token == null) {
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
      return;
    }

    /// 校验Token 是否有效(未完成)
    
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => route == null);
  }

  @override
  void dispose() {
  }
}