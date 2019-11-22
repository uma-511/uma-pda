import 'package:flutter_uma/common/common_preference_keys.dart';
import 'common_preference_utils.dart';

/// 缓存IP，标签长度
  setIPAndLabelLength(String ip, int labelLength) {
    CommonPreferenceUtils().saveString(key: CommonPerferenceKeys.ipKey, value: ip);
    CommonPreferenceUtils().saveInteger(key: CommonPerferenceKeys.labelKey, value: labelLength);
  }

  /// 获取IP
  Future<String> getIP() {
    return CommonPreferenceUtils().getString(key: CommonPerferenceKeys.ipKey);
  }

  /// 获取标签长度
  Future<int> getLabelLength() {
    return CommonPreferenceUtils().getInteger(key: CommonPerferenceKeys.labelKey);
  }

  /// 缓存Token
  saveToken(String token) {
    CommonPreferenceUtils().saveString(key: CommonPerferenceKeys.token, value: token);
  }

  /// 获取Token
  Future<String> getToken() {
    return CommonPreferenceUtils().getString(key: CommonPerferenceKeys.token);
  }