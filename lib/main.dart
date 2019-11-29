import 'package:flutter/material.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/init_page_bloc.dart';
import 'package:flutter_uma/blocs/login_page_bloc.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_detail_bloc.dart';
import 'package:flutter_uma/blocs/system_setting_page_bloc.dart';
import 'package:flutter_uma/pages/init_page.dart';
import 'package:oktoast/oktoast.dart';

void main() => runApp(
  BlocProvider(
    bloc: InitPageBloc(),
    child: BlocProvider(
      bloc: SystemSettingPageBloc(),
      child: BlocProvider(
        bloc: LoginPageBloc(),
        child: BlocProvider(
          bloc: SweepCodePageBloc(),
          child: BlocProvider(
            bloc: SweepCodePageDetailBloc(),
            child: BlocProvider(
              bloc: SettingDrawerPageBloc(), 
              child: MyApp()
            )
          )
        ),
      )
    ),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      backgroundColor: Color(0xFF5CADFF),
      dismissOtherOnShow: true,
      position: ToastPosition(
        align: Alignment.bottomCenter
      ),
      textPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      radius: 20.0,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UMa',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InitPage(),
      ),
    );
  }
}