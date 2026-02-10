// ignore_for_file: must_be_immutable, avoid_print, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_otp_controller.dart';
import 'package:brahmanshtalk/views/Authentication/OtpScreens/login_otp_screen.dart';
import 'package:brahmanshtalk/views/Authentication/signup_screen.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../controllers/Authentication/login_controller.dart';
import '../../../services/apiHelper.dart';

class SignupOtpScreen extends StatefulWidget {
  String? mobileNumber;
  String? otpCode;
  String? countryCode;

  SignupOtpScreen(
      {super.key, this.mobileNumber, this.otpCode, this.countryCode});

  @override
  State<SignupOtpScreen> createState() => _SignupOtpScreenState();
}

class _SignupOtpScreenState extends State<SignupOtpScreen> {
  // final SignupController signupController = Get.find<SignupController>();
  final signupController = Get.find<SignupController>();
  final signupOtpController = Get.find<SignupOtpController>();
  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  APIHelper apihelper = APIHelper();
  final pinEditingControllersignup = TextEditingController(text: '');
  final FocusNode focusNode = FocusNode();
  final logincontroller = Get.find<LoginController>();
  String? apiOtp;

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    apiOtp = widget.otpCode.toString();
    signupOtpController.maxSecond = 60;
    signupOtpController.second = 0;
    signupOtpController.update();
    signupOtpController.timer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: MyCustomAppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          height: 80,
          elevation: 0.5,
          appbarPadding: 0,
          title: const Text(
            MessageConstants.VERIFY_PHONE,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300, fontSize: 19),
          ).tr(),
          backgroundColor: Colors.grey[100],
        ),
        body: Center(
          child: SizedBox(
            width: Get.width - Get.width * 0.1,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Text(
                    'OTP Send to',
                    style: TextStyle(color: Colors.green, fontSize: 11.sp),
                  ).tr(args: [
                    signupOtpController.countryCode.toString(),
                    widget.mobileNumber.toString()
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 6.h,
                    width: 90.w,
                    child: Pinput(
                      controller: logincontroller.pinEditingController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      length: 6,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        signupController.smsCode = pin;
                        signupController.update();
                        log('smscode from : ${signupController.smsCode}');
                      },
                      onChanged: (pin) {
                        signupController.smsCode = pin;
                        signupController.update();
                        log('smscode from : ${signupController.smsCode}');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 2,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: borderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (logincontroller.pinEditingController.text.length ==
                            6) {
                          FocusScope.of(context).unfocus();
                          log('phoen no is ${signupController.cMobileNumber.text} and country code is ${signupController.countryCode} and otp is ${signupController.smsCode}');
                          log('otp 1 $apiOtp');
                          log('otp 2 ${logincontroller.pinEditingController.text.toString()}');
                          if (apiOtp ==
                              logincontroller.pinEditingController.text
                                  .toString()) {
                            log('otp mathced hurrey go ahead');
                            signupController.onStepNext();
                            Get.to(() => const SignupScreen());
                          } else {
                            log('otp not mathced ');
                          }
                        } else {
                          global.showToast(message: "Please enter valid OTP");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Get.theme.primaryColor,
                        textStyle:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      child: const Text(
                        MessageConstants.VERIFY_OTP,
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GetBuilder<SignupOtpController>(builder: (c) {
                    return SizedBox(
                        child: signupOtpController.maxSecond != 0
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Resend OTP Available in',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  ).tr(args: [
                                    signupOtpController.maxSecond.toString()
                                  ])
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const Text(
                                      'Resend OTP Available',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ).tr(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            signupOtpController.maxSecond = 60;
                                            signupOtpController.second = 0;
                                            signupOtpController.update();
                                            signupOtpController.timer();
                                            signupController.cMobileNumber
                                                .text = widget.mobileNumber!;
                                            log('Resend otp clicked mobile no is ${widget.mobileNumber} and country code is ${signupController.countryCode}');
                                            await verifyContactExistOrNot(
                                                signupController
                                                    .cMobileNumber.text,
                                                'register');
                                            print('Resend otp');
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    left: 25, right: 25)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Get.theme.primaryColor),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black)),
                                          ),
                                          child: const Text(
                                            'Resend OTP on SMS',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ).tr(),
                                        ),
                                      ],
                                    )
                                  ]));
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  verifyContactExistOrNot(String contactno, String type) async {
    try {
      global.showOnlyLoaderDialog();
      await apihelper.checkContact(contactno, type).then((response) {
        dynamic rspnse1 = json.decode(response.body)['status'];
        log('checkcontactExistOrNot response status $rspnse1');
        String msg = jsonDecode(response.body)['message'];
        global.hideLoader();
        log('checkcontactExistOrNot response msg $msg');

        if (rspnse1 == 200) {
          String loginotp = jsonDecode(response.body)['otp'];
          log('checkcontactExistOrNot otp msg $loginotp');
          apiOtp = loginotp; //apiOtp=
          setState(() {});
        } else if (rspnse1 == 400) {
          global.showToast(message: msg);
        }
      });
    } catch (e) {
      print('Exception in checkcontactExistOrNot : - ${e.toString()}');
    }
  }
}
