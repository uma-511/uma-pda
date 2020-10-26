import 'package:flutter/material.dart';
import 'package:flutter_uma/blocs/bloc_provider.dart';
import 'package:flutter_uma/blocs/init_page_bloc.dart';
import 'package:flutter_uma/blocs/login_page_bloc.dart';
import 'package:flutter_uma/blocs/setting_drawer_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/blocs/sweep_code_page_detail_bloc.dart';
import 'package:flutter_uma/blocs/system_setting_page_bloc.dart';
import 'package:flutter_uma/blocs/system_setting_page_bloc.dart';
import 'package:flutter_uma/common/common_utils.dart';
import 'package:flutter_uma/pages/init_page.dart';
import 'package:flutter_uma/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
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

class MyApp extends StatefulWidget  {
  @override
  _MyAppState createState() => new _MyAppState();
  /*@override
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
  }*/
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed:// 应用程序可见，前台
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
        break;
      case AppLifecycleState.paused:// 应用程序不可见，后台

        cleanToken();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
