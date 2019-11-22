import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/init_page_bloc.dart';
import 'package:flutter_uma/common/common_show_loading.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    final InitPageBloc _bloc = BlocProvider.of<InitPageBloc>(context);
    _bloc.initPage(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('优码智能科技'),
      ),
      body: CommonShowLoading(),
    );
  }
}