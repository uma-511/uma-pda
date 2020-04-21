import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_message_dialog.dart';

class SweepCodePageFloatingActionButton extends StatelessWidget {
  final SweepCodePageBloc _bloc;
  final SettingDrawerPageBloc _settingDrawerPageBloc;
  SweepCodePageFloatingActionButton(
    this._bloc,
    this._settingDrawerPageBloc
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _settingDrawerPageBloc.userNameStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return Container();
        } else {
          return SpeedDial(
            child: ImageIcon(
              AssetImage('assets/icon/icon_fun.png'),
              size: 42,
            ),
            children:[
              SpeedDialChild(
                  child: ImageIcon(
                    AssetImage('assets/icon/icon_clean.png')
                  ),
                  backgroundColor: Color(0xFFED4014),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CommonMessageDialog(
                          title: '清空确认',
                          widget: Text('是否确认清空'),
                          onCloseEvent: () {
                            Navigator.pop(context);
                          },
                          onPositivePressEvent: () {
                            _bloc.cleanCacheVo();
                            Navigator.pop(context);
                          },
                          negativeText: '取消',
                          positiveText: '确定',
                        );
                      }
                    );
                  }
              ),
            ]
          );
        }
      },
    );
  }
}