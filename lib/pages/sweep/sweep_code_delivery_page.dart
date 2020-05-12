import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sujian_select/select_group.dart';
import 'package:flutter_sujian_select/select_item.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_common.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_floatingActionButton.dart';
import 'package:flutter_uma/vo/delivery_list_vo.dart';

class SweepCodeDeliveryPage extends StatefulWidget {
  final String title;
  final String type;
  SweepCodeDeliveryPage(this.title, this.type);
  @override
  _SweepCodeDeliveryPageState createState() => _SweepCodeDeliveryPageState();
}

class _SweepCodeDeliveryPageState extends State<SweepCodeDeliveryPage> with TickerProviderStateMixin{
  TabController _controller;
  FocusNode _commentFocus = FocusNode();
  TextEditingController _textEditingController;
  SweepCodePageBloc _bloc;
  SettingDrawerPageBloc _settingDrawerPageBloc;
  int _customerSelectedIndex = 0;
  String _tempCustomer = '';
  String _tempDeliveryNum = '';
  TextEditingController _customerSelectedController = TextEditingController();
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
          _bloc.delivery(_tempDeliveryNum, _textEditingController.text, _textEditingController);
        }
      });      
    });
    _bloc.initSweepCodeVokey(widget.type);
    _bloc.getSweepCodeVo();
    _settingDrawerPageBloc.getUserName();
    _bloc.deliveryList();
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
            child: InkWell(
              child: TextField(
                enabled: false,
                controller: _customerSelectedController,
                decoration: InputDecoration(
                  labelText: '选择客户',
                  icon: ImageIcon(
                    AssetImage('assets/icon/icon_customer.png'),
                    color: Colors.blue,
                  )
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return _buildSelectedCustomer();
                  }
                ).then((val) {
                  _customerSelectedController.text = _tempCustomer;
                  FocusScope.of(context).requestFocus(_commentFocus);
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              focusNode: _commentFocus,
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

  /// 客户选择器
  Widget _buildSelectedCustomer() {
    return StreamBuilder(
      stream: _bloc.deliveryListVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return Container();
        } else {
          DeliveryListVo deliveryListVo = sanpshop.data;
          _tempCustomer = '${deliveryListVo.data[_customerSelectedIndex].customer}--${deliveryListVo.data[_customerSelectedIndex].deliveryNum}';
          _tempDeliveryNum = '${deliveryListVo.data[_customerSelectedIndex].deliveryNum}';
          return Container(
            alignment: Alignment.centerLeft,
            height: ScreenUtil().setHeight(450),
            child: SingleChildScrollView(
              child: SelectGroup<int>(
                index: _customerSelectedIndex,
                direction: SelectDirection.vertical,
                space: EdgeInsets.all(10),
                selectColor: Colors.blue,
                items: deliveryListVo.data.map((item) {
                  return SelectItem(label: '${item.customer}--${item.deliveryNum}', value: item.id);
                }).toList(),
                onSingleSelect: (int value){
                  int _tempIndex = 0;
                  deliveryListVo.data.forEach((item) {
                    if (value == item.id) {
                      _customerSelectedIndex = _tempIndex;
                      _tempCustomer = '${item.customer}--${item.deliveryNum}';
                      _tempDeliveryNum = '${item.deliveryNum}';
                    }
                    _tempIndex++;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }
      }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _customerSelectedController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}