import 'package:flutter_uma/common/common_preference_keys.dart';
import 'package:flutter_uma/service/http_util.dart';
import 'package:flutter_uma/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_uma/vo/handsetlogin_vo.dart';
import 'common_preference_utils.dart';

/// 缓存IP，标签长度
  setIPAndLabelLength(String ip, int labelLength, int listSize) {
    CommonPreferenceUtils().saveString(key: CommonPerferenceKeys.ipKey, value: ip);
    CommonPreferenceUtils().saveInteger(key: CommonPerferenceKeys.labelKey, value: labelLength);
    CommonPreferenceUtils().saveInteger(key: CommonPerferenceKeys.listKey, value: listSize);
  }

  /// 获取IP
  Future<String> getIP() {
    return CommonPreferenceUtils().getString(key: CommonPerferenceKeys.ipKey);
  }

  /// 获取标签长度
  Future<int> getLabelLength() {
    return CommonPreferenceUtils().getInteger(key: CommonPerferenceKeys.labelKey);
  }

  /// 获取标签长度
  Future<int> getListSize() {
    return CommonPreferenceUtils().getInteger(key: CommonPerferenceKeys.listKey);
  }

  /// 缓存Token
  saveToken(String token) {
    CommonPreferenceUtils().saveString(key: CommonPerferenceKeys.token, value: token);
  }

  /// 获取Token
  Future<String> getToken() {
    return CommonPreferenceUtils().getString(key: CommonPerferenceKeys.token);
  }

  // 清空Token
  cleanToken()  {
    CommonPreferenceUtils().removeByKey(key: CommonPerferenceKeys.token);
  }

  cleanTokens(BuildContext context) async {
    String userName = await CommonPreferenceUtils().getString(key: CommonPerferenceKeys.userNameKey);
    HttpUtil().post('delectlogin',data: userName).then((val) {
      if (val != null) {
        HandsetloginVo handsetloginVo = HandsetloginVo.fromJson(val);

        if (handsetloginVo.code == '200') {
          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginPage()), (route) => route == null);
          CommonPreferenceUtils().removeByKey(key: CommonPerferenceKeys.token);
          return;
        }
      } else {
        showToast('网络错误无法退出登录');
      }
    });
  }
