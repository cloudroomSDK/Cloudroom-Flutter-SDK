import '/api/cr_api.dart';
import '/implements/cr_impl.dart';
import '/implements/cr_impl_room.dart';
import '/cr_defines.dart';

extension CrRoomApi on CrSDK {
  // 进入房间
  Future<int> enterMeeting(int meetID) async {
    return await CrImpl.instance.enterMeeting(meetID);
  }

  // 创建房间 -> 之后调用enterMeeting
  Future<CrMeetInfo> createMeeting() async {
    final Map data = await CrImpl.instance.createMeeting();
    int sdkErr = data["sdkErr"] ?? 0;
    int id = data["id"] ?? 0;
    CrMeetInfo meetInfo = CrMeetInfo(confId: id, sdkErr: sdkErr);
    return meetInfo;
  }

  // 销毁视频房间
  Future<int> destroyMeeting(int meetID) async {
    final Map data = await CrImpl.instance.destroyMeeting(meetID);
    final int sdkErr = data["sdkErr"];
    return sdkErr;
  }

  // 离开房间
  Future<void> exitMeeting() async {
    return await CrImpl.instance.exitMeeting();
  }
}
