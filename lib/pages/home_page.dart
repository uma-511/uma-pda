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
                _buildContainerButtom(context, 'assets/icon/icon_warehousing.png', '入仓', false, 1),
                _buildContainerButtom(context, 'assets/icon/icon_out_of_warehouse.png', '出仓', true, 2),
                _buildContainerButtom(context, 'assets/icon/icon_returning_warehouse.png', '返仓', true, 4),
                _buildContainerButtom(context, 'assets/icon/icon_return_goods.png', '退货', false, 5)
              ],
            ),
          ),
          resizeToAvoidBottomPadding: false,
        );
      },
    );
  }

  _buildContainerButtom(BuildContext context, String path, String title, bool isThickening, int type) {
    return InkWell(
      highlightColor: Colors.blue[50],
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => SweepCodePage(title, type)));
      },
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
}
