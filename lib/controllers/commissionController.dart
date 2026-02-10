// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';
import '../utils/global.dart' as global;

class CommissionController extends GetxController {
  /// Mode: true = Pre-offer, false = Custom
  var isPreOffer = true.obs;

  /// Enable/Disable toggles
  var chatEnabled = true.obs;
  var audioEnabled = true.obs;
  var videoEnabled = true.obs;

  /// Pre-offer selections
  var selectedChat = RxnInt();
  var selectedAudio = RxnInt();
  var selectedVideo = RxnInt();

  /// Custom inputs
  final chatCtrl = TextEditingController();
  final audioCtrl = TextEditingController();
  final videoCtrl = TextEditingController();

  /// Loader state
  var isLoading = false.obs;

  /// Pre-offer options (constant list)
  final List<int> preOfferOptions = [10, 20, 30, 40];

  /// API call
  Future<void> saveCommission() async {
    if (global.user.id!.toString() == "" ||
        global.user.id!.toString() == "null") {
      Get.snackbar("Error", "Astrologer ID missing!",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;

    print("isPreOffer.value:- ${isPreOffer.value}");
    print("selectedChat.value:- ${selectedChat.value}");
    final body = {
      "astrologerId": global.user.id!, // ✅ Added here
      "chat_discount": isPreOffer.value
          ? ((selectedChat.value ?? 0).toString())
          : (chatCtrl.text.isEmpty ? "0" : chatCtrl.text),
      "audio_discount": isPreOffer.value
          ? (selectedAudio.value ?? 0).toString()
          : audioCtrl.text.isEmpty
              ? "0"
              : audioCtrl.text,
      "video_discount": isPreOffer.value
          ? (selectedVideo.value ?? 0).toString()
          : videoCtrl.text.isEmpty
              ? "0"
              : videoCtrl.text,
      "isDiscountedPrice":
          (chatEnabled.value || audioEnabled.value || videoEnabled.value)
              ? "1"
              : "0", // ✅ Now 0 or 1
    };

    try {
      print("response");
      print("${appParameters[appMode]['apiUrl']}astrologer/setDiscountPrice");
      print(body);
      final response = await http.post(
        Uri.parse(
            "${appParameters[appMode]['apiUrl']}astrologer/setDiscountPrice"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      log("log bodydata ${json.encode(body)}");
      log("log res ${response.statusCode}");

      if (response.statusCode == 200) {
        await Get.find<SignupController>().astrologerProfileById(false);
        Get.back();
        Get.snackbar("Success", "Commission saved successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Failed to save commission",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        debugPrint("Error: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      debugPrint("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
