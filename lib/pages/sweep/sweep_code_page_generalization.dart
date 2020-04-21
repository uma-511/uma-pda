import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_show_loading.dart';
import 'package:flutter_uma/vo/cache_vo.dart';

class SweepCodePageGeneralization extends StatelessWidget {
  final SweepCodePageBloc _bloc;
  SweepCodePageGeneralization(
    this._bloc
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.cacheVoStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return CommonShowLoading();
        } else {
          List<CacheVo> _cacheVos = sanpshop.data;
          if (_cacheVos.length == 0) {
            return ImageIcon(AssetImage('assets/icon/icon_no_time.png'), color: Colors.grey[400]);
          } else {
            return ListView.builder(
              itemCount: _cacheVos.length,
              itemBuilder: (context, index) {
                int quantity = 0;
                _cacheVos[index].recordList.forEach((item) {
                  quantity += item.quantity;
                });
                return Container(
                  height: ScreenUtil().setHeight(120),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]
                      )
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            child: Text('名称：${_cacheVos[index].recordList[0].name}'),
                            width: ScreenUtil().setWidth(250),
                          ),
                          SizedBox(
                            child: Text('颜色：${_cacheVos[index].recordList[0].color}'),
                            width: ScreenUtil().setWidth(250),
                          ),
                          SizedBox(
                            child: Text('编号：${_cacheVos[index].recordList[0].number}'),
                            width: ScreenUtil().setWidth(250),
                          )
                        ]
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            child: Text('宽度：${_cacheVos[index].recordList[0].width}'),
                            width: ScreenUtil().setWidth(250),
                          ),
                          SizedBox(
                            child: Text('包数：${_cacheVos[index].recordList.length}'),
                            width: ScreenUtil().setWidth(250),
                          ),
                          SizedBox(
                            child: Text('卷数：$quantity'),
                            width: ScreenUtil().setWidth(250),
                          )
                        ]
                      )
                    ]
                  ),
                );
              },
            );
          }
        }
      }
    );
  }
}