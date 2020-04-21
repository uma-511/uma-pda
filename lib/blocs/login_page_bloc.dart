import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_preference_keys.dart';
import 'package:flutter_uma/common/common_preference_utils.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/home_page.dart';
import 'package:flutter_uma/service/http_util.dart';
import 'package:flutter_uma/vo/login_vo.dart';
import 'package:flutter_uma/vo/person_info_vo.dart';
import 'package:oktoast/oktoast.dart';

class LoginPageBloc extends BlocBase {
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
      'phone': account
    };
    await HttpUtil().post('handsetlogin', data: data).then((val) {
      LoginVo loginVo = LoginVo.fromJson(val);
      if (loginVo.code == '200') {
        saveToken(loginVo.data.accessToken);
        HttpUtil(token: loginVo.data.accessToken).post('getPersonInfo').then((val) {
          PersonInfoVo personInfoVo = PersonInfoVo.fromJson(val);
          if (personInfoVo.code == '200') {
            CommonPreferenceUtils().saveString(key: CommonPerferenceKeys.userNameKey, value: personInfoVo.data.nikeName);
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => route == null);
          } else {
            showToast(personInfoVo.message);
          }
        });
      } else {
        showToast('账号或密码错误');
      }
    });
  }


  @override
  void dispose() {
  }
  
}