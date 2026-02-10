import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../controllers/HomeController/home_controller.dart';
import '../../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../../../utils/global.dart' as global;
import '../../home_screen.dart';

class OnetooneZegoVideoCallScreen extends StatefulWidget {
  OnetooneZegoVideoCallScreen(
      {
        super.key,
      required this.callID,
      required this.profile,
      required this.userName,
      required this.id,
      required this.fcmToken,
      required this.callduration,
      this.currrentUserid,
      this.currentUserName});
  final String callID;
  final String profile;
  final String userName;
  final int id;
  final String fcmToken;
  final String callduration;
  int? currrentUserid;
  String? currentUserName;

  @override
  State<OnetooneZegoVideoCallScreen> createState() =>
      _ZegoOnetoOneCallscreenState();
}

class _ZegoOnetoOneCallscreenState extends State<OnetooneZegoVideoCallScreen> {
  final zegocontroller = ZegoUIKitPrebuiltCallController();
  final homeController = Get.find<HomeController>();
  final apiHelper = APIHelper();
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final callController = Get.find<CallController>();
  final remainingSeconds = ValueNotifier<int>(0);
  Timer? _timer;
  bool _isTimerStarted = false;
  SharedPreferences? sp;

  @override
  void initState() {
    super.initState();
    remainingSeconds.value = int.tryParse(widget.callduration) ?? 0;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        getcallToken();
      },
    );
  }

  void getcallToken() async {
    ForegroundServiceManager.startForegroundTask();
    final calltoken = await callController.sendCallToken(
        '', global.agoraChannelName, widget.callID.toString());
    log('video_call token get is $calltoken');
    log('profile image is ${widget.profile}');
  }

  void _startTimer() {
    if (_isTimerStarted) return;
    _isTimerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      log('Remaining seconds: ${remainingSeconds.value}');
      if (mounted) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          timer.cancel();
          _isTimerStarted = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    remainingSeconds.dispose();
    ForegroundServiceManager.stopForegroundTask();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ZegoUIKitPrebuiltCall(
          appID: int.parse(
              global.getSystemFlagValue(global.systemFlagNameList.zegoAppId)),
          appSign: global
              .getSystemFlagValue(global.systemFlagNameList.zegoAppSignIn),
          userID: 'astrologer_${widget.currrentUserid}',
          userName: widget.currentUserName ?? "Astro",
          callID: widget.callID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            ..turnOnCameraWhenJoining = true
            ..turnOnMicrophoneWhenJoining = true
            ..duration.isVisible = false, // Hide default timer
          events: ZegoUIKitPrebuiltCallEvents(
            onCallEnd: (event, defaultAction) async {
              log("call ended");
              homeController.getOnlineAstro(0);
              await apiHelper.setAstrologerOnOffBusyline('Online');
              await liveAstrologerController.endLiveSession(false);
              ForegroundServiceManager.stopForegroundTask();
              Get.offAll(() => HomeScreen(isId: widget.id));
            },
            onError: (onError) {
              log("error: ${onError.code} ${onError.message}");
            },
            user: ZegoCallUserEvents(
              onEnter: (user) {
                log("remote user joined: ${user.id} and user is ${widget.currrentUserid}");
                log("Remote/Local id ${user.id}");
                if (user.id != widget.currrentUserid) {
                  _startTimer();
                  log("Remote user joined: ${user.id}");
                }
              },
              onLeave: (user) async {
                log("user left: ${user.id} ${user.name}");
                _timer?.cancel();
                _isTimerStarted = false;
                homeController.getOnlineAstro(0);
                await apiHelper.setAstrologerOnOffBusyline('Online');
                await liveAstrologerController.endLiveSession(false);
                ForegroundServiceManager.stopForegroundTask();
              },
            ),
            onHangUpConfirmation: (event, defaultAction) {
              log("hangup confimation");
              return defaultAction();
            },
            room: ZegoCallRoomEvents(
              onStateChanged: (roomstate) {
                log("room state: ${roomstate.reason}");
                if (roomstate.reason == ZegoRoomStateChangedReason.Logined) {
                } else if (roomstate.reason ==
                        ZegoRoomStateChangedReason.Logout ||
                    roomstate.reason == ZegoRoomStateChangedReason.KickOut) {
                  _timer?.cancel();
                  _isTimerStarted = false;
                }
              },
              onTokenExpired: (remainSeconds) {
                String returnThis =
                    "token expired, remain seconds: $remainSeconds";
                log(returnThis);
                return null;
              },
            ),
          ),
        ),

        // Custom Timer Display at Top Center
        // Call duration timer
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          right: 0,
          left: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder<int>(
              valueListenable: remainingSeconds,
              builder: (context, seconds, child) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(seconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ));
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
