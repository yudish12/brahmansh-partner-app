// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/apiHelper.dart';
import 'signup_controller.dart';

class LoginOtpController extends GetxController {
  SignupController signupController = Get.find<SignupController>();
  String screen = 'login_otp_controller.dart';
  double second = 0;
  var maxSecond;
  Timer? time;
  Timer? time2;
  final TextEditingController cMobileNumber = TextEditingController();
  dynamic smsCode = '';
  APIHelper apiHelper = APIHelper();

  String? phonenois;
  String? countrycodeis;

  String countryCode = "+91";
  bool countryvalidator = false;

  bool validedPhone() {
    return countryvalidator;
  }

  updateCountryCode(String? value) {
    countryCode = value ?? "+91";
    log('country code is $countryCode');
    update();
  }

  init() {}

  timer() {
    maxSecond = 60;
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (maxSecond > 0) {
        maxSecond--;
        update();
      } else {
        time!.cancel();
        update();
      }
    });
  }
}
