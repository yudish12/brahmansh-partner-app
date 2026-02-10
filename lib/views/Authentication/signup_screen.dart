// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_otp_controller.dart';
import 'package:brahmanshtalk/models/time_availability_model.dart';
import 'package:brahmanshtalk/models/week_model.dart';
import 'package:brahmanshtalk/views/Authentication/login_screen.dart';
import 'package:brahmanshtalk/views/Authentication/sigupSteps/signup_stepthree.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'sigupSteps/signup_stepfive.dart';
import 'sigupSteps/signup_stepfour.dart';
import 'sigupSteps/signup_stepone.dart';
import 'sigupSteps/signup_stepsix.dart';
import 'sigupSteps/signup_steptwo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signupController = Get.find<SignupController>();
  final signupOtpController = Get.find<SignupOtpController>();
  Map<String, dynamic>? dataResponse;
  var loaderVisibility = true;
  final urlTextContoller = TextEditingController();

  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getdocumentsDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const LoginScreen());
        return true;
      },
      child: SafeArea(
        child: GetBuilder<SignupController>(
            init: signupController,
            builder: (controller) {
              return Scaffold(
                appBar:
                    Platform.isIOS ? const MyCustomAppBar(height: 80) : null,
                backgroundColor: Colors.grey[200],
                body: Column(
                  children: [
                    signupController.index == 0
                        ? Expanded(
                            child: SignupStepOne(
                                signupController: signupController))
                        : const SizedBox(),
                    signupController.index == 1
                        ? Expanded(
                            child: SignupStepTwo(
                                signupController: signupController))
                        : const SizedBox(),
                    signupController.index == 2
                        ? Expanded(
                            child: SignupthreeWidget(
                              signupController: signupController,
                            ),
                          )
                        : const SizedBox(),
                    signupController.index == 3
                        ? Expanded(
                            child: SignupStepFour(
                                signupController: signupController))
                        : const SizedBox(),
                    signupController.index == 4
                        ? Expanded(
                            child: SignupStepFive(
                                signupController: signupController))
                        : const SizedBox(),
                    signupController.index == 5
                        ? Expanded(
                            child: SignupStepSix(
                                signupController: signupController))
                        : const SizedBox(),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: signupController.index == 0
                      ? TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: COLORS().primaryColor,
                            maximumSize:
                                Size(MediaQuery.of(context).size.width, 100),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 48),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            debugPrint('0');

                            // signupController.onStepNext();
                            signupController.validateForm(
                              0,
                              countrycode: signupController.countryCode,
                            );
                          },
                          child: const Text(
                            MessageConstants.GET_OTP,
                            style: TextStyle(color: Colors.white),
                          ).tr(),
                        )
                      : signupController.index == 1
                          ? TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: COLORS().primaryColor,
                                maximumSize: Size(
                                    MediaQuery.of(context).size.width, 100),
                                minimumSize:
                                    Size(MediaQuery.of(context).size.width, 48),
                              ),
                              onPressed: () {
                                debugPrint('1');

                                FocusScope.of(context).unfocus();
                                signupController.selectedImage == null
                                    ? global.showToast(
                                        message: 'Please add profile pic first')
                                    : signupController.validateForm(1);
                              },
                              child: const Text(
                                MessageConstants.NEXT,
                                style: TextStyle(color: Colors.white),
                              ).tr(),
                            )
                          : signupController.index == 2 ||
                                  signupController.index == 3 ||
                                  signupController.index == 4 ||
                                  signupController.index == 5
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              COLORS().primaryColor,
                                          maximumSize: Size(
                                              MediaQuery.of(context).size.width,
                                              100),
                                          minimumSize: Size(
                                              MediaQuery.of(context).size.width,
                                              48),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          signupController.onStepBack();
                                        },
                                        child: const Text(
                                          MessageConstants.BACK,
                                          style: TextStyle(color: Colors.white),
                                        ).tr(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              COLORS().primaryColor,
                                          maximumSize: Size(
                                              MediaQuery.of(context).size.width,
                                              100),
                                          minimumSize: Size(
                                              MediaQuery.of(context).size.width,
                                              48),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if (signupController.index == 2) {
                                            signupController.validateForm(2);
                                          } else if (signupController.index ==
                                              3) {
                                            signupController.validateForm(3,
                                                context: context);
                                            signupController.week = [];
                                            signupController.week!.add(Week(
                                                day: "Sunday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.week!.add(Week(
                                                day: "Monday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.week!.add(Week(
                                                day: "Tuesday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.week!.add(Week(
                                                day: "Wednesday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.week!.add(Week(
                                                day: "Thursday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.week!.add(Week(
                                                day: "Friday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.week!.add(Week(
                                                day: "Saturday",
                                                timeAvailabilityList: [
                                                  TimeAvailabilityModel(
                                                      fromTime: "", toTime: "")
                                                ]));
                                            signupController.update();
                                          } else if (signupController.index ==
                                              4) {
                                            signupController.validateForm(4);
                                          }
                                          if (signupController.index == 5) {
                                            signupController.validateForm(5);
                                          }
                                        },
                                        child: Text(
                                          signupController.index != 5
                                              ? MessageConstants.NEXT
                                              : MessageConstants.SUBMIT_CAPITAL,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ).tr(),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                ),
              );
            }),
      ),
    );
  }

  void getdocumentsDetails() async {
    await signupController.getdocumentsDetail();
  }
}
