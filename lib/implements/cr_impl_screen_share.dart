import 'package:cloudroomvideosdk/implements/cr_impl.dart';

extension CrScreenShareImpl on CrImpl {
  static final _channel = CrImpl.channel;

  // 开始屏幕共享
  Future<void> startScreenShareView(int viewID, String usrVideoId) async {
    return await _channel.invokeMethod(
        "startScreenShareView", {"viewID": viewID, "usrVideoId": usrVideoId});
  }

  // 销毁屏幕共享视图
  Future<bool> destroyScreenShareView(int viewID) async {
    return await _channel
        .invokeMethod("destroyScreenShareView", {"viewID": viewID});
  }

  // 获取屏幕共享是否已开启
  Future<bool> isScreenShareStarted() async {
    return await _channel.invokeMethod("isScreenShareStarted");
  }

  // 获取屏幕共享配置
  Future<String> getScreenShareCfg() async {
    return await _channel.invokeMethod("getScreenShareCfg");
  }

  // 设置屏幕共享配置
  Future<void> setScreenShareCfg(String screenShareCfg) async {
    return await _channel
        .invokeMethod("setScreenShareCfg", {"screenShareCfg": screenShareCfg});
  }

  // 开启屏幕共享
  Future<int> startScreenShare() async {
    return await _channel.invokeMethod("startScreenShare");
  }

  // 停止屏幕共享
  Future<int> stopScreenShare() async {
    return await _channel.invokeMethod("stopScreenShare");
  }
}
