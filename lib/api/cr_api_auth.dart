import 'dart:convert';

import '/api/cr_api.dart';
import '/implements/cr_impl.dart';
import '/implements/cr_impl_auth.dart';
import '/cr_defines.dart';

extension CrAuthApi on CrSDK {
  // 登录
  Future<CrLoginResult> login(CrLoginDat loginDat) async {
    final String loginDatJson = json.encode(loginDat.toJson());
    // String dataStr = await CrImpl.instance.login(loginDatJson);
    final Map data = await CrImpl.instance.login(loginDatJson);
    final String userID = data["userID"] ?? "";
    final int sdkErr = data["sdkErr"] ?? 0;
    return CrLoginResult(userID: userID, sdkErr: sdkErr);
  }

  // 登出
  Future<void> logout() async {
    return await CrImpl.instance.logout();
  }
}
