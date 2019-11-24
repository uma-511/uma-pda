import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/login_page_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LoginPageBloc _bloc = BlocProvider.of<LoginPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Container(
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _accountController,
              decoration: InputDecoration(
                icon: ImageIcon(AssetImage('assets/icon/icon_account.png'), color: Colors.blue),
                hintText: '请输入账号'
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                icon: ImageIcon(AssetImage('assets/icon/icon_password.png'), color: Colors.blue),
                hintText: '请输入密码'
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(50)),
            InkWell(
              child: Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setHeight(88),
                decoration: BoxDecoration(
                  color: Color(0xFF5CADFF),
                  borderRadius: BorderRadius.circular(88)
                ),
                child: Text(
                  '登录',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
              onTap: () {
                _bloc.login(context, _accountController.text, _passwordController.text);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}