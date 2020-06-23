import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_generalization.dart';
import 'package:flutter_uma/pages/sweep/sweep_code_page_summary.dart';
import 'package:flutter_uma/vo/cache_vo.dart';

class SweepCodePageCommon extends StatelessWidget {
  final TabController _controller;
  final SweepCodePageBloc _bloc;

  SweepCodePageCommon(
    this._controller,
    this._bloc
  );
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  StreamBuilder(
                    stream: _bloc.cacheVoStream,
                    builder: (context, sanpshop) {
                      if (sanpshop.hasData) {
                        List<CacheVo> cacheVo = sanpshop.data;
                        int sumCount = 0;
                        cacheVo.forEach((item) {
                          sumCount += item.recordList.length;
                        });
                        return Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(100),
                          child: Text('汇总($sumCount)'),
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(100),
                          child: Text('汇总'),
                        );
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: ScreenUtil().setHeight(100),
                    child: Text('概括'),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  SweepCodePageSummary(_bloc),
                  SweepCodePageGeneralization(_bloc),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}