import 'dart:convert';

import '/api/cr_api.dart';
import '/implements/cr_impl.dart';
import '/implements/cr_impl_member.dart';
import '/cr_defines.dart';

extension CrMemberApi on CrSDK {
  // 获取自己的UserID
  Future<String> getMyUserID() async {
    return await CrImpl.instance.getMyUserID();
  }

  // 获取房间所有成员的列表
  Future<List<CrMemberInfo>> getAllMembers() async {
    final String result = await CrImpl.instance.getAllMembers();
    List items = json.decode(result);
    List<String> _vStatus = [
      "VUNKNOWN",
      "VNULL",
      "VCLOSE",
      "VOPEN",
      "VOPENING"
    ];
    List<String> _aStatus = [
      "AUNKNOWN",
      "ANULL",
      "ACLOSE",
      "AOPEN",
      "AOPENING",
      "AACCEPTING"
    ];
    List<CrMemberInfo> members = items.map((data) {
      String _videoStatus = data["videoStatus"];
      String _audioStatus = data["audioStatus"];
      int _vi = _vStatus.indexOf(_videoStatus);
      int _ai = _aStatus.indexOf(_audioStatus);
      CR_VSTATUS videoStatus = CR_VSTATUS.values[_vi];
      CR_ASTATUS audioStatus = CR_ASTATUS.values[_ai];
      return CrMemberInfo(
          nickName: data["nickName"],
          userId: data["userId"],
          videoStatus: videoStatus,
          audioStatus: audioStatus);
    }).toList();
    return members;
  }

  // 获取某个用户的信息
  Future<String> getMemberInfo(String userID) async {
    return await CrImpl.instance.getMemberInfo(userID);
  }

  // 获取某个用户的昵称
  Future<String> getNickName(String userID) async {
    return await CrImpl.instance.getNickName(userID);
  }

  // 设置某个用户的昵称
  Future<CrChangeNickName> setNickName(String userID, String nickName) async {
    final Map data = await CrImpl.instance.setNickName(userID, nickName);
    final String userId = data["userID"];
    final String newName = data["newName"];
    final int sdkErr = data["sdkErr"];
    final CrChangeNickName changeNickName =
        CrChangeNickName(userId: userId, newName: newName, sdkErr: sdkErr);
    return changeNickName;
  }

  // 判断某个用户是否在房间中
  Future<bool> isUserInMeeting(String userID) async {
    return await CrImpl.instance.isUserInMeeting(userID);
  }
}
