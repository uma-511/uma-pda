import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uma/blocs/sweep_code_page_bloc.dart';
import 'package:flutter_uma/common/common_show_loading.dart';
import 'package:flutter_uma/vo/cache_vo.dart';
import 'package:flutter_uma/vo/post_label_record_vo.dart';

class SweepCodePageSummary extends StatelessWidget {
  final SweepCodePageBloc _bloc;
  SweepCodePageSummary(
    this._bloc
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.postLabelRecordDataStream,
      builder: (context, sanpshop) {
        if (!sanpshop.hasData) {
          return CommonShowLoading();
        } else {
          // List<CacheVo> _cacheVos = sanpshop.data;
          List<PostLabelRecordData> _postLabelRecordData = sanpshop.data;
          if (_postLabelRecordData.length == 0) {
            return ImageIcon(AssetImage('assets/icon/icon_no_time.png'), color: Colors.grey[400]);
          } else {
            // return Container(
            //   child: ListView.builder(
            //     itemCount: _cacheVos.length,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         decoration: BoxDecoration(
            //           border: Border(
            //             bottom: BorderSide(
            //               color: Colors.grey[200]
            //             )
            //           )
            //         ),
            //         child: ListView(
            //           physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           children: _cacheVos[index].recordList.map((item) {
            //             return Container(
            //               height: ScreenUtil().setHeight(120),
            //               decoration: BoxDecoration(
            //                 border: Border(
            //                   bottom: BorderSide(
            //                     color: Colors.grey[200]
            //                   )
            //                 )
            //               ),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: <Widget>[
            //                   Row(
            //                     children: <Widget>[
            //                       SizedBox(
            //                         child: Text(
            //                           '条码：${item.labelNum}',
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                         width: ScreenUtil().setWidth(500),
            //                       ),
            //                       SizedBox(
            //                         child: Text(
            //                           '${item.number}',
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                         width: ScreenUtil().setWidth(250),
            //                       )
            //                     ]
            //                   ),
            //                   Row(
            //                     children: <Widget>[
            //                       SizedBox(
            //                         child: Text(
            //                           '${item.name}',
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                         width: ScreenUtil().setWidth(250),
            //                       ),
            //                       SizedBox(
            //                         child: Text(
            //                           '${item.color}',
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                         width: ScreenUtil().setWidth(250),
            //                       ),
            //                       SizedBox(
            //                         child: Text(
            //                           '${item.width}',
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                         width: ScreenUtil().setWidth(250),
            //                       )
            //                     ]
            //                   )
            //                 ]
            //               ),
            //             );
            //           }).toList()
            //         )
            //       );
            //     },
            //   ),
            // );
            return Container(
              child: ListView.builder(
                itemCount: _postLabelRecordData.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]
                        )
                      )
                    ),
                    child: Container(
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
                                  child: Text(
                                    '条码：${_postLabelRecordData[index].labelNum}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  width: ScreenUtil().setWidth(500),
                                ),
                                SizedBox(
                                  child: Text(
                                    '${_postLabelRecordData[index].number}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  width: ScreenUtil().setWidth(250),
                                )
                              ]
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  child: Text(
                                    '${_postLabelRecordData[index].name}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  width: ScreenUtil().setWidth(250),
                                ),
                                SizedBox(
                                  child: Text(
                                    '${_postLabelRecordData[index].color}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  width: ScreenUtil().setWidth(250),
                                ),
                                SizedBox(
                                  child: Text(
                                    '${_postLabelRecordData[index].width}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  width: ScreenUtil().setWidth(250),
                                )
                              ]
                            )
                          ]
                        ),
                      )
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}