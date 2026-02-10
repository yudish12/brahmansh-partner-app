import 'dart:developer';
import 'package:brahmanshtalk/views/HomeScreen/call/zegocloud/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../../utils/global.dart' as global;
import '../../home_screen.dart';

class zegoLiveHostScreen extends StatefulWidget {
  final bool isHost;
  final String? username;
  final String? userid;
  final String? profile;

  const zegoLiveHostScreen({
    super.key,
    this.isHost = false,
    this.username,
    this.userid,
    this.profile,
  });
  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<zegoLiveHostScreen> {
  SharedPreferences? sp;
  int currentUserId = 0;
  String currenUserName = "You";
  int zegoid = 0;
  String? liveid = '';
  ValueNotifier<String> currentUserProfile = ValueNotifier<String>('');
  final liveAstrologerController = Get.find<LiveAstrologerController>();

  @override
  void initState() {
    super.initState();
    currentUserId = int.parse(widget.userid ?? '0');
    currenUserName = widget.username ?? "You";

    zegoid = int.parse(
        global.getSystemFlagValue(global.systemFlagNameList.zegoAppId));
    liveid = global.zegoLiveID?.toString();
    log('''
        appid : ${int.parse(global.getSystemFlagValue(global.systemFlagNameList.zegoAppId))}
        appsign: ${global.getSystemFlagValue(global.systemFlagNameList.zegoAppSignIn)}    
        currentUserId: $currentUserId
        currenUserName: $currenUserName
        zegoid: $zegoid
        liveid : $liveid
        zegoAuthToken: ${global.zegoAuthToken}
    ''');
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    )
      ..audioVideoView.showUserNameOnView = false
      ..background = Container(
        color: Colors.black.withOpacity(0.6),
      )
      ..inRoomMessage.itemBuilder = (BuildContext context,
          ZegoInRoomMessage message, Map<String, dynamic> extraInfo) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${message.user.name}: ',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: message.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      };

    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
          appID: int.parse(
              global.getSystemFlagValue(global.systemFlagNameList.zegoAppId)),
          appSign: global
              .getSystemFlagValue(global.systemFlagNameList.zegoAppSignIn),
          userID: currentUserId.toString(),
          userName: currenUserName,
          liveID: liveid!,
          token: global.zegoAuthToken,
          events: ZegoUIKitPrebuiltLiveStreamingEvents(
            onError: (ZegoUIKitError error) {
              debugPrint('onError:$error');
            },
          ),
          config: hostConfig
            ..audioVideoView.useVideoViewAspectFill = true
            ..topMenuBar.buttons = []
            ..topMenuBar.showCloseButton = false
            ..bottomMenuBar.hostButtons = [
              ZegoLiveStreamingMenuBarButtonName.chatButton,
              ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
              ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
              ZegoLiveStreamingMenuBarButtonName.switchAudioOutputButton,
            ]
            ..inRoomMessageViewConfig = ZegoInRoomMessageViewConfig(
              // Bubble background
              messageTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 16),
            )
            ..bottomMenuBar.hostExtendButtons = [
              ZegoMenuBarExtendButton(
                child: GestureDetector(
                  onTap: () {
                    _showEndCallConfirmationDialog(context);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ]
            ..avatarBuilder = customAvatarBuilder,
        ),
      ),
    );
  }

  void _showEndCallConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_end_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'End Live Stream?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  'Are you sure you want to end the live stream for all viewers?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // End Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          liveAstrologerController.endLiveSession(false);

                          await ZegoUIKitPrebuiltLiveStreamingController()
                              .leave(context);

                          Get.off(() => HomeScreen());
                          log('bakcpress now');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'End Live',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
