import "dart:async";
import "package:flutter/services.dart";
import 'cr_notifiy.dart';

class CrImpl {
  // Singleton
  CrImpl._internal();
  static final CrImpl instance = CrImpl._internal();
  factory CrImpl() => instance;

  static get channel => _channel;

  static const MethodChannel _channel = MethodChannel("cr_flutter_sdk");
  static const EventChannel _event =
      EventChannel("cr_flutter_sdk_event_handler");

  /// Used to receive the native event stream
  static StreamSubscription<dynamic>? _streamSubscription;

  static void _registerMethodHandler() {
    _streamSubscription =
        _event.receiveBroadcastStream().listen(_eventListener);
  }

  static void _unregisterEventHandler() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  static void _eventListener(arguments) async {
    if (arguments != null) {
      CrNotifiy.instance.notifiy(arguments);
    }
  }

  // 写日志
  Future<void> log(String log, int level) async {
    return await _channel.invokeMethod("CRLog", {"level": level, "log": log});
  }

  // 获取版本号
  Future<String> cloudroomVideoSDKVer() async {
    return await _channel.invokeMethod("GetCloudroomVideoSDKVer");
  }

  // 初始化
  Future<int> init(String sdkInitDat) async {
    _registerMethodHandler();
    return await _channel.invokeMethod("init", {"sdkInitDat": sdkInitDat});
  }

  // 反初始化
  Future<void> uninit() async {
    _unregisterEventHandler();
    return await _channel.invokeMethod("uninit");
  }

  // 获取服务器地址
  Future<String> getServerAddr() async {
    return await _channel.invokeMethod("getServerAddr");
  }

  // 设置服务器地址
  Future<void> setServerAddr(String serverAddr) async {
    return await _channel
        .invokeMethod("setServerAddr", {"serverAddr": serverAddr});
  }
}
