// ignore_for_file: avoid_print

import 'dart:math' hide log;
import 'package:easy_localization/easy_localization.dart';
import 'package:brahmanshtalk/controllers/Chattimercontroller.dart';
import 'package:brahmanshtalk/controllers/HomeController/chat_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/HomeController/timer_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/chat/ChatSession.dart';
import 'package:brahmanshtalk/views/HomeScreen/chat/chat_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/products/productScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../controllers/HomeController/call_controller.dart';
import '../../../services/apiHelper.dart';

class ChatRejoinBanner extends StatefulWidget {
  const ChatRejoinBanner({super.key});

  @override
  State<ChatRejoinBanner> createState() => _ChatRejoinBannerState();
}

class _ChatRejoinBannerState extends State<ChatRejoinBanner> {
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final apiHelper = APIHelper();
  final walletController = Get.put(WalletController());
  final productController = Get.find<Productcontroller>();
  final timerController = Get.find<TimerController>();
  final signupController = Get.find<SignupController>();
  final chattimerController = Get.find<ChattimerController>();

  @override
  void initState() {
    super.initState();
  }

  /// Returns chat end time in ms (epoch). From session.chatEndedAt or computed from lastSaved + duration.
  int? _getChatEndedAtMs(ChatSession session) {
    if (session.chatEndedAt != null && session.chatEndedAt! > 0) {
      return session.chatEndedAt;
    }
    final start = _parseChatStartedAt(session.lastSaved);
    final sec = _parseChatDurationSeconds(session.chatduration) ?? 0;
    if (start != null && sec > 0) return start + (sec * 1000);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (sessionController) {
        if (sessionController.activeSessions.isEmpty) {
          return const SizedBox.shrink();
        }
        final session = sessionController.activeSessions.values.first;
        final endedAt = _getChatEndedAtMs(session);
        final now = DateTime.now().millisecondsSinceEpoch;
        if (endedAt != null && now >= endedAt) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (sessionController.activeSessions.containsKey(session.sessionId)) {
              backpress(session);
              global.showToast(message: 'Chat Time Expired');
            }
          });
          return const SizedBox.shrink();
        }
        return InkWell(
          onTap: () {
            debugPrint('rejoin chat seession is $session');
            _rejoinChat(session);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active chat with ${session.customerName}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 1.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.green, width: 1)),
                        child: Text(
                          'View Chat',
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
                    onPressed: () {
                      backpress(session);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  void backpress(ChatSession session) async {
    global.chatStartedAt = null;
    global.getStorage.write('chatStartedAt', 0);
    global.getStorage.remove('chatEndedAt');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('inside it appbar click');
      chattimerController.newIsStartTimer = false;
      chattimerController.isTimerStarted = false;
      chattimerController.resetTimer();
      chattimerController.update();
    });
    await walletController.getAmountList();
    global.inChatscreen(false);
    chatController.sendMessage(
        'Your allotted minutes have expired. To join again, recharge your wallet and then join. For any further assistance, contact customer support',
        session.customerId,
        true,
        "chatRejoin");
    await apiHelper.setAstrologerOnOffBusyline("Online");
    await signupController.astrologerProfileById(false);
    chatController.removeSession(session.sessionId,
        firebasechatId: session.fireBasechatId);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 8),
            height: 12.h,
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/interrogation-mark.png',
                      height: 7.h,
                    ))),
          ),
          actions: [
            Text('Do you want to Recommend a Product ?',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 3.w,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Yes'),
                  onPressed: () async {
                    Get.back();
                    await productController.getProductList();
                    Get.to(() => Productscreen(astroId: session.customerId));
                  },
                ),
              ],
            )
          ],
        );
      },
    );
    chattimerController.update();
    callController.update();
  }

  String formatDurationHMS(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  /// Parses a value to int (ms). Returns null if 0, null, or invalid.
  int? _parseChatStartedAt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value > 0 ? value : null;
    final s = value.toString().trim();
    if (s.isEmpty || s == '0') return null;
    final parsed = int.tryParse(s);
    return (parsed != null && parsed > 0) ? parsed : null;
  }

  /// Parses session chat duration to seconds. Returns null if invalid.
  int? _parseChatDurationSeconds(dynamic value) {
    if (value == null) return null;
    if (value is int) return value >= 0 ? value : null;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    final parsed = int.tryParse(s);
    return (parsed != null && parsed >= 0) ? parsed : null;
  }

  void _rejoinChat(ChatSession session) async {
    debugPrint("global.chatStartedAt: ${global.chatStartedAt}");
    debugPrint(
        "session.chatduration: ${session.chatduration}, lastSaved: ${session.lastSaved}");
    debugPrint("session: ${session}");
    final fromGlobal = _parseChatStartedAt(global.chatStartedAt);
    final fromStorage =
        _parseChatStartedAt(global.getStorage.read('chatStartedAt'));
    final fromLastSaved = _parseChatStartedAt(session.lastSaved);
    final int? chatStartedAt = fromGlobal ?? fromStorage ?? fromLastSaved;

    final int totalDurationSeconds =
        _parseChatDurationSeconds(session.chatduration) ?? 0;
    print("totalDurationSeconds:- $totalDurationSeconds");

    await Future.delayed(const Duration(milliseconds: 100));
    final now = DateTime.now().millisecondsSinceEpoch;

    int remainingTime;
    if (chatStartedAt == null || chatStartedAt <= 0) {
      print("totalDurationSeconds:- $totalDurationSeconds");
      remainingTime = totalDurationSeconds > 0 ? totalDurationSeconds : 60;
      debugPrint(
          '_rejoinChat: no valid chatStartedAt (g=$fromGlobal, s=$fromStorage, last=$fromLastSaved), using full duration: $remainingTime s');
    } else {
      
      final totalTimeElapsed = ((now - chatStartedAt) / 1000).toInt();
      remainingTime = max(0, totalDurationSeconds - totalTimeElapsed);
      final dt = DateTime.fromMillisecondsSinceEpoch(chatStartedAt);
      debugPrint(
          'chat StartedAt -> ${DateFormat('hh:mm a').format(dt)}, elapsed ${totalTimeElapsed}s, remaining ${formatDurationHMS(remainingTime)}');
    }

    if (remainingTime <= 0) {
      debugPrint('⚠️ Chat time expired, not rejoining');
      backpress(session);
      global.showToast(message: 'Chat Time Expired');
      return;
    }

    Get.to(() => ChatScreen(
          flagId: 1,
          customerName: session.customerName ?? "",
          customerId: session.customerId,
          customerProfile: session.customerProfile ?? "",
          chatduration: remainingTime,
          fireBasechatId: session.fireBasechatId,
          astrologerId: session.astrologerId,
          astrouserID: session.astrouserID,
          subscriptionId: session.subscriptionId,
          fromrejoin: 1,
          fcmToken: session.userFcm,
        ));
  }
}
