import 'package:flutter/material.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/sweep_code_page_detail_bloc.dart';
import 'package:flutter_uma/common/common_show_loading.dart';
import 'package:flutter_uma/vo/config_vo.dart';
import 'package:flutter_uma/vo/sweep_code_vo.dart';

class SweepCodePageDetail extends StatefulWidget {
  final Generalization generalization;
  SweepCodePageDetail(
    this.generalization
  );
  @override
  _SweepCodePageDetailState createState() => _SweepCodePageDetailState();
}

class _SweepCodePageDetailState extends State<SweepCodePageDetail> {
  SweepCodePageDetailBloc _bloc;
  List<Widget> _widget = [];
  @override
  void initState() { 
    _bloc = BlocProvider.of<SweepCodePageDetailBloc>(context);
    _bloc.getConfigs().then((val) {
      _widget = _config(val);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('归类详情'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: _bloc.configDataStream,
          builder: (context, sanpshop) {
            if (!sanpshop.hasData) {
              return CommonShowLoading();
            } else {
              return ListView(
                children: _widget,
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _config(List<ConfigData> configDatas) {
    List<Widget> _widget = [];
    _widget.add(_buildContainer(Text('产品型号：${widget.generalization.prodModel}')));
    _widget.add(_buildContainer(Text('产品名称：${widget.generalization.prodName}')));
    _widget.add(_buildContainer(Text('产品色号：${widget.generalization.prodColor}')));
    _widget.add(_buildContainer(Text('产品纤度：${widget.generalization.prodFineness}')));
    configDatas.forEach((item) {
      dynamic value = 0;
      String name = item.name;
      widget.generalization.labeInfoVo.forEach((labeInfoVoItem) {
        Map<String, dynamic> map = labeInfoVoItem.toJson();
        value += map['${item.value}'];
      });
      _widget.add(_buildContainer(Text('$name：$value')));
    });
    _widget.add(_buildListView());
    return _widget;
  }

  _buildContainer(Widget text) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey
          )
        )
      ),
      child: ListTile(
        title: text,
      ),
    );
  }

  _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.generalization.labeInfoVo.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey
              )
            )
          ),
          child: ListTile(
            title: Text('标签号：${widget.generalization.labeInfoVo[index].labelNumber}'),
            subtitle: Text('数量：${widget.generalization.labeInfoVo[index].factPerBagNumber}'),
            trailing: Text('重量：${widget.generalization.labeInfoVo[index].netWeight}'),
          ),
        );
      },
    );
  }
}