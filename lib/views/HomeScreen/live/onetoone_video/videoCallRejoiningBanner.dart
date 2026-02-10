import 'dart:developer';
import 'dart:math' hide log;
import 'package:brahmanshtalk/controllers/CalltimerController.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/CallSessions.dart';
import 'package:brahmanshtalk/views/HomeScreen/live/onetoone_video/onetooneVideo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../controllers/Authentication/signup_controller.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../../controllers/HomeController/wallet_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/constantskeys.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../../../utils/global.dart' as global;

class videoCallrejoiningbanner extends StatefulWidget {
  const videoCallrejoiningbanner({super.key});

  @override
  State<videoCallrejoiningbanner> createState() => _CallrejoiningbannerState();
}

class _CallrejoiningbannerState extends State<videoCallrejoiningbanner> {
  final callController = Get.find<CallController>();
  final apiHelper = APIHelper();
  final walletController = Get.find<WalletController>();
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final signupController = Get.find<SignupController>();
  final calltimercontroller = Get.find<CalltimerController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      builder: (sessionController) {
        if (sessionController.activeaudiocallSessions.isEmpty) {
          // No active sessions
          log('no Active session For call');
          return const SizedBox.shrink();
        }
        // Get the first active session (you can modify this logic if you want to handle multiple)
        final session = sessionController.activeaudiocallSessions.values.first;

        return InkWell(
          onTap: () {
            _rejoinCall(session);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.video_call, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Call with ${session.astrologerName}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.green, width: 1)),
                        child: Text(
                          'View Video',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () async {
                      calltimercontroller.resetTimer();

                      final _callsession = callController
                          .activeaudiocallSessions.values.firstOrNull;
                      if (_callsession != null) {
                        sessionController
                            .removeCallSession(_callsession.sessionId);
                        await callController.agoraEngine.leaveChannel();

                        /// Delay a bit to let Agora notify others properly
                        await Future.delayed(const Duration(milliseconds: 300));
                        await callController.agoraEngine.release(sync: true);
                      }
                      global.inCallscreen(false);
                      ForegroundServiceManager.stopForegroundTask();
                      //clear data for fututre
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
                      await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
                      await prefs.setBool(ConstantsKeys.ISREJECTED, false);

                      liveAstrologerController.isImInLive = false;
                      liveAstrologerController.update();
                      Future.wait<void>([
                        liveAstrologerController.endLiveSession(false),
                        apiHelper.setAstrologerOnOffBusyline("Online"),
                        signupController.astrologerProfileById(false)
                      ]);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _rejoinCall(Callsessions session) {
    // final callStartedAt = GetStorage().read('callStartedAt') ?? 0;
    int callStartedAt =
        session.savedAt ?? GetStorage().read('callStartedAt') ?? 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    final totalTimeElapsed = ((now - callStartedAt) / 1000).toInt();
    final remainingTime =
        max(0, int.parse(session.duration.toString()) - totalTimeElapsed);

    log('⏱️ Remaining time on rejoin: $remainingTime');

    if (remainingTime <= 0) {
      log('⚠️ Call time expired, not rejoining');
      return;
    }

    Get.to(() => OneToOneLiveScreen(
          id: session.astrologerId,
          name: session.astrologerName,
          profile: session.astrologerProfile,
          callId: int.parse(session.callId.toString()),
          fcmToken: session.token,
          call_duration: remainingTime.toString(),
        ));
  }

  // void _rejoinCall(Callsessions session) {
  //   int now = DateTime.now().millisecondsSinceEpoch;

  //   int saveattime = global.callStartedAt!;
  //   log('rejoing mysaveattime1 $saveattime');
  //   int totalTimeElapsed = ((now - saveattime) / 1000).toInt();
  //   int remainingTime =
  //       max(0, (int.parse(session.duration.toString()) - totalTimeElapsed));
  //   log('rejoing totalTimeElapsed $totalTimeElapsed');
  //   log('rejoing remaining time $remainingTime');

  //   print("astrologerProfile:- ${session.astrologerProfile}");
  //   print("astrologerName:- ${session.astrologerName}");
  //   callController.removeCallSession(session.sessionId);
  //   Get.to(() => OneToOneLiveScreen(
  //         id: session.astrologerId,
  //         name: session.astrologerName,
  //         profile: session.astrologerProfile,
  //         callId: int.parse(session.callId.toString()),
  //         fcmToken: session.token,
  //         call_duration: remainingTime.toString(),
  //       ));
  // }
}
