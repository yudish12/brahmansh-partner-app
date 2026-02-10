import 'dart:async';
import 'dart:developer';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../controllers/HomeController/home_controller.dart';
import '../../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../home_screen.dart';

class OnetooneZegoAudioCallScreen extends StatefulWidget {
  const OnetooneZegoAudioCallScreen({
    super.key,
    required this.callID,
    required this.userName,
    required this.id,
    required this.profile,
    required this.fcmToken,
    required this.callduration,
    this.currentUserName,
    this.currrentUserid,
  });
  final String callID;
  final int id;
  final String userName;
  final String profile;
  final String fcmToken;
  final String callduration;
  final int? currrentUserid;
  final String? currentUserName;

  @override
  State<OnetooneZegoAudioCallScreen> createState() =>
      _ZegoOnetoOneCallscreenState();
}

class _ZegoOnetoOneCallscreenState extends State<OnetooneZegoAudioCallScreen> {
  SharedPreferences? sp;
  final callController = Get.find<CallController>();
  final homeController = Get.find<HomeController>();
  final apiHelper = APIHelper();
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  ZegoUIKitPrebuiltCallConfig? config;
  Timer? _timer;
  bool _isTimerStarted = false;
  final remainingSeconds = ValueNotifier<int>(0);
  final isConnected = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    remainingSeconds.value = int.tryParse(widget.callduration) ?? 0;
    // Start foreground service right away (optional)
    ForegroundServiceManager.startForegroundTask();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        log('Sending call token for callID: ${widget.callID} and channel: ${global.agoraChannelName}');
        await callController.sendCallToken(
            '', global.agoraChannelName, widget.callID.toString());

        log('Call token sent successfully');
      } catch (e, st) {
        log('Error sending call token: $e');
        log(st.toString());
      }
    });
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

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    isConnected.dispose();
    remainingSeconds.dispose();
    ForegroundServiceManager.stopForegroundTask();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
      ..duration.isVisible = false
      ..audioVideoView.containerBuilder =
          (context, allUsers, audioVideoUsers, extraInfo) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background with gradient
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 27, 27, 233),
                      Color.fromARGB(255, 65, 106, 218),
                      Color.fromARGB(255, 15, 52, 96),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Call duration timer
                      ValueListenableBuilder<int>(
                        valueListenable: remainingSeconds,
                        builder: (context, seconds, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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

                      SizedBox(
                        height: 3.h,
                      ),
                      // Profile image or first letter
                      widget.profile.isNotEmpty
                          ? Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.profile),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  widget.userName.isNotEmpty
                                      ? widget.userName[0].toUpperCase()
                                      : 'A',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      // User name
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Connection status
                      ValueListenableBuilder<bool>(
                        valueListenable: isConnected,
                        builder: (context, connected, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: connected
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  connected ? 'Connected' : 'Waiting...',
                                  style: TextStyle(
                                    color: connected
                                        ? Colors.green
                                        : Colors.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      ..audioVideoView.foregroundBuilder = (context, size, user, extraInfo) {
        return Container();
      }
      ..audioVideoView.backgroundBuilder = (
        BuildContext context,
        Size size,
        ZegoUIKitUser? user,
        Map<String, dynamic> extraInfo,
      ) {
        return Container();
      }
      ..layout = ZegoLayout.pictureInPicture(
        smallViewPosition: ZegoViewPosition.topRight,
        smallViewSize: Size.zero,
        isSmallViewDraggable: false,
      );

    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        onDispose: () {
          log("ZegoUIKitPrebuiltCall disposed");
        },
        appID: int.parse(
            global.getSystemFlagValue(global.systemFlagNameList.zegoAppId)),
        appSign:
            global.getSystemFlagValue(global.systemFlagNameList.zegoAppSignIn),
        userID: 'astrologer_${widget.currrentUserid}',
        userName: widget.currentUserName ?? "Astro",
        callID: widget.callID,
        config: config!,
        events: ZegoUIKitPrebuiltCallEvents(
          onCallEnd: (event, defaultAction) async {
            _timer?.cancel();
            log("Audio call ended");
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
              // ✅ Only mark connected if it's NOT you
              log("Remote/Local id ${user.id}");
              if (user.id != widget.currrentUserid) {
                _startTimer();
                isConnected.value = true;
                log("Remote user joined: ${user.id}");
              }
            },
            onLeave: (user) {
              log("user left: ${user.id} ${user.name}");
              isConnected.value = false;
              _timer?.cancel();
              _isTimerStarted = false;
              ForegroundServiceManager.stopForegroundTask();
              Get.offAll(() => HomeScreen(isId: widget.id));
            },
          ),
          onHangUpConfirmation: (event, defaultAction) {
            log("hangup confimation");
            return defaultAction();
          },
          room: ZegoCallRoomEvents(
            onStateChanged: (roomstate) {
              if (roomstate.reason == ZegoRoomStateChangedReason.Logined) {
              } else if (roomstate.reason ==
                      ZegoRoomStateChangedReason.Logout ||
                  roomstate.reason == ZegoRoomStateChangedReason.KickOut) {
                _timer?.cancel();
                _isTimerStarted = false;
                isConnected.value = false;
              }
              log("room state: ${roomstate.reason}");
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
    );
  }
}
