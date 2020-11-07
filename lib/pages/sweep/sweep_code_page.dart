import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_loading_dialog.dart';
import 'package:flutter_uma/common/common_message_dialog.dart';
import 'package:flutter_uma/common/common_show_loading.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_detail.dart';
import 'package:flutter_uma/vo/sweep_code_vo.dart';
import 'package:oktoast/oktoast.dart';

class SweepCodePage extends StatefulWidget {
  final String title;
  /// 0：待入库 1：入库 2：出库 3：作废 4：退库 5：退货
  final int type;
  final bool isAdd;
  SweepCodePage(this.title, this.type, this.isAdd);
  @override
  _SweepCodePageState createState() => _SweepCodePageState();
}

class _SweepCodePageState extends State<SweepCodePage> with TickerProviderStateMixin {
  TabController _controller;
  TextEditingController _textEditingController;
  TextEditingController _scanNumberEditingController;
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
    _scanNumberEditingController = TextEditingController();
    _textEditingController.addListener(() async {
      getLabelLength().then((labelLength) {
        if (_textEditingController.text.length == labelLength) {
          _bloc.getLabelMsg(_textEditingController.text, widget.type, _textEditingController, widget.isAdd, _scanNumberEditingController);
        }
      });
    });
    _bloc.initSweepCodeVokey(widget.type, widget.isAdd);
    _bloc.getSweepCodeVo();
    _settingDrawerPageBloc.getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.setUpdateLoading(false);
    print(widget.isAdd);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[

          IconButton(
            icon: ImageIcon(
              AssetImage('assets/icon/icon_fun.png'),
              size: 42,
            ),
            onPressed: () {
              showModalBottomSheet(context: context, builder: (context) {
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: double.infinity,
                      color: Colors.black54,
                    ),
                    Container(
                      height: ScreenUtil().setHeight(250),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: ImageIcon(
                              AssetImage('assets/icon/icon_clean.png'),
                              color: Color(0xFFED4014),
                              size: 42,
                            ),
                            onTap: () {
                              Navigator.pop(context);
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
                            },
                          ),
                          StreamBuilder(
                            stream: _settingDrawerPageBloc.userNameStream,
                            builder: (context, sanpshop) {
                              if (!sanpshop.hasData) {
                                return Container();
                              } else {
                                return InkWell(
                                  child: ImageIcon(
                                    AssetImage('assets/icon/icon_upload.png'),
                                    color: Color(0xFF19BE6B),
                                    size: 42,
                                  ),
                                  onTap: () {
                                    if (widget.type == 7) {
                                      if (_scanNumberEditingController.text == '') {
                                        Navigator.pop(context);
                                        showToast('请输入出库单号');
                                      } else {
                                        Navigator.pop(context);
                                        _bloc.uploadData(widget.type, sanpshop.data, _scanNumberEditingController, widget.isAdd);
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      _bloc.uploadData(widget.type, sanpshop.data, _scanNumberEditingController, widget.isAdd);
                                    }
                                  }
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
            );
          })
        ],
      ),
      body: Column(
        children: <Widget>[
          widget.type == 7 ?
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                autofocus: true,
                controller: _scanNumberEditingController,
                decoration: InputDecoration(
                  icon: ImageIcon(
                    AssetImage('assets/icon/icon_return_goods.png'),
                    color: Colors.blue,
                  )
                ),
              ),
            ) :
            Container(),
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
              child: StreamBuilder(
                stream: _bloc.updateLoadingStream,
                builder: (context, sanpshop) {
                  if (sanpshop.hasData && sanpshop.data) {
                    return CommonLoadingDialog();
                  } else {
                    return Column(
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
                                child: Text('汇总'),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setHeight(100),
                                child: StreamBuilder(
                                  stream: _bloc.sweepCodeVoStream,
                                  builder: (context, sanpshop) {
                                    if (!sanpshop.hasData) {
                                      return Text('明细（0）');
                                    } else {
                                      SweepCodeVo _sweepCodeVo = sanpshop.data;
                                      return Text('明细（${_sweepCodeVo.labelList.length} ）');
                                    }
                                  },
                                )
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
                    );
                  }
                },
              )
            ),
          )
        ],
      ),
      // floatingActionButton: StreamBuilder(
      //   stream: _settingDrawerPageBloc.userNameStream,
      //   builder: (context, sanpshop) {
      //     if (!sanpshop.hasData) {
      //       return Container();
      //     } else {
      //       return StreamBuilder(
      //         builder: (context, uploadLoading) {
      //           if (uploadLoading.hasData && uploadLoading.data) {
      //             return Container();
      //           } else {
      //             return SpeedDial(
      //               child: ImageIcon(
      //                 AssetImage('assets/icon/icon_fun.png'),
      //                 size: 42,
      //               ),
      //               children:[
      //                 SpeedDialChild(
      //                     child: ImageIcon(
      //                       AssetImage('assets/icon/icon_clean.png')
      //                     ),
      //                     backgroundColor: Color(0xFFED4014),
      //                     onTap: () {
      //                       showDialog(
      //                         context: context,
      //                         builder: (context) {
      //                           return CommonMessageDialog(
      //                             title: '清空确认',
      //                             widget: Text('是否确认清空'),
      //                             onCloseEvent: () {
      //                               Navigator.pop(context);
      //                             },
      //                             onPositivePressEvent: () {
      //                               _bloc.cleanSweepCodeRecord();
      //                               Navigator.pop(context);
      //                             },
      //                             negativeText: '取消',
      //                             positiveText: '确定',
      //                           );
      //                         }
      //                       );
      //                     }
      //                 ),
      //                 SpeedDialChild(
      //                   child: ImageIcon(
      //                     AssetImage('assets/icon/icon_upload.png')
      //                   ),
      //                   backgroundColor: Color(0xFF19BE6B),
      //                   onTap: () {
      //                     if (widget.type == 7) {
      //                       if (_scanNumberEditingController.text == '') {
      //                         showToast('请输入出库单号');
      //                       } else {
      //                         _bloc.uploadData(widget.type, sanpshop.data, _scanNumberEditingController, widget.isAdd);
      //                       }
      //                     } else {
      //                       _bloc.uploadData(widget.type, sanpshop.data, _scanNumberEditingController, widget.isAdd);
      //                     }
      //                   }
      //                 ),
      //               ]
      //             );
      //           }
      //         },
      //       );
      //     }
      //   },
      // ),
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
                  double sumNetWeight = 0;
                  int sumFactPerBagNumber = 0;
                  _sweepCodeVo.generalization[index].labeInfoVo.forEach((item) {
                    sumNetWeight += item.netWeight;
                    sumFactPerBagNumber += item.factPerBagNumber;
                  });
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]
                        )
                      )
                    ),
                    // child: ListTile(
                    //   title: Text('型号：${_sweepCodeVo.generalization[index].prodModel}'),
                    //   subtitle: Text('数量：${_sweepCodeVo.generalization[index].labeInfoVo.length}'),
                    //   trailing: Icon(Icons.chevron_right),
                    //   onTap: () {
                    //     Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePageDetail(_sweepCodeVo.generalization[index])));
                    //   },
                    // ),
                    child: InkWell(
                      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePageDetail(_sweepCodeVo.generalization[index]))),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(400),
                                    child: Text('型号: ${_sweepCodeVo.generalization[index].prodModel}', overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(204),
                                    child: Text('包数: ${_sweepCodeVo.generalization[index].labeInfoVo.length}', overflow: TextOverflow.ellipsis),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(400),
                                    child: Text('色号: ${_sweepCodeVo.generalization[index].prodColor}', overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(204),
                                    child: Text('纤度: ${_sweepCodeVo.generalization[index].prodFineness}', overflow: TextOverflow.ellipsis),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(400),
                                    child: Text('总净重: $sumNetWeight', overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(204),
                                    child: Text('总个数: $sumFactPerBagNumber', overflow: TextOverflow.ellipsis),
                                  )
                                ],
                              )
                            ],
                          ),
                          Icon(Icons.chevron_right, size: 42)
                        ],
                      ),
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
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_sweepCodeVo.labelList[index].labelNumber),
                          Row(
                            children: <Widget>[
                              Text('色号: ${_sweepCodeVo.labelList[index].prodColor}'),
                              SizedBox(width: ScreenUtil().setWidth(100)),
                              Text('纤度: ${_sweepCodeVo.labelList[index].prodFineness}'),
                            ],
                          ),
                          Text('${DateUtil.formatDateMs(_sweepCodeVo.labelList[index].scanTime)}')
                        ],
                      ),
                      // subtitle: Text('${DateUtil.formatDateMs(_sweepCodeVo.labelList[index].scanTime)}'),
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
