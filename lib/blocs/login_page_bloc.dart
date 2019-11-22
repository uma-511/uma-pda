import 'package:flutter/cupertino.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/home_page.dart';
import 'package:oktoast/oktoast.dart';

class LoginPageBloc extends BlocBase {

  /// 登录
  login(BuildContext context, String account, String password) {
    if (account.isEmpty) {
      showToast('请输入账号');
      return;
    }
    if (password.isEmpty) {
      showToast('请输入密码');
      return;
    }

    /// 登录操作(未完成)
    
    saveToken('$account$password');
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => route == null);
  }


  @override
  void dispose() {
  }
  
}