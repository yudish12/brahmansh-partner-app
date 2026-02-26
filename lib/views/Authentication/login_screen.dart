// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_print
import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/login_controller.dart';
import 'package:brahmanshtalk/controllers/Authentication/login_otp_controller.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/models/time_availability_model.dart';
import 'package:brahmanshtalk/models/week_model.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/utils/config.dart';
import 'package:brahmanshtalk/views/Authentication/OtpScreens/login_otp_screen.dart';
import 'package:brahmanshtalk/views/Authentication/signup_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

final initialPhone = PhoneNumber(isoCode: "IN");
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final signupController = Get.put(SignupController());
  final loginController = Get.put(LoginController());
  final loginOtpController = Get.put(LoginOtpController());
  final apiHelper = APIHelper();
  bool isInitIos = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        Get.back();
        SystemNavigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 1.h),
                      // App Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/app_icon.jpeg',
                          height: 20.h,
                          width: 20.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // Welcome Text
                      Text(
                        'Welcome to Astrologer',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
              ),

              // Form Section
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 1.h),

                          // Phone Number Input
                          _buildphoneNumberWidget(loginOtpController),

                          SizedBox(height: 1.h),

                          // Send OTP Button
                          Container(
                            height: 6.5.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  COLORS().primaryColor,
                                  Colors.orange[700]!,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: COLORS().primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  if (loginOtpController
                                          .cMobileNumber.text.length ==
                                      10) {
                                    if (loginOtpController.cMobileNumber.text
                                            .toString() ==
                                        '9898989898') {
                                      Get.to(() => LoginOtpScreen(
                                            mobileNumber: '9898989898',
                                            otpCode: '111111',
                                            countryCode: '+91',
                                          ));
                                    } else {
                                      await loginController
                                          .checkcontactExistOrNot(
                                              loginOtpController
                                                  .cMobileNumber.text
                                                  .toString(),
                                              context,
                                              'login');
                                    }
                                  } else {
                                    global.showToast(
                                        message:
                                            tr('Please enter mobile number'));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SEND_OTP',
                                      style: TextStyle(
                                        color:  COLORS().textColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).tr(),
                                    SizedBox(width: 2.w),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: COLORS().textColor,
                                      size: 18.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.withOpacity(0.4),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(
                                  "or Continue with",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).tr(),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.withOpacity(0.4),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Google Sign In Button
                          Container(
                            height: 6.5.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  final userCredential =
                                      await loginController.signInWithGoogle();
                                  log('userCredential ${userCredential?.user?.displayName}');
                                  if (userCredential != null) {
                                    final user = userCredential.user;
                                    final emailid = user?.email;
                                    await loginController.loginAstrologer(
                                        phoneNumber: '', email: emailid);
                                  } else {}
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/gmail.png",
                                      height: 3.h,
                                      width: 3.h,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Continue with Gmail',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Terms & Conditions
                          GetBuilder<LoginController>(
                              builder: (loginController) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: '${loginController.signupText} ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10.sp,
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: loginController.termsConditionText,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 10.sp,
                                        color: COLORS().primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrl(
                                              Uri.parse(termsconditionurl));
                                          print("Terms and condition");
                                        },
                                    ),
                                    TextSpan(
                                      text: ' ${loginController.andText} ',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: loginController.privacyPolicyText,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 10.sp,
                                        color: COLORS().primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrl(Uri.parse(privacyUrl));
                                          print("Privacy policy");
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      // Sign Up Section
                      Column(
                        children: [
                          Divider(
                            color: Colors.grey.withOpacity(0.3),
                            thickness: 1,
                          ),
                          SizedBox(height: 1.h),
                          InkWell(
                            onTap: () {
                              signupController.week = [];
                              signupController.week!.add(
                                  Week(day: "Sunday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.week!.add(
                                  Week(day: "Monday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.week!.add(
                                  Week(day: "Tuesday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.week!.add(
                                  Week(day: "Wednesday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.week!.add(
                                  Week(day: "Thursday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.week!.add(
                                  Week(day: "Friday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.week!.add(
                                  Week(day: "Saturday", timeAvailabilityList: [
                                TimeAvailabilityModel(fromTime: "", toTime: "")
                              ]));
                              signupController.clearAstrologer();
                              Get.to(() => SignupScreen(),
                                  routeName: "Signup Screen");
                            },
                            child: GetBuilder<LoginController>(
                                builder: (loginController) {
                              return RichText(
                                text: TextSpan(
                                  text: loginController.notaAccountText,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.sp,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: " ${tr("signUp")}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: COLORS().primaryColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildphoneNumberWidget(LoginOtpController loginController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InternationalPhoneNumberInput(
        spaceBetweenSelectorAndTextField: 0,
        maxLength: 10,
        scrollPadding: EdgeInsets.zero,
        textFieldController: loginController.cMobileNumber,
        inputDecoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.w)),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 2.5.h),
          hintText: tr('Enter phone number'),
          hintStyle: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.grey[500],
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          counterText: "",
        ),
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: SelectorConfig(
          trailingSpace: false,
          leadingPadding: 2,
          selectorType: PhoneInputSelectorType.DROPDOWN,
          setSelectorButtonAsPrefixIcon: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        searchBoxDecoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.w)),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.w)),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          hintText: tr("Search country"),
          hintStyle: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.grey[500],
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        initialValue: initialPhone,
        formatInput: false,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: false),
        inputBorder: InputBorder.none,
        onSaved: (PhoneNumber number) {
          print('On Saved: ${number.dialCode}');
          loginController.updateCountryCode(number.dialCode);
          loginOtpController.update();
        },
        onFieldSubmitted: (value) {
          print('On onFieldSubmitted: $value');
        },
        onInputChanged: (PhoneNumber number) {
          print('On onInputChanged: ${number.dialCode}');
          loginController.updateCountryCode(number.dialCode);
          loginOtpController.update();
        },
        onSubmit: () {
          print('On onSubmit:');
        },
      ),
    );
  }
}
