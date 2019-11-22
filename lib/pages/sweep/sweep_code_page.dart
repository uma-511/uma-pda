import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_message_dialog.dart';
import 'package:flutter_uma/common/common_show_loading.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_detail.dart';
import 'package:flutter_uma/vo/sweep_code_vo.dart';

class SweepCodePage extends StatefulWidget {
  final String title;
  /// 0：待入库 1：入库 2：出库 3：作废 4：退库 5：退货
  final int type;
  SweepCodePage(this.title, this.type);
  @override
  _SweepCodePageState createState() => _SweepCodePageState();
}

class _SweepCodePageState extends State<SweepCodePage> with TickerProviderStateMixin {
  TabController _controller;
  TextEditingController _textEditingController;
  SweepCodePageBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<SweepCodePageBloc>(context);
    _controller = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this
    );
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() async {
      getLabelLength().then((labelLength) {
        if (_textEditingController.text.length == labelLength) {
          _bloc.getLabelMsg(_textEditingController.text, widget.type, _textEditingController);
        }
      });      
    });
    _bloc.initSweepCodeVokey(widget.type);
    _bloc.getSweepCodeVo();
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
          Expanded(
            child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey
                      )
                    )
                  ),
                  child: TabBar(
                    controller: _controller,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black,
                    tabs: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(100),
                        child: Text('概括'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(100),
                        child: Text('汇总'),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      _buildGeneralization(),
                      _buildSummary(),
                    ],
                  ),
                )
              ],
            )
          ),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
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
                        _bloc.cleanSweepCodeRecord();
                        Navigator.pop(context);
                      },
                      negativeText: '取消',
                      positiveText: '确定',
                    );
                  }
                );
              }
          ),
          SpeedDialChild(
              child: ImageIcon(
                AssetImage('assets/icon/icon_upload.png')
              ),
              backgroundColor: Color(0xFF19BE6B),
              onTap: () {
                _bloc.uploadData(widget.type);
              }
          ),
        ]
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  /// 概括
  _buildGeneralization() {
    return StreamBuilder(
      stream: _bloc.sweepCodeVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return CommonShowLoading();
        } else {
          SweepCodeVo _sweepCodeVo = sanpshop.data;
          if (_sweepCodeVo.generalization.length == 0) {
            return ImageIcon(AssetImage('assets/icon/icon_no_time.png'), color: Colors.grey[400]);
          } else {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: _sweepCodeVo.generalization.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]
                        )
                      )
                    ),
                    child: ListTile(
                      title: Text('型号：${_sweepCodeVo.generalization[index].prodModel}'),
                      subtitle: Text('数量：${_sweepCodeVo.generalization[index].labeInfoVo.length}'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePageDetail(_sweepCodeVo.generalization[index])));
                      },
                    ),
                  );
                },
              ),
            );
          }
        }
      }
    );
  }

  /// 汇总
  _buildSummary() {
    return StreamBuilder(
      stream: _bloc.sweepCodeVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return CommonShowLoading();
        } else {
          SweepCodeVo _sweepCodeVo = sanpshop.data;
          if (_sweepCodeVo.labelList.length == 0) {
            return ImageIcon(AssetImage('assets/icon/icon_no_time.png'), color: Colors.grey[400]);
          } else {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: _sweepCodeVo.labelList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]
                        )
                      )
                    ),
                    child: ListTile(
                      title: Text(_sweepCodeVo.labelList[index].labelNumber),
                      subtitle: Text('${DateUtil.formatDateMs(_sweepCodeVo.labelList[index].scanTime)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CommonMessageDialog(
                                title: '删除确认',
                                widget: Text('是否确认删除此标签'),
                                onCloseEvent: () {
                                  Navigator.pop(context);
                                },
                                onPositivePressEvent: () {
                                  _bloc.deleteLabelByLabelNumber(_sweepCodeVo.labelList[index].labelNumber);
                                  Navigator.pop(context);
                                },
                                negativeText: '取消',
                                positiveText: '确定',
                              );
                            }
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}