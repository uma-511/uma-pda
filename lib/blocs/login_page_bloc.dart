import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/home_page.dart';
import 'package:flutter_uma/service/http_util.dart';
import 'package:flutter_uma/vo/handsetlogin_vo.dart';
import 'package:oktoast/oktoast.dart';

class LoginPageBloc extends BlocBase {
  User user;
  /// 登录
  login(BuildContext context, String account, String password) async {
    if (account.isEmpty) {
      showToast('请输入账号');
      return;
    }
    if (password.isEmpty) {
      showToast('请输入密码');
      return;
    }

    /// 登录操作(未完成)
    var data = {
      'password': password,
      'username': account
    };
    await HttpUtil().post('handsetlogin', data: data).then((val) {
      HandsetloginVo handsetloginVo = HandsetloginVo.fromJson(val);
      if (handsetloginVo.code == '200') {
        saveToken(handsetloginVo.data.token);
        user = handsetloginVo.data.user;
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => route == null);
      } else {
        showToast('账号或密码错误');
      }
    });
  }


  @override
  void dispose() {
  }
  
}