import 'dart:convert';
import 'package:cloudroomvideosdk/cr_defines.dart';

class CrSDKNotifier {
  final List<String> _evts = [];

  void addCrNotifierListener(List<NOTIFIER_EVENT> evts) {
    for (NOTIFIER_EVENT evt in evts) {
      _evts.add(evt.toString().replaceAll("NOTIFIER_EVENT.", ""));
    }
    CrNotifiy.instance.addNotifier(this);
  }

  void disposeCrNotifierListener() {
    CrNotifiy.instance.removeNotifier(this);
  }

  // 通知用户掉线
  void lineOff(int sdkErr) {}
  // 某用户进入了房间
  void userEnterMeeting(String userID) {}
  // 某用户离开了房间
  void userLeftMeeting(String userID) {}
  // 房间已被结束
  void meetingStopped() {}
  // 通知从房间里掉线了
  void meetingDropped(CR_MEETING_DROPPED_REASON reason) {}
  // 网络变化通知
  void netStateChanged(int level) {}
  // 通知用户修改昵称
  void notifyNickNameChanged(CrChangeNickName changeNickName) {}
  // 通知摄像头状态变化
  void videoStatusChanged(CrVideoStatusChanged vsc) {}
  // 通知用户的视频设备有变化
  void videoDevChanged(String userID) {}
  // 通知音频状态变化
  void audioStatusChanged(CrAudioStatusChanged asc) {}
  // 通知本地音频设备有变化
  void audioDevChanged() {}
  // 通知用户的说话声音强度更新
  void micEnergyUpdate(CrMicEnergy micEnergy) {}
  // 通知开启屏幕共享
  void notifyScreenShareStarted() {}
  // 通知停止屏幕共享
  void notifyScreenShareStopped() {}
  // 通知开启屏幕共享标注
  void notifyScreenMarkStarted() {}
  // 通知停止屏幕共享标注
  void notifyScreenMarkStopped() {}
  // 本地录制文件、本地直播信息通知
  void locMixerOutputInfo(CrMixerOutputInfo mixerOutputInfo) {}
  // 本地混图器状态变化通知
  void locMixerStateChanged(CrLocMixerState crLocMixerState) {}
  // 云端录制、云端直播状态变化通知
  void svrMixerStateChanged(CrSvrMixerState crSvrMixerState) {}
  // 云端录制、云端直播内容变化通知
  void svrMixerCfgChanged() {}
  // 云端录制文件、云端直播信息变化通知
  void svrMixerOutputInfo(CrMixerOutputInfo mixerOutputInfo) {}

  // 开启云端混图器后，房间内所有人都将收到cloudMixerStateChanged通知进入MIXER_STARTING（启动中状态）
  void cloudMixerStateChanged() {}

  // 通知影音文件打开
  void notifyMediaOpened(CrMediaFileInfo mediaFileInfo) {}
  // 通知影音开始播放
  void notifyMediaStart(CrMediaNotify mediaNotify) {}
  // 通知影音是否暂停播放
  void notifyMediaPause(CrMediaNotify mediaNotify) {}
  // 通知影音播放停止
  void notifyMediaStop(CrMediaNotify mediaNotify) {}
  // 聊天信息通知
  void notifyMeetingCustomMsg(CrChatMsg chatMsg) {}
}

class CrNotifiy {
  final List<CrSDKNotifier> _notifiers = [];

  CrNotifiy._internal();
  static final CrNotifiy instance = CrNotifiy._internal();
  factory CrNotifiy() => instance;

  addNotifier(CrSDKNotifier notifiy) {
    _notifiers.add(notifiy);
  }

  removeNotifier(CrSDKNotifier notifiy) {
    _notifiers.remove(notifiy);
  }

  notifiy(Map arguments) {
    String method = arguments["method"];
    for (var _notifier in _notifiers) {
      if (!_notifier._evts.contains(method)) continue;
      switch (method) {
        // 通知用户掉线
        case "lineOff":
          final int sdkErr = arguments["sdkErr"];
          _notifier.lineOff(sdkErr);
          break;
        // 某用户进入了房间
        case "userEnterMeeting":
          final String userID = arguments["userID"];
          _notifier.userEnterMeeting(userID);
          break;
        // 某用户离开了房间
        case "userLeftMeeting":
          final String userID = arguments["userID"];
          _notifier.userLeftMeeting(userID);
          break;
        // 通知房间已被结束
        case "meetingStopped":
          _notifier.meetingStopped();
          break;
        // 通知从房间里掉线了
        case "meetingDropped":
          final int reason = arguments["reason"];
          _notifier.meetingDropped(CR_MEETING_DROPPED_REASON.values[reason]);
          break;
        // 网络变化通知
        case "netStateChanged":
          final int level = arguments["level"];
          _notifier.netStateChanged(level);
          break;
        case "notifyNickNameChanged":
          final String userId = arguments["userID"];
          final String oldName = arguments["oldName"];
          final String newName = arguments["newName"];
          final CrChangeNickName changeNickName = CrChangeNickName(
              userId: userId, newName: newName, oldName: oldName);
          _notifier.notifyNickNameChanged(changeNickName);
          break;
        // 通知摄像头状态变化
        case "videoStatusChanged":
          final String userId = arguments["userID"];
          final int newStatusIdx = arguments["newStatus"];
          final int oldStatusIdx = arguments["oldStatus"];
          CrVideoStatusChanged vsc = CrVideoStatusChanged(
            userId: userId,
            newStatus: CR_VSTATUS.values[newStatusIdx],
            oldStatus: CR_VSTATUS.values[oldStatusIdx],
          );
          _notifier.videoStatusChanged(vsc);
          break;
        // 通知用户的视频设备有变化
        case "videoDevChanged":
          final String userID = arguments["userID"];
          _notifier.videoDevChanged(userID);
          break;
        // 通知音频状态变化
        case "audioStatusChanged":
          final String userId = arguments["userID"];
          final int newStatusIdx = arguments["newStatus"];
          final int oldStatusIdx = arguments["oldStatus"];
          CrAudioStatusChanged asc = CrAudioStatusChanged(
            userId: userId,
            newStatus: CR_ASTATUS.values[newStatusIdx],
            oldStatus: CR_ASTATUS.values[oldStatusIdx],
          );
          _notifier.audioStatusChanged(asc);
          break;
        // 通知本地音频设备有变化
        case "audioDevChanged":
          _notifier.audioDevChanged();
          break;
        case "micEnergyUpdate":
          final String userId = arguments["userID"];
          final int newLevel = arguments["newLevel"];
          final int oldLevel = arguments["oldLevel"];
          CrMicEnergy micEnergy = CrMicEnergy(
              userId: userId, newLevel: newLevel, oldLevel: oldLevel);
          _notifier.micEnergyUpdate(micEnergy);
          break;
        // 通知开启屏幕共享
        case "notifyScreenShareStarted":
          _notifier.notifyScreenShareStarted();
          break;
        // 通知停止屏幕共享
        case "notifyScreenShareStopped":
          _notifier.notifyScreenShareStopped();
          break;
        // 通知开启屏幕共享标注
        case "notifyScreenMarkStarted":
          _notifier.notifyScreenMarkStarted();
          break;
        // 通知停止屏幕共享标注
        case "notifyScreenMarkStopped":
          _notifier.notifyScreenMarkStopped();
          break;
        // 本地录制文件、本地直播信息通知
        case "locMixerOutputInfo":
          Map outputInfo = json.decode(arguments["outputInfo"]);
          CrMixerOutputInfo _locMixerOutputInfo = CrMixerOutputInfo();
          _locMixerOutputInfo.duration = outputInfo["duration"];
          _locMixerOutputInfo.fileSize = outputInfo["fileSize"];
          _locMixerOutputInfo.errCode = outputInfo["errCode"];
          _locMixerOutputInfo.state =
              CR_MIXER_OUTPUT_STATE.values[outputInfo["state"]];
          _notifier.locMixerOutputInfo(_locMixerOutputInfo);
          break;
        case "locMixerStateChanged":
          String mixerID = arguments["mixerID"];
          CR_MIXER_OUTPUT_STATE state =
              CR_MIXER_OUTPUT_STATE.values[arguments["state"]];
          CrLocMixerState crLocMixerState =
              CrLocMixerState(mixerID: mixerID, state: state);
          _notifier.locMixerStateChanged(crLocMixerState);
          break;
        // 云端录制、云端直播状态变化通知
        case "svrMixerStateChanged":
          String operatorID = arguments["operatorID"];
          CR_MIXER_OUTPUT_STATE state =
              CR_MIXER_OUTPUT_STATE.values[arguments["state"]];
          int sdkErr = arguments["err"];
          CrSvrMixerState crSvrMixerState = CrSvrMixerState(
              operatorID: operatorID, state: state, sdkErr: sdkErr);
          _notifier.svrMixerStateChanged(crSvrMixerState);
          break;
        // 云端录制、云端直播内容变化通知
        case "svrMixerCfgChanged":
          _notifier.svrMixerCfgChanged();
          break;
        // 云端录制文件、云端直播信息变化通知
        case "svrMixerOutputInfo":
          Map outputInfo = json.decode(arguments["outputInfo"]);
          CrMixerOutputInfo _svrMixerOutputInfo = CrMixerOutputInfo();
          _svrMixerOutputInfo.duration = outputInfo["duration"];
          _svrMixerOutputInfo.fileSize = outputInfo["fileSize"];
          _svrMixerOutputInfo.errCode = outputInfo["errCode"];
          _svrMixerOutputInfo.state =
              CR_MIXER_OUTPUT_STATE.values[outputInfo["state"]];
          _notifier.svrMixerOutputInfo(_svrMixerOutputInfo);
          break;
        // 通知影音文件打开
        case "notifyMediaOpened":
          int totalTime = arguments["totalTime"];
          int width = arguments["width"];
          int height = arguments["height"];
          _notifier.notifyMediaOpened(CrMediaFileInfo(
              totalTime: totalTime, width: width, height: height));
          break;
        // 通知影音开始播放
        case "notifyMediaStart":
          String userID = arguments["userID"];
          _notifier.notifyMediaStart(CrMediaNotify(userID: userID));
          break;
        // 通知影音是否暂停播放
        case "notifyMediaPause":
          String userID = arguments["userID"];
          bool pause = arguments["pause"];
          _notifier
              .notifyMediaPause(CrMediaNotify(userID: userID, pause: pause));
          break;
        // 通知影音播放停止
        case "notifyMediaStop":
          String userID = arguments["userID"];
          int reason = arguments["reason"];
          _notifier.notifyMediaStop(CrMediaNotify(
              userID: userID, reason: CR_MEDIA_STOP_REASON.values[reason]));
          break;
        // 聊天信息通知
        case "notifyMeetingCustomMsg":
          String fromUserID = arguments["fromUserID"];
          String text = arguments["text"];
          _notifier.notifyMeetingCustomMsg(CrChatMsg(fromUserID, text));
          break;
      }
    }
  }
}
