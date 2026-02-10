import 'dart:developer';
import 'dart:math' hide log;
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/CalltimerController.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/CallSessions.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/accept_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../controllers/HomeController/call_controller.dart';
import '../../../../controllers/HomeController/wallet_controller.dart';
import '../../../../services/apiHelper.dart';
import '../../../../utils/constantskeys.dart';
import '../../../../utils/foreground_task_handler.dart';
import '../../../../utils/global.dart' as global;

class Callrejoiningbanner extends StatefulWidget {
  const Callrejoiningbanner({super.key});

  @override
  State<Callrejoiningbanner> createState() => _CallrejoiningbannerState();
}

class _CallrejoiningbannerState extends State<Callrejoiningbanner> {
  final callController = Get.find<CallController>();
  final apiHelper = APIHelper();
  final walletController = Get.find<WalletController>();
  final signupController = Get.find<SignupController>();
  final calltimercontroller = Get.find<CalltimerController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      builder: (sessionController) {
        if (sessionController.activeaudiocallSessions.isEmpty) {
          log('no Active session For call');
          return const SizedBox.shrink();
        }
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
                const Icon(Icons.call, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Call with ${session.astrologerName}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.green, width: 1)),
                        child: Text(
                          'View Audio',
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
                      final _chatsession = callController
                          .activeaudiocallSessions.values.firstOrNull;
                      if (_chatsession != null) {
                        sessionController
                            .removeCallSession(_chatsession.sessionId);
                        await callController.agoraEngine.leaveChannel();
                        await Future.delayed(const Duration(milliseconds: 300));
                        await callController.agoraEngine.release(sync: true);
                      }
                      global.inCallscreen(false);
                      global.isaudioCallinprogress = 0;
                      global.isaudioMuted = false;
                      global.isaudioEnabled = false;
                      await walletController.getAmountList();
                      walletController.update();
                      debugPrint("leave");
                      await apiHelper.setAstrologerOnOffBusyline("Online");
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
                      await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
                      await prefs.setBool(ConstantsKeys.ISREJECTED, false);
                      clearList(session);
                      await signupController.astrologerProfileById(false);
                      ForegroundServiceManager.stopForegroundTask();
                      debugPrint('back called');
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  void clearList(Callsessions session) async {
    callController.callList.removeWhere(
        (call) => call.callId == int.parse(session.callId.toString()));
    callController.callList.clear();
    callController.update();
    await callController.getCallList(false);
    callController.update();
  }

  void _rejoinCall(Callsessions session) {
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

    Get.to(() => AcceptCallScreen(
      id: session.astrologerId,
      name: session.astrologerName,
      profile: session.astrologerProfile,
      callId: int.parse(session.callId.toString()),
      fcmToken: session.token,
      callduration: remainingTime.toString(),
    ));
  }
}
