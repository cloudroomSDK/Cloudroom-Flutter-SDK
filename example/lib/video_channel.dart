import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'application/application.dart';
import 'package:cloudroomvideosdk/cloudroomvideosdk.dart';
import 'component/video_views.dart';
import 'application/common_func.dart';

class VideoChannel extends StatefulWidget {
  const VideoChannel({Key? key}) : super(key: key);

  @override
  _VideoChannelState createState() => _VideoChannelState();
}

GlobalKey<VideoViewsState> videoViewsKey = GlobalKey();

class _VideoChannelState extends State<VideoChannel>
    with CrSDKNotifier, CommonFunc {
  String userId = GlobalConfig.instance.userID;
  int? confId = GlobalConfig.instance.confID;
  String nickName = GlobalConfig.instance.nickName;
  bool _isOpenCamera = false; // 是否开启摄像头
  bool _isOpenMic = false; // 是否开启麦克风
  bool _isSpeakerOut = false; // 是否外放（扬声器）
  VideoViews? _videoViews;

  // List<CrCameraInfo> _camerasInfo = [];
  bool get _isFrontCamera =>
      videoViewsKey.currentState?.defaultCameraInfo?.cameraPosition ==
      CR_CAMERA_POSITION.FRONT; // 是否前置摄像头

  @override
  void initState() {
    addCrNotifierListener([
      NOTIFIER_EVENT.lineOff,
      NOTIFIER_EVENT.meetingDropped,
      NOTIFIER_EVENT.videoStatusChanged,
      NOTIFIER_EVENT.audioStatusChanged,
    ]);
    initPage(confId);
    super.initState();
  }

  @override
  void dispose() {
    disposeCrNotifierListener();
    CrSDK.instance.exitMeeting();
    CrSDK.instance.logout();
    super.dispose();
  }

  @override
  enterMeetingSuccess() {
    switchMicPhone(true);
    setSpeakerOut(true);
    switchCamera(true);
    _videoViews = VideoViews(key: videoViewsKey);
  }

  @override
  lineOff(int sdkErr) {
    toHomePage();
  }

  @override
  meetingDropped(CR_MEETING_DROPPED_REASON reason) {
    commonMeetingDropped(reason);
  }

  @override
  toHomePage() {
    Duration transitionDuration = const Duration(milliseconds: 0);
    Application.router.navigateTo(context, "/",
        replace: true,
        transitionDuration: transitionDuration,
        clearStack: true);
  }

  // 监听视像头状态
  @override
  videoStatusChanged(CrVideoStatusChanged vsc) {
    if (vsc.userId == userId) {
      setState(() => _isOpenCamera = vsc.newStatus == CR_VSTATUS.VOPEN);
    }
  }

  // 摄像头开关
  void switchCamera(bool isOpenCamera) {
    isOpenCamera
        ? CrSDK.instance.openVideo(userId)
        : CrSDK.instance.closeVideo(userId);
  }

  // // 获取用户所有的摄像头信息
  // Future<List<CrCameraInfo>> getAllVideoInfo(String userId) {
  //   return CrSDK.instance.getAllVideoInfo(userId).then((camerasInfo) {
  //     _camerasInfo = camerasInfo;
  //     return camerasInfo;
  //   });
  // }

  // // 获取用户默认摄像头
  // Future<int> getDefaultVideo(String userId) {
  //   return getAllVideoInfo(userId).then((List<CrCameraInfo> camerasInfo) {
  //     return CrSDK.instance.getDefaultVideo(userId).then((int videoID) {
  //       for (CrCameraInfo cInfo in camerasInfo) {
  //         if (cInfo.videoID == videoID) {
  //           _defaultCameraInfo = cInfo;
  //         }
  //       }
  //       return videoID;
  //     });
  //   });
  // }

  // // 切换前后摄像头
  // void setDefaultVideo(CR_CAMERA_POSITION cameraPosition) {
  //   // 从摄像头信息中找到对应位置的摄像头
  //   for (int i = 0; i < _camerasInfo.length; i++) {
  //     CrCameraInfo item = _camerasInfo[i];
  //     if (item.cameraPosition == cameraPosition) {
  //       setState(() {
  //         _defaultCameraInfo = item;
  //       });
  //       CrSDK.instance.setDefaultVideo(userId, item.videoID);
  //       break;
  //     }
  //   }
  // }

  // 麦克风开关
  switchMicPhone(bool isOpenMic) {
    isOpenMic
        ? CrSDK.instance.openMic(userId)
        : CrSDK.instance.closeMic(userId);
  }

  // 获取外放状态
  getSpeakerOut() {
    CrSDK.instance.getSpeakerOut().then(
        (bool isSpeakerOut) => setState(() => _isSpeakerOut = isSpeakerOut));
  }

  // 设置外放状态
  void setSpeakerOut(bool isSpeakerOut) {
    setState(() => _isSpeakerOut = isSpeakerOut);
    Utils.debounce("setSpeakerOut", () {
      CrSDK.instance.setSpeakerOut(isSpeakerOut).catchError((value) {
        setState(() => _isSpeakerOut = !isSpeakerOut);
      });
    });
  }

  @override
  audioStatusChanged(CrAudioStatusChanged asc) {
    if (asc.userId == userId) {
      setState(() => _isOpenMic = asc.newStatus == CR_ASTATUS.AOPEN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("房间号：$confId"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: toHomePage,
          ),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xff1D232F),
            child: Stack(
              children: [
                SizedBox(child: _videoViews),
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setHeight(85),
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(6)),
                      color: Colors.black54,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: ScreenUtil().setWidth(155),
                                  height: ScreenUtil().setHeight(30),
                                  child: ElevatedButton(
                                      child: Text(
                                          "${_isFrontCamera ? '后置' : '前置'}摄像头",
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(14))),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                // side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                      ),
                                      onPressed: () {
                                        CR_CAMERA_POSITION cameraPosition =
                                            _isFrontCamera
                                                ? CR_CAMERA_POSITION.BACK
                                                : CR_CAMERA_POSITION.FRONT;
                                        videoViewsKey.currentState
                                            ?.setDefaultVideo(cameraPosition, () {
                                              setState(() {});
                                            });
                                      }),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(155),
                                  height: ScreenUtil().setHeight(30),
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setHeight(7.5)),
                                  child: ElevatedButton(
                                      child: Text(
                                          "${_isOpenCamera ? '关闭' : '打开'}摄像头"),
                                      style: ButtonStyle(
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                      ),
                                      onPressed: () {
                                        switchCamera(!_isOpenCamera);
                                      }),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: ScreenUtil().setWidth(155),
                                  height: ScreenUtil().setHeight(30),
                                  child: ElevatedButton(
                                      child: Text(
                                          "${_isOpenMic ? '关闭' : '打开'}麦克风"),
                                      style: ButtonStyle(
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                      ),
                                      onPressed: () {
                                        switchMicPhone(!_isOpenMic);
                                      }),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(155),
                                  height: ScreenUtil().setHeight(30),
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setHeight(7.5)),
                                  child: ElevatedButton(
                                      child: Text(
                                          "切换为${_isSpeakerOut ? '听筒' : '扬声器'}"),
                                      style: ButtonStyle(
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14))),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                      ),
                                      onPressed: () {
                                        setSpeakerOut(!_isSpeakerOut);
                                      }),
                                )
                              ],
                            ),
                          ]),
                    ))
              ],
            )));
  }
}
