// // ignore_for_file: deprecated_member_use

// import 'dart:async';
// import 'dart:developer';
// import 'dart:math' as math;
// import 'package:AstrowayCustomerPro/views/call/zegocloud/common.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// import 'package:AstrowayCustomerPro/utils/global.dart' as global;

// class Zegolivescreen extends StatefulWidget {
//   final String liveID;
//   final bool isHost;
//   final String localUserID;

//   const Zegolivescreen({
//     Key? key,
//     required this.liveID,
//     required this.localUserID,
//     this.isHost = false,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _Zegolivescreen();
// }

// class _Zegolivescreen extends State<Zegolivescreen> {
//   late ZegoUIKitPrebuiltLiveStreamingConfig audienceConfig;
//   Timer? coHostTimer;
//   DateTime? coHostStartTime;
//   bool coHostAudioOnly = false;

//   @override
//   void initState() {
//     super.initState();
//     audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
//       plugins: [ZegoUIKitSignalingPlugin()],
//     )
//       ..bottomMenuBar.audienceButtons = [] // 👈 removes default cohost button
//       ..coHost.turnOnCameraWhenCohosted = () {
//         // Turn on camera only for video requests
//         return !coHostAudioOnly;
//       };

//     audienceConfig.audioVideoView.showAvatarInAudioMode = false;
//     audienceConfig.audioVideoView.showSoundWavesInAudioMode = true;
//     audienceConfig.audioVideoView.showUserNameOnView = false;
//     audienceConfig.duration = ZegoLiveStreamingDurationConfig(
//       isVisible: false,
//     );
//     ZegoUIKit().activeAppToForeground();

//     audienceConfig.bottomMenuBarConfig.buttonStyle =
//         ZegoBottomMenuBarButtonStyle(
//       chatEnabledButtonIcon: const Icon(Icons.chat, color: Colors.green),
//       chatDisabledButtonIcon: Icon(Icons.chair_alt, color: Colors.red),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
//       plugins: [ZegoUIKitSignalingPlugin()],
//     )..audioVideoView.foregroundBuilder = hostAudioVideoViewForegroundBuilder;

//     final audienceEvents = ZegoUIKitPrebuiltLiveStreamingEvents(
//       onError: (ZegoUIKitError error) {
//         log('Developer-onError:$error');
//       },
//       onEnded: (event, defaultAction) {
//         log('OnEnd reason - ${event.reason}');
//         log('OnEnd Joining timer - ${coHostStartTime}');
//         ZegoUIKitPrebuiltLiveStreamingController().leave(context);
//         Get.back();
//       },
//       coHost: ZegoLiveStreamingCoHostEvents(
//         coHost: ZegoLiveStreamingCoHostCoHostEvents(
//           onLocalConnected: () {
//             debugPrint("🎤 I became a co-host");
//             coHostStartTime = DateTime.now();
//             coHostTimer?.cancel();
//             coHostTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//               setState(() {});
//             });
//           },
//           onLocalDisconnected: () {
//             debugPrint("❌ I left or was removed as co-host");
//             coHostTimer?.cancel();
//             coHostStartTime = null;
//             //call api for timer send painse payment apis
//           },
//           onLocalConnectStateUpdated: (state) {
//             log('connected state is $state');
//             // if (state.toString().contains('connected')) {

//             // } else {

//             // }
//           },
//         ),
//       ),
//       audioVideo: ZegoLiveStreamingAudioVideoEvents(
//         onCameraTurnOnByOthersConfirmation: (BuildContext context) {
//           return onTurnOnAudienceDeviceConfirmation(
//             context,
//             isCameraOrMicrophone: true,
//           );
//         },
//         onMicrophoneTurnOnByOthersConfirmation: (BuildContext context) {
//           return onTurnOnAudienceDeviceConfirmation(
//             context,
//             isCameraOrMicrophone: false,
//           );
//         },
//       ),
//     );

//     return SafeArea(
//       child: Stack(
//         children: [
//           ZegoUIKitPrebuiltLiveStreaming(
//             appID: int.parse(global.getSystemFlagValueForLogin(global.systemFlagNameList.zegoAppId).toString()),
//             appSign:
//             global.getSystemFlagValueForLogin(global.systemFlagNameList.zegoAppSign),
//             userID: widget.localUserID,
//             userName: 'user_${widget.localUserID}',
//             liveID: widget.liveID,
//             events: widget.isHost
//                 ? ZegoUIKitPrebuiltLiveStreamingEvents(
//                     onError: (ZegoUIKitError error) {
//                       debugPrint('onError:$error');
//                     },
//                   )
//                 : audienceEvents,
//             config: (widget.isHost ? hostConfig : audienceConfig)
//               ..audioVideoView.useVideoViewAspectFill = true
//               ..topMenuBar.buttons = [
//                 ZegoLiveStreamingMenuBarButtonName.minimizingButton,
//               ]
//               ..coHost.maxCoHostCount = 1
//               ..avatarBuilder = customAvatarBuilder
//               ..inRoomMessage.attributes = userLevelsAttributes
//               ..inRoomMessage.avatarLeadingBuilder = userLevelBuilder,
//           ),
//           // Timer UI overlay, only if coHostStartTime != null
//           if (coHostStartTime != null)
//             Positioned(
//               top: 16,
//               right: 16,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   _formatElapsedTime(),
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.sp),
//                 ),
//               ),
//             ),

//           _buildCustomAudienceButtons(),
//         ],
//       ),
//     );
//   }

//   String _formatElapsedTime() {
//     if (coHostStartTime == null) return "00:00";
//     final duration = DateTime.now().difference(coHostStartTime!);
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return "$minutes:$seconds";
//   }

//   Map<String, String> userLevelsAttributes() {
//     return {
//       'lv': math.Random(widget.localUserID.hashCode).nextInt(100).toString(),
//     };
//   }

//   Widget userLevelBuilder(
//     BuildContext context,
//     ZegoInRoomMessage message,
//     Map<String, dynamic> extraInfo,
//   ) {
//     return Container(
//       alignment: Alignment.center,
//       height: 15,
//       width: 30,
//       padding: const EdgeInsets.all(2),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.purple.shade300, Colors.purple.shade400],
//         ),
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//       ),
//       child: Text(
//         "LV ${message.attributes['lv']}",
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 10,
//         ),
//       ),
//     );
//   }

//   Image prebuiltImage(String name) {
//     return Image.asset(name, package: 'zego_uikit_prebuilt_live_streaming');
//   }

//   Widget hostAudioVideoViewForegroundBuilder(
//     BuildContext context,
//     Size size,
//     ZegoUIKitUser? user,
//     Map<String, dynamic> extraInfo,
//   ) {
//     if (user == null || user.id == widget.localUserID) {
//       return Container();
//     }

//     const toolbarCameraNormal = 'assets/icons/toolbar_camera_normal.png';
//     const toolbarCameraOff = 'assets/icons/toolbar_camera_off.png';
//     const toolbarMicNormal = 'assets/icons/toolbar_mic_normal.png';
//     const toolbarMicOff = 'assets/icons/toolbar_mic_off.png';
//     return Positioned(
//       top: 15,
//       right: 0,
//       child: Row(
//         children: [
//           ValueListenableBuilder<bool>(
//             valueListenable: ZegoUIKit().getCameraStateNotifier(user.id),
//             builder: (context, isCameraEnabled, _) {
//               return GestureDetector(
//                 onTap: () {
//                   ZegoUIKit().turnCameraOn(!isCameraEnabled, userID: user.id);
//                 },
//                 child: SizedBox(
//                   width: size.width * 0.4,
//                   height: size.width * 0.4,
//                   child: prebuiltImage(
//                     isCameraEnabled ? toolbarCameraNormal : toolbarCameraOff,
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(width: size.width * 0.1),
//           ValueListenableBuilder<bool>(
//             valueListenable: ZegoUIKit().getMicrophoneStateNotifier(user.id),
//             builder: (context, isMicrophoneEnabled, _) {
//               return GestureDetector(
//                 onTap: () {
//                   ZegoUIKit().turnMicrophoneOn(
//                     !isMicrophoneEnabled,
//                     userID: user.id,
//                     muteMode: true,
//                   );
//                 },
//                 child: SizedBox(
//                   width: size.width * 0.4,
//                   height: size.width * 0.4,
//                   child: prebuiltImage(
//                     isMicrophoneEnabled ? toolbarMicNormal : toolbarMicOff,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> onTurnOnAudienceDeviceConfirmation(
//     BuildContext context, {
//     required bool isCameraOrMicrophone,
//   }) async {
//     const textStyle = TextStyle(
//       fontSize: 10,
//       color: Colors.white70,
//     );
//     const buttonTextStyle = TextStyle(
//       fontSize: 10,
//       color: Colors.black,
//     );
//     return await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.blue[900]!.withOpacity(0.9),
//           title: Text(
//               "You have a request to turn on your ${isCameraOrMicrophone ? "camera" : "microphone"}",
//               style: textStyle),
//           content: Text(
//               "Do you agree to turn on the ${isCameraOrMicrophone ? "camera" : "microphone"}?",
//               style: textStyle),
//           actions: [
//             ElevatedButton(
//               child: const Text('Cancel', style: buttonTextStyle),
//               onPressed: () => Navigator.of(context).pop(false),
//             ),
//             ElevatedButton(
//               child: const Text('OK', style: buttonTextStyle),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Build custom audience buttons positioned vertically on bottom right
//   Widget _buildCustomAudienceButtons() {
//     return Positioned(
//       top: 50.h,
//       right: 4,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // Audio Co-host Button
//           Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent.withOpacity(0.8),
//                 foregroundColor: Colors.white,
//                 shape: const StadiumBorder(),
//                 elevation: 3,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               ),
//               onPressed: () async {
//                 coHostAudioOnly = true;
//                 await ZegoUIKitPrebuiltLiveStreamingController()
//                     .coHost
//                     .audienceSendCoHostRequest(
//                       withToast: true,
//                       customData: '{"audio":true,"video":false}',
//                     );
//               },
//               icon: const Icon(Icons.mic, size: 20),
//               label: const Text('Audio'),
//             ),
//           ),

//           // Video Co-host Button
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.withOpacity(0.8),
//               foregroundColor: Colors.white,
//               shape: const StadiumBorder(),
//               elevation: 3,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             ),
//             onPressed: () async {
//               coHostAudioOnly = false;
//               await ZegoUIKitPrebuiltLiveStreamingController()
//                   .coHost
//                   .audienceSendCoHostRequest(
//                     withToast: true,
//                     customData: '{"audio":false,"video":true}',
//                   );
//             },
//             icon: const Icon(Icons.videocam, size: 20),
//             label: const Text('Video'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     log('ondispose timer canceled');
//     coHostTimer?.cancel();
//     super.dispose();
//   }
// }
