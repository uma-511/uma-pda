import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_common.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_floatingActionButton.dart';

class SweepCodePage extends StatefulWidget {
  final String title;
  final String type;
  SweepCodePage(this.title, this.type);
  @override
  _SweepCodePageState createState() => _SweepCodePageState();
}

class _SweepCodePageState extends State<SweepCodePage> with TickerProviderStateMixin {
  TabController _controller;
  TextEditingController _textEditingController;
  SweepCodePageBloc _bloc;
  SettingDrawerPageBloc _settingDrawerPageBloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<SweepCodePageBloc>(context);
    _settingDrawerPageBloc = BlocProvider.of<SettingDrawerPageBloc>(context);
    _controller = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this
    );
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() async {
      getLabelLength().then((labelLength) {
        if (_textEditingController.text.length == labelLength) {
          _bloc.postLabelRecord(_textEditingController.text, widget.type, _textEditingController);
        }
      });      
    });
    _bloc.initSweepCodeVokey(widget.type);
    _bloc.getSweepCodeVo();
    _settingDrawerPageBloc.getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                icon: ImageIcon(
                  AssetImage('assets/icon/icon_bar_code.png'),
                  color: Colors.blue,
                )
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          SweepCodePageCommon(_controller, _bloc)
        ],
      ),
      floatingActionButton: SweepCodePageFloatingActionButton(_bloc, _settingDrawerPageBloc),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}