import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/system_setting_page_bloc.dart';
import 'package:flutter_uma/common/common_show_loading.dart';

class SystemSettingPage extends StatefulWidget {
  @override
  _SystemSettingPageState createState() => _SystemSettingPageState();
}

class _SystemSettingPageState extends State<SystemSettingPage> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemSettingPageBloc _bloc = BlocProvider.of<SystemSettingPageBloc>(context);
    _bloc.getIPAndLabelLength();
    return Scaffold(
      appBar: AppBar(
        title: Text('系统设置'),
      ),
      body: StreamBuilder(
        stream: _bloc.iPAndLabelLengthStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            Map<String, String> map = sanpshop.data;
            return Container(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[
                  TextField(
                    controller: _ipController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      helperText: map['ip'] == null ? '未设置' : map['ip'],
                      hintText: '请输入系统IP/链接',
                      icon: ImageIcon(AssetImage('assets/icon/icon_link.png'), color: Colors.blue)
                    ),
                  ),
                  TextField(
                    controller: _labelController,
                    decoration: InputDecoration(
                      helperText: map['labelLength'] == null ? '未设置' : map['labelLength'],
                      hintText: '请输入标签长度',
                      icon: ImageIcon(AssetImage('assets/icon/icon_label.png'), color: Colors.blue),
                    ),
                    keyboardType: TextInputType.number,
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CommonShowLoading();
                        }
                      );
                      _bloc.saveIPAndLabelLength(context, _ipController.text, _labelController.text);
                    },
                  )
                ],
              ),
            );
          } else {
            return CommonShowLoading();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    _labelController.dispose();
    super.dispose();
  }
}