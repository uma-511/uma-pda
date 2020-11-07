import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/pages/setting_drawer_page.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      menu: SettingDrawerPage(),
      screenSelectedBuilder: (position, controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('优码智能科技'),
            leading: IconButton(
              icon: ImageIcon(
                AssetImage('assets/icon/icon_setting.png')
              ),
              onPressed: () {
                controller.toggle();
              }
            ),
          ),
          body: Center(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: <Widget>[
                //_buildContainerButtom(context, 'assets/icon/icon_warehousing.png', '入仓', false, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('入仓', 1, true)))),
                //_buildContainerButtom(context, 'assets/icon/icon_warehousing.png', '托板入仓', false, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('托板入仓', 9, true)))),
                _buildContainerButtom(context, 'assets/icon/icon_out_of_warehouse.png', '出仓', false, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('出仓', 2, true)))),
                _buildContainerButtom(context, 'assets/icon/icon_returning_warehouse.png', '返仓', false, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('返仓', 4, true)))),
                // _buildContainerButtom(context, 'assets/icon/icon_return_goods.png', '退货', false, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('退货', 5, true)))),
                _buildContainerButtom(context, 'assets/icon/icon_return_goods.png', '出仓调整', false, () => _buildShowBottomSheet(context)),
                //_buildContainerButtom(context, 'assets/icon/icon_return_goods.png', '托板调整', false, () => _buildShowPallet(context))
              ],
            ),
          ),
          resizeToAvoidBottomPadding: false,
        );
      },
    );
  }

  _buildContainerButtom(BuildContext context, String path, String title, bool isThickening, itemFun()) {
    return InkWell(
      highlightColor: Colors.blue[50],
      onTap: itemFun == null ? null : () => itemFun(),
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(300),
        height: ScreenUtil().setWidth(300),
        decoration: BoxDecoration(
          border: Border.all(
            color: isThickening ? Colors.blue : Colors.blue[50]
          ),
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage(path),
              size: 58,
              color: Colors.blue,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(46)
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildShowBottomSheet(BuildContext context) {
    print('测试');
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: ScreenUtil().setHeight(300),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add),
                title: Text('添加'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('出仓调整·添加', 7, true)));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text('减少'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('出仓调整·减少', 7, false)));
                },
              )
            ],
          ),
        );
      });
  }
  _buildShowPallet(BuildContext context) {
    print('测试');
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: ScreenUtil().setHeight(300),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('添加'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('托板调整·添加', 10, true)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text('减少'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage('托板调整·减少', 10, false)));
                  },
                )
              ],
            ),
          );
        });
  }
}
