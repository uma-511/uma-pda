import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/common/common_message_dialog.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/login_page.dart';
import 'package:flutter_uma/pages/system_setting_page.dart';
import 'package:oktoast/oktoast.dart';

class SettingDrawerPage extends StatelessWidget {
  final TextEditingController _settingPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SettingDrawerPageBloc _bloc = BlocProvider.of<SettingDrawerPageBloc>(context);
    _bloc.getUserName();
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: ScreenUtil().setWidth(600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                child: ImageIcon(
                  AssetImage('assets/icon/icon_uma_logo.png'), 
                  color: Colors.orange,
                  size: 46,
                )
              ),
              Container(
                child: StreamBuilder(
                  stream: _bloc.userNameStream,
                  builder: (context, sanpshop) {
                    if (sanpshop.hasData) {
                      return ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     'https://p1.meituan.net/320.0/hotelbiz/1faa65f7a1446a07c01b2acbc1a9b47e372596.jpg'
                        //   ),
                        // ),
                        title: Text(
                          sanpshop.data,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(48)
                          ),  
                        ),
                      );
                    } else {
                      return ListTile();
                    }
                  },
                ),
              ),
              ListTile(
                trailing: ImageIcon(AssetImage('assets/icon/icon_setting.png'), color: Colors.grey[300]),
                title: Text(
                  '系统设置',
                  style: TextStyle(
                    color: Colors.grey[300]
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        width: ScreenUtil().setWidth(750),
                        height: ScreenUtil().setHeight(310),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _settingPasswordController,
                              obscureText: true,
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
                                  '确认',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              onTap: () {            
                                if (_settingPasswordController.text == 'um_admin') {
                                  Navigator.pop(context);
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => SystemSettingPage()));
                                } else {
                                  showToast('系统设置密码错误');
                                }
                              },
                            )
                          ],
                        ),
                      );
                    }
                  );
                },
              ),
              Divider(),
              ListTile(
                trailing: ImageIcon(AssetImage('assets/icon/icon_logout.png'), color: Colors.grey[300]),
                title: Text(
                  '退出登录',
                  style: TextStyle(
                    color: Colors.grey[300]
                  )
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CommonMessageDialog(
                        widget: Text('您确定退出吗？'),
                        negativeText: '取消',
                        title: '退出确认',
                        positiveText: '确定',
                        onCloseEvent: () {
                          Navigator.pop(context);
                        },
                        onPositivePressEvent: () {
                          cleanToken();
                          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
                        },
                      );
                    }
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: ImageIcon(AssetImage('assets/icon/icon_version.png'), color: Colors.grey[300]),
                title: Text(
                  '1.0.0',
                  style: TextStyle(
                    color: Colors.grey[300]
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}