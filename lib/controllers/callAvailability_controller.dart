// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/utils/constantskeys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class CallAvailabilityController extends GetxController {
  int? callType = 1;
  bool showAvailableTime = true;
  APIHelper apiHelper = APIHelper();
  TimeOfDay? timeOfDay2;
  final waitTime = TextEditingController();
  String? callStatusName = "Online";
  TimeOfDay selectedWaitTime = TimeOfDay.now();

  final cWaitTimeTime = TextEditingController();

  // void setCallAvailability(int? index, String? name) {
  //   callType = index;
  //   callStatusName = name;
  //   update();
  // }

  void setCallAvailability(int? index, String? name) async {
    callType = index;
    callStatusName = name;
    update();

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('callType', index ?? 1);
    await prefs.setString('callStatusName', name ?? "Online");
  }

  void loadCallAvailabilityFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    callType = prefs.getInt('callType') ?? 1;
    callStatusName = prefs.getString('callStatusName') ?? "Online";
    // Optional: if needed to show/hide available time based on saved status
    showAvailableTime = callStatusName == "Online";
    update();
  }

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
        // ignore: use_build_context_synchronously
        waitTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception  - $screen - selectStartTime():$e');
    }
  }

  statusCallChange({int? astroId, String? callStatus, String? callTime}) async {
    debugPrint(
        "astroId: $astroId, callStatus: $callStatus, callTime: $callTime");
    try {
      await apiHelper
          .addCallWaitList(astrologerId: astroId, status: callStatus)
          .then(
        (result) async {
          if (result.status == "200") {
            global.user.callStatus = callStatus;
            await global.sp!.setString(
                ConstantsKeys.CURRENTUSER, json.encode(global.user.toJson()));
            debugPrint('Call availability add successfully');
            update();
          } else {
            global.showToast(message: tr("Not available call status"));
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - statusCallChange(): $e');
    }
  }
}
