import 'package:cloudroomvideosdk/implements/cr_impl.dart';

extension CrAuthImpl on CrImpl {
  static final _channel = CrImpl.channel;

  // 登录
  Future<Map> login(String loginDat) async {
    String cookie = DateTime.now().millisecondsSinceEpoch.toString();
    return await _channel
        .invokeMethod("login", {"loginDat": loginDat, "cookie": cookie});
  }

  // 登出
  Future<void> logout() async {
    return await _channel.invokeMethod("logout");
  }
}
