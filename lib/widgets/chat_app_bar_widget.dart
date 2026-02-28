import 'dart:async';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/call_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/chat_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/HomeController/timer_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/utils/config.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:brahmanshtalk/views/HomeScreen/products/productScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../constants/colorConst.dart';
import '../constants/imageConst.dart';
import '../controllers/Chattimercontroller.dart';
import '../utils/constantskeys.dart';


class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double? height;
  final double? elevation;
  final double? appbarPadding;
  final String? profile;
  final String? customername;
  final bool? centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final int? counterduration;
  final int? flagid;
  final String? subscriptionId;
  final int? customerid;
  final dynamic firebasechatid;

  const ChatAppBar(
      {super.key,
      this.leading,
      this.elevation,
      this.centerTitle,
      this.actions,
      this.backgroundColor,
      @required this.height,
      this.appbarPadding,
      this.profile,
      this.customername,
      this.counterduration,
      this.flagid,
      this.customerid,
      this.subscriptionId,
      this.firebasechatid});

  @override
  State<ChatAppBar> createState() => _MyCustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 80);
}

class _MyCustomAppBarState extends State<ChatAppBar> {
  int? subtitleCounter = 0;
  Timer? _timer;
  final chatController = Get.find<ChatController>();
  final chattimerController = Get.find<ChattimerController>();
  final callController = Get.find<CallController>();
  final timecontroller = Get.find<TimerController>();
  final messageController = TextEditingController();
  final walletController = Get.put(WalletController());
  final productController = Get.find<Productcontroller>();
  final apiHelper = APIHelper();
  final signupController = Get.find<SignupController>();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("My flag Id form chat app bar ${widget.flagid}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: widget.appbarPadding ?? 0,
              bottom: widget.appbarPadding ?? 0),
          child: AppBar(
            elevation: widget.elevation ?? 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: CachedNetworkImage(
                    imageUrl: '${widget.profile}',
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      IMAGECONST.noCustomerImage,
                      fit: BoxFit.fill,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                GetBuilder<ChattimerController>(builder: (chattimercontroller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          _truncateName(widget.customername),
                          style:
                              TextStyle(fontSize: 13.sp, color: COLORS().textColor),
                        ),
                      ),
                    // Only show the countdown when the timer has actually started
                    // (user joined). Removing `|| widget.flagid == 1` prevents the
                    // timer from appearing before the customer joins — previously
                    // status() was always called for flagid==1, but status() returns
                    // SizedBox.shrink() when endTime==0, and the "waiting to join"
                    // text was never shown because it was in the unreachable else branch.
                    chattimercontroller.newIsStartTimer == true
                        ? status()
                        : widget.flagid == 2
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'waiting to join..',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp),
                                ),
                              ),
                    ],
                  );
                }),
              ],
            ),
            centerTitle: widget.centerTitle,
            leading: widget.leading,
            actions: widget.actions,
            backgroundColor: widget.backgroundColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  String _truncateName(String? name) {
    if (name == null || name.trim().isEmpty) return 'User';
    name = name.trim();
    return name.length <= 10 ? name : '${name.substring(0, 10)}..';
  }

  String formatDurationHMS(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  Widget status() {
    return GetBuilder<ChattimerController>(
      builder: (chattimercontroller) {
        print("${chattimercontroller.newIsStartTimer}");
        print("widget.flagid :- ${widget.flagid}");
        if (chattimercontroller.newIsStartTimer == true) {
          print(
              "chatStatedAt fromstatus ${global.getStorage.read('chatStartedAt')}");
          if (global.getStorage.read('chatStartedAt') == null ||
              global.getStorage.read('chatStartedAt').toString() == "0") {
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            global.getStorage.write('chatStartedAt', timestamp);
          }
        } else {
          print("User not yet join");
        }
        final now = DateTime.now().millisecondsSinceEpoch;
        final remainingMillis = chattimercontroller.endTime - now;
        final remainingSeconds = (remainingMillis / 1000).floor();
        if (remainingSeconds <= 0) {
          return const SizedBox.shrink();
        }
        return CountdownTimer(
          endTime: chattimercontroller.endTime,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) return const Text('');
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                _formatRemainingTime(time),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: COLORS().textColor),
              ),
            );
          },
          onEnd: () {
            print("onEnd");

            print(
                "chattimercontroller.newIsStartTimer:- ${chattimercontroller.newIsStartTimer}");
            if (chattimercontroller.newIsStartTimer) {
              chattimercontroller.newIsStartTimer = false;
              chattimercontroller.update();
              chattimercontroller.update();
              final now = DateTime.now().millisecondsSinceEpoch;
              if (now >= chattimercontroller.endTime) {
                debugPrint(
                    'Timer ended naturally - ending chat ${chattimercontroller.endTime}');
                backpress();
              } else {
                debugPrint(
                    '⚠️ Timer onEnd triggered early, ignored. ${chattimercontroller.endTime}');
                // Don't call backpress on early end - timer widget might be rebuilding
              }
            } else {
              print("else");
            }
          },
        );
      },
    );
  }

  String _formatRemainingTime(CurrentRemainingTime time) {
    if ((time.hours ?? 0) > 0) {
      return '${_pad(time.hours)}:${_pad(time.min)}:${_pad(time.sec)}';
    } else if ((time.min ?? 0) > 0) {
      return '${_pad(time.min)}:${_pad(time.sec)}';
    } else {
      return '00:${_pad(time.sec)}';
    }
  }

  String _pad(int? n) => (n ?? 0).toString().padLeft(2, '0');

  void backpress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ConstantsKeys.ISACCEPTED, false);
    await prefs.setString(ConstantsKeys.ISACCEPTEDDATA, '');
    await prefs.setBool(ConstantsKeys.ISREJECTED, false);
    // Clear the chat-available flag so loadAllData() doesn't redirect to ChatTab
    // after the session ends (same fix applied in chat_screen.dart backpress).
    await prefs.setBool(ConstantsKeys.ISCHATAVILABLE, false);
    callController.newIsStartTimer = false;
    chattimerController.newIsStartTimer = false;
    chattimerController.isTimerStarted = false;
    chattimerController.update();
    callController.update();
    chattimerController.resetTimer();
    global.chatStartedAt = null;
    global.isChatTimerStarted = false;
    global.getStorage.remove('chatEndedAt');

    // Mark chatLeft so the Firebase stream debounce timer in chat_screen.dart
    // doesn't fire a second exit if customer disconnects around the same time.
    chatController.chatLeft = true;
    chatController.customerEndedChatFCM.value = false;

    if (chatController.activeSessions.values.isNotEmpty) {
      final session = chatController.activeSessions.values.first;
      Get.find<ChatController>().removeSession(session.sessionId, firebasechatId: session.fireBasechatId);
    } else {
      log('No active audio call sessions found');
    }
    chatController.update();

    global.inChatscreen(false);
    chatController.sendMessage('${global.user.name} -> ended chat',
        widget.customerid!, true, "chat_app_bar_widget");
    chatController.setOnlineStatus(
        false, widget.firebasechatid.toString(), '${global.currentUserId}',
        extiform: "form back press");

    bool success = await apiHelper.setAstrologerOnOffBusyline("Online");
    if (success) {
      Get.back();
      chatController.isInChatScreen = false;
      global.getStorage.write('chatStartedAt', 0);
      await global.getStorage.save();
      print("exit time:- ${global.getStorage.read('chatStartedAt')}");
      chatController.update();
    } else {
      log('Failed to set Astrologer status to Online');
    }
    Future.wait([
      Get.find<SignupController>().astrologerProfileById(false),
    ]);

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // title: const Text('AlertDialog Title'),
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
                ),
              ),
            ),
          ),
          actions: [
            Text(
              'Do you want to Recommend a Product ?',
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Yes'),
                  onPressed: () {
                    Get.back();
                    productController.getProductList();
                    Get.to(() => Productscreen(astroId: widget.customerid!));
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }


}