import 'dart:async';
import 'dart:convert';

import '/implements/cr_impl.dart';
import '/cr_defines.dart';

class CrSDK {
  CrSDK._internal();
  static final CrSDK instance = CrSDK._internal();
  factory CrSDK() => instance;

  // 写日志
  Future<void> log(String log,
      [CR_SDK_LOG_LEVEL level = CR_SDK_LOG_LEVEL.SDK_LOG_LEVEL_DEBUG]) async {
    return CrImpl.instance.log(log, level.index);
  }

  // 获取版本号
  Future<String> getVersion() async {
    return await CrImpl.instance.cloudroomVideoSDKVer();
  }

  // 初始化
  Future<int> init(CrSdkInitDat config) async {
    String sdkInitDat = json.encode(config.toJson());
    return await CrImpl.instance.init(sdkInitDat);
  }

  // 反初始化
  Future<void> uninit() async {
    return CrImpl.instance.uninit();
  }

  // 获取服务器地址
  Future<String> getServerAddr() async {
    return await CrImpl.instance.getServerAddr();
  }

  // 设置服务器地址
  Future<void> setServerAddr(String serverAddr) async {
    return await CrImpl.instance.setServerAddr(serverAddr);
  }
}
