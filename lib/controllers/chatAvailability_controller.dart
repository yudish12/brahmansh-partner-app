// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constantskeys.dart';

class ChatAvailabilityController extends GetxController {
  int? chatType = 1;

  APIHelper apiHelper = APIHelper();
  bool showAvailableTime = true;
  final waitTime = TextEditingController();
  TimeOfDay? timeOfDay2;
  TimeOfDay selectedWaitTime = TimeOfDay.now();
  String? chatStatusName;

  void setChatAvailability(int? index, String? name) async {
    chatType = index;
    chatStatusName = name;
    update();

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chatType', index ?? 1);
    await prefs.setString('chatStatusName', name ?? "Online");
  }

  void loadChatAvailabilityFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    chatType = prefs.getInt('chatType') ?? 1;
    chatStatusName = prefs.getString('chatStatusName') ?? "Online";
    // Optional: if needed to show/hide available time based on saved status
    showAvailableTime = chatStatusName == "Online";
    update();
  }

  // void setChatAvailability(int? index, String? name) {
  //   chatType = index;
  //   chatStatusName = name;
  //   update();
  // }

  selectWaitTime(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedWaitTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null && timeOfDay != selectedWaitTime) {
        selectedWaitTime = timeOfDay;
        timeOfDay2 = timeOfDay;
        update();
        // ignore: use_build_context_synchronously
        waitTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception  - $screen - selectWaitTime():$e');
    }
  }

  statusChatChange({int? astroId, String? chatStatus, String? chatTime}) async {
    debugPrint('inside status chat $chatStatus');
    try {
      DateTime? date = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0);
      if (chatStatus == "Wait Time") {
        date = date.add(Duration(
          minutes: timeOfDay2!.minute,
          hours: timeOfDay2!.hour,
        ));
      }
      debugPrint('inside status chat addchat waitlist $chatStatus');

      await apiHelper
          .addChatWaitList(
              astrologerId: astroId, status: chatStatus, datetime: date)
          .then(
        (result) async {
          debugPrint('inside status chat status ${result.status}');

          if (result.status == "200") {
            global.user.chatStatus = chatStatus;
            global.user.chatWaitTime = date;
            await global.sp!.setString(
                ConstantsKeys.CURRENTUSER, json.encode(global.user.toJson()));
            debugPrint("Chat availability add successfully");
            update();
          } else {
            global.showToast(message: tr("Not available chat status"));
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - statusChatChange(): $e');
    }
  }
}
