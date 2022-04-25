import 'package:cloudroomvideosdk/implements/cr_impl.dart';

extension CrRoomImpl on CrImpl {
  static final _channel = CrImpl.channel;

  // 创建视频房间
  Future<Map> createMeeting() async {
    String cookie = DateTime.now().millisecondsSinceEpoch.toString();
    return await _channel.invokeMethod("createMeeting", {"cookie": cookie});
  }

  // 销毁视频房间
  Future<Map> destroyMeeting(int meetID) async {
    String cookie = DateTime.now().millisecondsSinceEpoch.toString();
    return await _channel
        .invokeMethod("destroyMeeting", {"meetID": meetID, "cookie": cookie});
  }

  // 进入房间、
  Future<int> enterMeeting(int meetID) async {
    return await _channel.invokeMethod("enterMeeting", {"meetID": meetID});
  }

  // 离开房间
  Future<void> exitMeeting() async {
    return await _channel.invokeMethod("exitMeeting");
  }
}
