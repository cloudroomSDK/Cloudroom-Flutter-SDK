import 'package:cloudroomvideosdk/implements/cr_impl.dart';

extension CrChatImpl on CrImpl {
  static final _channel = CrImpl.channel;

  // 发送消息
  Future<Map> sendMeetingCustomMsg(String text) async {
    String cookie = DateTime.now().millisecondsSinceEpoch.toString();
    return await _channel
        .invokeMethod("sendMeetingCustomMsg", {"text": text, "cookie": cookie});
  }
}
