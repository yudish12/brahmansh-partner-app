// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';
import 'dart:developer';
import 'package:brahmanshtalk/controllers/HomeController/call_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../controllers/networkController.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../main.dart';
import '../../../models/call_model.dart';

class CallTab extends StatefulWidget {
  const CallTab({super.key});

  @override
  _CallTabState createState() => _CallTabState();
}

class _CallTabState extends State<CallTab> with AutomaticKeepAliveClientMixin {
  final callController = Get.find<CallController>();
  final networkController = Get.find<NetworkController>();

  // Timer to update countdowns
  final Map<int, Timer> _timers = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _timers.forEach((key, timer) => timer.cancel());
    _timers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text("Call Request",
        style: TextStyle(
          color:   COLORS().textColor
        ),).tr(),
      ),
      body: GetBuilder<CallController>(
        builder: (callController) {
          return callController.callList.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 10, bottom: 200),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: COLORS().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          var status = networkController.connectionStatus.value;
                          if (status <= 0) {
                            global.showToast(message: 'No internet');
                            return;
                          }
                          await callController.getCallList(false);
                          callController.update();
                        },
                        child:  Icon(
                          Icons.refresh_outlined,
                          color: COLORS().textColor,
                        ),
                      ),
                    ),
                    Center(
                      child:
                          const Text("You don't have call request yet!").tr(),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await callController.getCallList(true);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: callController.callList.length,
                    controller: callController.scrollController,
                    physics: const ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (context, index) {
                      CallModel callItem = callController.callList[index];
                      final isScheduled = callItem.IsSchedule == 1;
                      final scheduledTime = callItem.scheduleDatetime != null
                          ? DateTime.tryParse(
                              callItem.scheduleDatetime.toString())
                          : null;

                      // Start timer for scheduled calls
                      if (isScheduled && scheduledTime != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _startTimerForCall(callItem.callId, scheduledTime);
                        });
                      }

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
                              // Profile Image with Call Type Indicator
                              Expanded(
                                flex: 2,
                                child: Stack(
                                  clipBehavior: Clip.none,
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
                                          imageUrl: '${callItem.profile}',
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
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor:
                                              callItem.callType == 10
                                                  ? Colors.blue
                                                  : Colors.red,
                                          child: Icon(
                                            callItem.callType == 10
                                                ? Icons.call
                                                : Icons.video_call,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isScheduled)
                                      Positioned(
                                        bottom: -5,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Scheduled",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ).tr(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // User Details
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: COLORS().primaryColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            callItem.name?.isEmpty ?? true
                                                ? "User"
                                                : callItem.name!,
                                            style: Get.theme.primaryTextTheme
                                                .displaySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // Birth Date
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: COLORS().primaryColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(callItem.birthDate
                                                  .toString())),
                                          style: Get.theme.primaryTextTheme
                                              .titleSmall,
                                        ),
                                      ],
                                    ),

                                    if (callItem.birthTime?.isNotEmpty ??
                                        false) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule_outlined,
                                            color: COLORS().primaryColor,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            callItem.birthTime!,
                                            style: Get.theme.primaryTextTheme
                                                .titleSmall,
                                          ),
                                        ],
                                      ),
                                    ],

                                    // Scheduled Time Countdown
                                    if (isScheduled &&
                                        scheduledTime != null) ...[
                                      const SizedBox(height: 8),
                                      _buildCountdownTimer(
                                          scheduledTime, callItem.callId),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Action Buttons
                              _buildActionButtons(
                                  callItem, index, isScheduled, scheduledTime),
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

  Widget _buildCountdownTimer(DateTime scheduledTime, int callId) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    // If time has passed, show "Ready" status
    if (difference.isNegative) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[100]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 12, color: Colors.green[600]),
            const SizedBox(width: 4),
            Text(
              'Ready to Accept',
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w300,
                color: Colors.green[800],
              ),
            ).tr(),
          ],
        ),
      );
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, size: 12, color: Colors.blue[600]),
          const SizedBox(width: 4),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      CallModel call, int index, bool isScheduled, DateTime? scheduledTime) {
    final now = DateTime.now();
    final isTimeReached = scheduledTime == null || now.isAfter(scheduledTime);

    if (isScheduled && !isTimeReached) {
      // Show disabled button with timer (time not reached)
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.lock_clock, color: Colors.grey[600], size: 20),
                const SizedBox(height: 4),
                Text(
                  "Wait",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Accept Button
        Container(
          width: 100,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[400]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
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
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: () async {
              await _handleAcceptCall(call);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 14),
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
            border: Border.all(color: COLORS().errorColor),
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
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: () async {
              await _handleRejectCall(call);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_disabled,
                    color: COLORS().errorColor, size: 14),
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
    );
  }

  Future<void> _handleAcceptCall(CallModel call) async {
    if (call.callType == 10) {
      global.showOnlyLoaderDialog();
      await callController.acceptCallRequest(
        call.callId,
        call.profile?.isEmpty ?? true
            ? "assets/images/no_customer_image.png"
            : call.profile,
        call.name ?? 'User',
        call.id,
        call.fcmToken ?? '',
        call.callDuration.toString(),
        call.call_method.toString(),
      );
    } else if (call.callType == 11) {
      log('on homescreen accept video audio ');
      global.showOnlyLoaderDialog();
      await callController.acceptVideoCallRequest(
        call.callId,
        call.profile?.isEmpty ?? true
            ? "assets/images/no_customer_image.png"
            : call.profile,
        call.name ?? 'User',
        call.id,
        call.fcmToken ?? '',
        call.callDuration!.toString(),
        call.call_method.toString(),
      );
    } else {
      debugPrint('for audio calltype 10 and 11 for video its neither of them');
    }
  }

  Future<void> _handleRejectCall(CallModel call) async {
    await FlutterCallkitIncoming.endAllCalls();
    Get.dialog(
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
                  Icons.phone_disabled,
                  color: Colors.red[600],
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                "Reject Call?",
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
                "Are you sure you want to reject this call request?",
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
                        onPressed: () => Get.back(),
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

                  // Reject Button
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
                        onPressed: () {
                          // Close notification
                          Future.delayed(const Duration(milliseconds: 300))
                              .then((value) async {
                            await localNotifications.cancelAll();
                          });

                          // Reject call
                          callController.rejectCallRequest(call.callId);
                          callController.update();
                          Get.back();
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

  void _startTimerForCall(int callId, DateTime scheduledTime) {
    if (_timers.containsKey(callId)) {
      _timers[callId]!.cancel();
      _timers.remove(callId);
    }

    final now = DateTime.now();
    if (now.isAfter(scheduledTime)) {
      return;
    }

    Timer? timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final currentTime = DateTime.now();
      if (currentTime.isAfter(scheduledTime)) {
        // Time reached - cancel timer and update UI
        timer.cancel();
        _timers.remove(callId);

        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    });

    _timers[callId] = timer;
  }

  @override
  bool get wantKeepAlive => true;

  void _init() async {
    await callController.getCallList(true);
  }
}
