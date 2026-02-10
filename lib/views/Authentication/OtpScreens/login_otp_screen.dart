// ignore_for_file: must_be_immutable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../constants/messageConst.dart';
import '../../../controllers/Authentication/login_controller.dart';
import '../../../controllers/Authentication/login_otp_controller.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../widgets/app_bar_widget.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../login_screen.dart';

const borderColor = Color.fromRGBO(114, 178, 238, 1);
const errorColor = Color.fromRGBO(255, 234, 238, 1);
const fillColor = Color.fromRGBO(222, 231, 240, .57);
final defaultPinTheme = PinTheme(
  width: 65,
  height: 65,
  textStyle: const TextStyle(
    fontSize: 18,
    color: Color.fromRGBO(30, 60, 87, 1),
  ),
  decoration: BoxDecoration(
    color: fillColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey[400]!, width: 0.7),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(8),
);

const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);

class LoginOtpScreen extends StatefulWidget {
  String? mobileNumber;
  String? otpCode;
  String? countryCode;

  LoginOtpScreen({
    super.key,
    required this.mobileNumber,
    required this.otpCode,
    this.countryCode,
  });

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final loginOtpController = Get.find<LoginOtpController>();
  final loginController = Get.find<LoginController>();
  final signupController = Get.find<SignupController>();
  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  APIHelper apihelper = APIHelper();
  bool? solidEnable = false;
  TextEditingController pinEditingController = TextEditingController(text: '');
  final focusNode = FocusNode();
  String? apiOtp;
  @override
  void initState() {
    super.initState();
    loginOtpController.timer();
    focusNode.requestFocus();
    apiOtp = widget.otpCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const LoginScreen());
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: MyCustomAppBar(
            leading: IconButton(
              onPressed: () {
                log('backpress to otpscreen');
                Get.offAll(() => const LoginScreen());
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
                color: Colors.black,
              ),
            ),
            height: 10.h,
            elevation: 0.5,
            appbarPadding: 0,
            title: Text(
              MessageConstants.VERIFY_PHONE,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 14.sp),
            ).tr(),
            backgroundColor: Colors.grey[100],
          ),
          body: Center(
            child: SizedBox(
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Column(
                  children: [
                    Text(
                      'OTP Send to',
                      style: TextStyle(color: Colors.green, fontSize: 11.sp),
                    ).tr(args: [
                      widget.countryCode.toString(),
                      widget.mobileNumber.toString()
                    ]),
                    SizedBox(height: 3.h),
                    SizedBox(
                      height: 6.h,
                      width: 90.w,
                      child: Pinput(
                        controller: pinEditingController,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        length: 6,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          loginOtpController.smsCode = pin;
                          loginOtpController.update();
                          log('smscode from : ${loginOtpController.smsCode}');
                        },
                        onChanged: (pin) {
                          loginOtpController.smsCode = pin;
                          loginOtpController.update();
                          log('smscode from : ${loginOtpController.smsCode}');
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
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 90.w,
                      child: ElevatedButton(
                        onPressed: () {
                          if (pinEditingController.text.length != 6) {
                            global.showToast(
                              message: "All field required",
                            );
                            return;
                          }
                          if (loginOtpController.maxSecond <= 0) {
                            global.showToast(
                              message: "OTP expired. Please resend OTP.",
                            );
                            return;
                          }
                          log('otp 1 $apiOtp');
                          log('otp 2 ${pinEditingController.text.toString()}');
                          if (apiOtp == pinEditingController.text.toString()) {
                            global.showOnlyLoaderDialog();
                            loginController.loginAstrologer(
                                phoneNumber:
                                    loginOtpController.cMobileNumber.text,
                                email: '');
                          } else {
                            log('otp not mathced ');
                            global.showToast(message: "Invalid OTP");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Get.theme.primaryColor,
                          textStyle:
                              TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        child:  Text(
                          MessageConstants.SUBMIT_CAPITAL,
                          style: TextStyle(color: COLORS().textColor),
                        ).tr(),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    GetBuilder<LoginOtpController>(builder: (c) {
                      return loginOtpController.maxSecond != 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text(
                                    'Resend OTP Available in',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp),
                                  ).tr(args: [
                                    loginOtpController.maxSecond.toString()
                                  ]),
                                )
                              ],
                            )
                          : SizedBox(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Text(
                                      'Resend OTP Available',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp),
                                    ).tr(),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            pinEditingController.text = '';
                                            String phoneNumber =
                                                loginOtpController
                                                    .cMobileNumber.text;

                                            //RESET TIMER
                                            loginOtpController.maxSecond = 0;
                                            loginOtpController.timer();
                                            await verifycontactExistOrNot(
                                                phoneNumber.toString(),
                                                context,
                                                'login');
                                          },
                                          style: ButtonStyle(
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            padding: WidgetStateProperty.all(
                                                const EdgeInsets.only(
                                                    left: 25, right: 25)),
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Get.theme.primaryColor),
                                            textStyle: WidgetStateProperty.all(
                                                const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          child: Text(
                                            'Resend OTP on SMS',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                            ),
                                          ).tr(),
                                        ),
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
      ),
    );
  }

  verifycontactExistOrNot(
      String contactno, BuildContext context, String type) async {
    try {
      global.showOnlyLoaderDialog();
      await apihelper.checkContact(contactno, type).then((response) {
        global.hideLoader();

        dynamic rspnse1 = json.decode(response.body)['status'];
        log('verifycontactExistOrNot response status $rspnse1');
        String msg = jsonDecode(response.body)['message'];

        log('verifycontactExistOrNot response msg $msg');
        if (rspnse1 == 200) {
          String loginotp = jsonDecode(response.body)['otp'];
          apiOtp = loginotp;
          setState(() {});
        } else if (rspnse1 == 400) {
          global.showToast(message: msg);
        }
      });
    } catch (e) {
      print('Exception in verifycontactExistOrNot : - ${e.toString()}');
    }
  }
}
