// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:developer'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brahmanshtalk/models/chat_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../controllers/HomeController/chat_controller.dart';
import '../../../controllers/networkController.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../main.dart';
import '../../../utils/constantskeys.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with AutomaticKeepAliveClientMixin {
  final chatController = Get.find<ChatController>();
  final networkController = Get.find<NetworkController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getchatlistdata());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Request",
          style: TextStyle(color: COLORS().textColor),
        ).tr(),
      ),
      body: GetBuilder<ChatController>(
        builder: (chatController) {
          return chatController.chatList.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        bottom: 200,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: COLORS().primaryColor,
                        ),
                        onPressed: () async {
                          var status = networkController.connectionStatus.value;
                          if (status <= 0) {
                            global.showToast(message: 'No internet');
                            return;
                          }
                          await chatController.getChatList(false);
                          chatController.update();
                        },
                        child: Icon(
                          Icons.refresh_outlined,
                          color: COLORS().textColor,
                        ),
                      ),
                    ),
                    Center(
                      child:
                          const Text('You don\'t have chat request yet!').tr(),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await chatController.getChatList(true);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: chatController.chatList.length,
                    physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    controller: chatController.scrollController,
                    itemBuilder: (context, index) {
                      final chatRequest = chatController.chatList[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: chatRequest.profile ?? '',
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/images/no_customer_image.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -5,
                                      right: -5,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.blue,
                                          child: Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: COLORS().primaryColor,
                                            size: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Text(
                                              chatRequest.name?.isNotEmpty ==
                                                      true
                                                  ? chatRequest.name!
                                                  : "User",
                                              style: Get.theme.primaryTextTheme
                                                  .displaySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: COLORS().primaryColor,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Text(
                                                chatRequest.birthDate != null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(
                                                        DateTime.parse(
                                                          chatRequest.birthDate
                                                              .toString(),
                                                        ),
                                                      )
                                                    : "N/A",
                                                style: Get
                                                    .theme
                                                    .primaryTextTheme
                                                    .titleSmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      chatRequest.birthTime?.isNotEmpty == true
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.schedule_outlined,
                                                    color:
                                                        COLORS().primaryColor,
                                                    size: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                    ),
                                                    child: Text(
                                                      chatRequest.birthTime!,
                                                      style: Get
                                                          .theme
                                                          .primaryTextTheme
                                                          .titleSmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    // Accept Button
                                    Container(
                                      width: 100,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green[400]!,
                                            Colors.green[600]!
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          _handleAcceptChat(index);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.phone,
                                                color: Colors.white, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Accept",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Reject Button
                                    Container(
                                      width: 100,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: COLORS().errorColor),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: COLORS().errorColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () async {
                                          _handleRejectCall(chatRequest);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.call_end,
                                                color: COLORS().errorColor,
                                                size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Reject",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getchatlistdata() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(ConstantsKeys.ISCHATAVILABLE, false);
    debugPrint('started getchatlistdata');
    await chatController.getChatList(true);
  }

  void _handleAcceptChat(int index) async {
    try {
      final chatRequest = chatController.chatList[index];

      // Debug: Print parameter types
      log("DEBUG: chatDuration value: ${chatRequest.chatDuration}");
      log("DEBUG: chatDuration type: ${chatRequest.chatDuration.runtimeType}");

      // Cancel all notifications first
      await localNotifications.cancelAll();

      // Store chat ID
      await chatController.storeChatId(
        chatRequest.id!,
        chatRequest.chatId!,
      );

      // Accept chat request - ONLY chatId is needed
      log("Calling acceptChatRequest with chatId: ${chatRequest.chatId!}");

      // Let the controller handle the loader and navigation
      final success = await chatController.acceptChatRequest(
        chatRequest.subscriptionid ?? "", // subscriptionId
        chatRequest.chatId!, // chatId
        chatRequest.userId, // userId
        chatRequest.name ?? 'User', // name
        chatRequest.profile ?? "", // profile
        chatRequest.id!, // requestId
        chatRequest.fcmToken ?? "", // fcmToken
        chatRequest.chatDuration.toString(), // chatDuration
        "chattab: ${chatRequest.fcmToken ?? ''}", // description
        showLoader: true, // controller will handle the loader
      );

      // Only handle failure cases here since success navigates to ChatScreen
      if (!success) {
        global.showToast(message: 'Failed to accept chat');
      }
    } catch (e) {
      global.hideLoader();
      global.showToast(message: 'Error accepting chat: $e');
      log("Error accepting chat: $e");
    }
  }

  Future<void> _handleRejectCall(ChatRequest call) async {
    // Only show the popup - do NOT call API here
    // NOTE: Do NOT call FlutterCallkitIncoming.endAllCalls() here as it may trigger
    // CallKit decline event which auto-calls the reject API
    
    // Show confirmation dialog - API will only be called from within the dialog
    await Get.dialog(
      Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.message_rounded,
                    color: Colors.red[600],
                    size: 32,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  "Reject Chat?",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ).tr(),

                const SizedBox(height: 8),

                // Message
                Text(
                  "Are you sure you want to reject this Chat request?",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),

                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.grey[700],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            global.isDialogopend = false;
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ).tr(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Reject Button - ONLY place where API is called
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[400]!, Colors.red[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              // Close notification and end CallKit calls
                              await localNotifications.cancelAll();
                              await FlutterCallkitIncoming.endAllCalls();

                              // Show loading
                              global.showOnlyLoaderDialog();

                              // API call happens ONLY here - inside the popup's reject button
                              final success = await chatController
                                  .rejectChatRequest(call.chatId!, showLoader: false, showToast: false);

                              global.hideLoader();

                              if (success) {
                                global.showToast(
                                    message: 'Chat rejected successfully');
                                // Remove the rejected request from the list
                                chatController.chatList.removeWhere(
                                    (item) => item.chatId == call.chatId);
                                chatController.update();
                              } else {
                                global.showToast(
                                    message: 'Failed to reject chat');
                              }

                              Get.back();
                            } catch (e) {
                              global.hideLoader();
                              global.showToast(
                                  message: 'Error rejecting chat: $e');
                              log("Error rejecting chat: $e");
                              Get.back();
                            }
                          },
                          child: Text(
                            "Reject",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      barrierDismissible: true,
    );
  }
}
