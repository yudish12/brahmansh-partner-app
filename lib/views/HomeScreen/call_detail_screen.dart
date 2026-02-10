// ignore_for_file: avoid_print, must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/HomeController/call_detail_controller.dart';
import 'package:brahmanshtalk/models/History/call_history_model.dart';
import 'package:brahmanshtalk/views/HomeScreen/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import '../../models/chat_message_model.dart';

class CallDetailScreen extends StatelessWidget {
  CallHistoryModel callHistorydata;
  CallDetailScreen({super.key, required this.callHistorydata});
  final callDetailController = Get.put(CallDetailController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        await callDetailController.disposeAudioPlayer();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: COLORS().greyBackgroundColor,
          appBar: AppBar(
            titleSpacing: 1,
            iconTheme:  IconThemeData(color: COLORS().textColor),
            backgroundColor: COLORS().primaryColor,
            title: Text(
              callHistorydata.name != null && callHistorydata.name!.isNotEmpty
                  ? '${callHistorydata.name} detail\'s'
                  : tr("User detail's"),
              style: TextStyle(color: COLORS().textColor, fontSize: 17.sp),
            ),
            leading: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () async {
                await callDetailController.disposeAudioPlayer();
                Get.back();
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 25.h,
                width: width,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(width: 0.5, color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Client Profile:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Name: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                callHistorydata.name != null &&
                                        callHistorydata.name!.isNotEmpty
                                    ? '${callHistorydata.name}'
                                    : tr("User"),
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Mobile Number: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                global.maskMobileNumber(
                                    "${callHistorydata.contactNo}"),
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Call status: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                '${callHistorydata.callStatus}',
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Appointment Schedule
              SizedBox(
                height: 45.h,
                width: width,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(width: 0.5, color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Appointment Schedule:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Expert Name: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                '${callHistorydata.astrologerName}',
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Time: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                DateFormat('dd MMM yyyy , hh:mm a').format(
                                    DateTime.parse(
                                        callHistorydata.createdAt!.toString())),
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Duration: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                callHistorydata.totalMin != null &&
                                        callHistorydata.totalMin!.isNotEmpty
                                    ? '${callHistorydata.totalMin} min'
                                    : "0 min",
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Price: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${callHistorydata.charge}',
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Deduction: ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ).tr(),
                              Text(
                                '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${callHistorydata.deduction}',
                                style: Get.theme.primaryTextTheme.displaySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              callHistorydata.chatId != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12,
                      ),
                      child: const Text(
                        'Live Client Chat History',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ).tr(),
                    )
                  : const SizedBox(),
              callHistorydata.chatId != ""
                  ? Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: callDetailController.getChatMessages(
                                callHistorydata.chatId ?? "",
                                global.currentUserId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState.name == "waiting") {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Text(
                                      'snapShotError :- ${snapshot.error}');
                                } else {
                                  List<ChatMessageModel> messageList = [];
                                  for (var res in snapshot.data!.docs) {
                                    messageList.add(
                                        ChatMessageModel.fromJson(res.data()));
                                  }

                                  print(messageList.length);
                                  return ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: messageList.length,
                                      //shrinkWrap: true,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(12),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                ),
                                              ),
                                              width: 140,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    messageList[index].message!,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                  messageList[index]
                                                              .createdAt !=
                                                          null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  DateFormat()
                                                                      .add_jm()
                                                                      .format(messageList[
                                                                              index]
                                                                          .createdAt!),
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        9.5,
                                                                  )),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              }
                            }),
                      ),
                    )
                  : const SizedBox(),
              GestureDetector(
                onTap: () {
                  String? ssID;
                  log("ssid 0 for audio is  ${callHistorydata.sId}");
                  log("ssid 1 for audio is  ${callHistorydata.sId1}");

                  if (callHistorydata.sId!.isEmpty ||
                      callHistorydata.sId == null) {
                    ssID = callHistorydata.sId1;
                  } else {
                    ssID = callHistorydata.sId;
                  }
                  log("ssid for audio is  $ssID");

                  Get.to(() => Player(
                        sid: ssID.toString(),
                        callHistorydata: callHistorydata,
                      ));
                },
                child: Container(
                  height: 6.h,
                  width: 100.w,
                  margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.h),
                    color: Get.theme.primaryColor.withOpacity(0.2),
                    border: Border.all(color: Get.theme.primaryColor, width: 1),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/play.png',
                            color: Get.theme.primaryColor, height: 4.w),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          'Play',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall!
                              .copyWith(
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
