// ignore_for_file: unrelated_type_equality_checks, unused_element

import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/constants/messageConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/edit_profile_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/language_list_model.dart';
import 'package:brahmanshtalk/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/CustomStepper.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/StepperConfig.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/stepperwidget/step_one.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/stepperwidget/step_six.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/stepperwidget/step_two.dart';
import 'package:brahmanshtalk/widgets/common_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'stepperwidget/step_Five.dart';
import 'stepperwidget/step_four.dart';
import 'stepperwidget/step_three.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final editProfileController = Get.put(EditProfileController());
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    getdocumentsDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<EditProfileController>(
          init: editProfileController,
          builder: (controller) {
            return WillPopScope(
              onWillPop: () {
                log('backpress');
                return Future.value(false);
              },
              child: Scaffold(
                backgroundColor: Colors.grey[200],
                body: Column(
                  children: [
                    editProfileController.index == 0
                        ? Expanded(
                            child: CommonPadding(
                              child: Column(
                                children: [
                                  // For Page 0 (Personal Details)
                                  CustomStepper(
                                    currentIndex: editProfileController.index,
                                    stepTitle: StepperConfig
                                        .stepConfigs[0]!['title'] as String,
                                    stepIcon: StepperConfig
                                        .stepConfigs[0]!['icon'] as IconData,
                                    stepLabels:
                                        StepperConfig.stepConfigs[0]!['labels']
                                            as List<String>,
                                  ),
                                  // Personal Details Form
                                  StepOneWidget(
                                      editProfileController:
                                          editProfileController),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 1
                        ? Expanded(
                            child: CommonPadding(
                              child: Column(
                                children: [
                                  // For Page 1 (Skills & Profile)
                                  CustomStepper(
                                    currentIndex: editProfileController.index,
                                    stepTitle: StepperConfig
                                        .stepConfigs[1]!['title'] as String,
                                    stepIcon: StepperConfig
                                        .stepConfigs[1]!['icon'] as IconData,
                                    stepLabels:
                                        StepperConfig.stepConfigs[1]!['labels']
                                            as List<String>,
                                  ),
                                  // Skills Details Form
                                  StepTwoWidget(
                                      editProfileController:
                                          editProfileController),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 2
                        ? Expanded(
                            child: CommonPadding(
                              child: Column(
                                children: [
                                  // For Page 2 (Language Details)
                                  CustomStepper(
                                    currentIndex: editProfileController.index,
                                    stepTitle: StepperConfig
                                        .stepConfigs[2]!['title'] as String,
                                    stepIcon: StepperConfig
                                        .stepConfigs[2]!['icon'] as IconData,
                                    stepLabels:
                                        StepperConfig.stepConfigs[2]!['labels']
                                            as List<String>,
                                  ),
                                  // Other Details Form
                                  StepThreeWidget(
                                      editProfileController:
                                          editProfileController),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 3
                        ? Expanded(
                            child: CommonPadding(
                              child: Column(
                                children: [
                                  // For Page 2 (Language Details)
                                  CustomStepper(
                                    currentIndex: editProfileController.index,
                                    stepTitle: StepperConfig
                                        .stepConfigs[3]!['title'] as String,
                                    stepIcon: StepperConfig
                                        .stepConfigs[3]!['icon'] as IconData,
                                    stepLabels:
                                        StepperConfig.stepConfigs[3]!['labels']
                                            as List<String>,
                                  ),

                                  // Experience & Scenarios Form
                                  StepFourWidget(
                                      editProfileController:
                                          editProfileController),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 4
                        ? Expanded(
                            child: CommonPadding(
                              child: Column(
                                children: [
                                  // For Page 2 (Language Details)
                                  CustomStepper(
                                    currentIndex: editProfileController.index,
                                    stepTitle: StepperConfig
                                        .stepConfigs[4]!['title'] as String,
                                    stepIcon: StepperConfig
                                        .stepConfigs[4]!['icon'] as IconData,
                                    stepLabels:
                                        StepperConfig.stepConfigs[4]!['labels']
                                            as List<String>,
                                  ),
                                  // Document Upload Section
                                  StepFiveWidget(
                                      editProfileController:
                                          editProfileController),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 5
                        ? StepSixWidget(
                            editProfileController: editProfileController)
                        : const SizedBox(),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: editProfileController.index == 0
                      ? Row(
                          children: [
                            GetBuilder<SignupController>(
                              builder: (signupController) => Expanded(
                                flex: 4,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: COLORS().primaryColor,
                                    maximumSize: Size(
                                        MediaQuery.of(context).size.width, 100),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width, 48),
                                  ),
                                  onPressed: () {
                                    // homeController.isSelectedBottomIcon = 1;
                                    // homeController.update();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    MessageConstants.BACK,
                                    style: TextStyle(color: Colors.white),
                                  ).tr(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 4,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: COLORS().primaryColor,
                                  maximumSize: Size(
                                      MediaQuery.of(context).size.width, 100),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 48),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  editProfileController.updateValidateForm(0);
                                },
                                child: const Text(
                                  MessageConstants.NEXT,
                                  style: TextStyle(color: Colors.white),
                                ).tr(),
                              ),
                            ),
                          ],
                        )
                      : editProfileController.index == 1
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: COLORS().primaryColor,
                                      maximumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          100),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          48),
                                    ),
                                    onPressed: () {
                                      editProfileController.userFile = null;
                                      editProfileController.profile = '';
                                      FocusScope.of(context).unfocus();
                                      editProfileController.onStepBack();
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
                                      backgroundColor: COLORS().primaryColor,
                                      maximumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          100),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          48),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (editProfileController.index == 1) {
                                        editProfileController
                                            .updateValidateForm(1);
                                      }
                                    },
                                    child: const Text(
                                      MessageConstants.NEXT,
                                      style: TextStyle(color: Colors.white),
                                    ).tr(),
                                  ),
                                ),
                              ],
                            )
                          : editProfileController.index == 2 ||
                                  editProfileController.index == 3 ||
                                  editProfileController.index == 4 ||
                                  editProfileController.index == 5
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
                                          editProfileController.onStepBack();
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
                                          log('index clicked is ${editProfileController.index}');
                                          if (editProfileController.index ==
                                              2) {
                                            editProfileController
                                                .updateValidateForm(2);
                                          } else if (editProfileController
                                                  .index ==
                                              3) {
                                            editProfileController
                                                .updateValidateForm(3,
                                                    context: context);
                                            editProfileController.update();
                                          } else if (editProfileController
                                                  .index ==
                                              4) {
                                            editProfileController
                                                .updateValidateForm(4);
                                          } else if (editProfileController
                                                  .index ==
                                              5) {
                                            //Astrologer category
                                            global.user.astrologerCategoryId =
                                                [];
                                            editProfileController
                                                .cSelectCategory.text = "";
                                            for (int i = 0;
                                                i <
                                                    global
                                                        .astrologerCategoryModelList!
                                                        .length;
                                                i++) {
                                              if (global
                                                      .astrologerCategoryModelList![
                                                          i]
                                                      .isCheck ==
                                                  true) {
                                                editProfileController
                                                        .cSelectCategory.text +=
                                                    "${global.astrologerCategoryModelList![i].name},";
                                              }
                                              if (i ==
                                                  global.astrologerCategoryModelList!
                                                          .length -
                                                      1) {
                                                editProfileController
                                                        .cSelectCategory.text =
                                                    editProfileController
                                                        .cSelectCategory.text
                                                        .substring(
                                                            0,
                                                            editProfileController
                                                                    .cSelectCategory
                                                                    .text
                                                                    .length -
                                                                1); //remove last ","
                                              }
                                              editProfileController.astroId =
                                                  global
                                                      .astrologerCategoryModelList!
                                                      .where((element) =>
                                                          element.isCheck ==
                                                          true)
                                                      .toList();
                                            }
                                            for (int j = 0;
                                                j <
                                                    editProfileController
                                                        .astroId.length;
                                                j++) {
                                              global.user.astrologerCategoryId!
                                                  .add(AstrolgoerCategoryModel(
                                                      id: editProfileController
                                                          .astroId[j].id));
                                            }
                                            editProfileController.update();
                                            //primary skill
                                            global.user.primarySkillId = [];
                                            editProfileController
                                                .cPrimarySkill.text = "";
                                            for (int i = 0;
                                                i <
                                                    global
                                                        .skillModelList!.length;
                                                i++) {
                                              if (global.skillModelList![i]
                                                      .isCheck ==
                                                  true) {
                                                editProfileController
                                                        .cPrimarySkill.text +=
                                                    "${global.skillModelList![i].name},";
                                              }
                                              if (i ==
                                                  global.skillModelList!
                                                          .length -
                                                      1) {
                                                editProfileController
                                                        .cPrimarySkill.text =
                                                    editProfileController
                                                        .cPrimarySkill.text
                                                        .substring(
                                                            0,
                                                            editProfileController
                                                                    .cPrimarySkill
                                                                    .text
                                                                    .length -
                                                                1); //remove last ","
                                              }
                                              editProfileController.primaryId =
                                                  global.skillModelList!
                                                      .where((element) =>
                                                          element.isCheck ==
                                                          true)
                                                      .toList();
                                            }
                                            for (int j = 0;
                                                j <
                                                    editProfileController
                                                        .primaryId.length;
                                                j++) {
                                              global.user.primarySkillId!.add(
                                                  PrimarySkillModel(
                                                      id: editProfileController
                                                          .primaryId[j].id!));
                                            }
                                            editProfileController.update();
                                            //all skill
                                            global.user.allSkillId = [];
                                            editProfileController
                                                .cAllSkill.text = "";
                                            for (int i = 0;
                                                i <
                                                    global.allSkillModelList!
                                                        .length;
                                                i++) {
                                              if (global.allSkillModelList![i]
                                                      .isCheck ==
                                                  true) {
                                                editProfileController
                                                        .cAllSkill.text +=
                                                    "${global.allSkillModelList![i].name},";
                                              }
                                              if (i ==
                                                  global.allSkillModelList!
                                                          .length -
                                                      1) {
                                                editProfileController
                                                        .cAllSkill.text =
                                                    editProfileController
                                                        .cAllSkill.text
                                                        .substring(
                                                            0,
                                                            editProfileController
                                                                    .cAllSkill
                                                                    .text
                                                                    .length -
                                                                1); //remove last ","
                                              }
                                              editProfileController.allId =
                                                  global.allSkillModelList!
                                                      .where(
                                                          (element) =>
                                                              element.isCheck ==
                                                              true)
                                                      .toList();
                                            }
                                            for (int j = 0;
                                                j <
                                                    editProfileController
                                                        .allId.length;
                                                j++) {
                                              global.user.allSkillId!.add(
                                                  AllSkillModel(
                                                      id: editProfileController
                                                          .allId[j].id!));
                                            }
                                            editProfileController.update();
                                            //language
                                            global.user.languageId = [];
                                            editProfileController
                                                .cLanguage.text = "";
                                            for (int i = 0;
                                                i <
                                                    global.languageModelList!
                                                        .length;
                                                i++) {
                                              if (global.languageModelList![i]
                                                      .isCheck ==
                                                  true) {
                                                editProfileController
                                                        .cLanguage.text +=
                                                    "${global.languageModelList![i].name},";
                                              }
                                              if (i ==
                                                  global.languageModelList!
                                                          .length -
                                                      1) {
                                                editProfileController
                                                        .cLanguage.text =
                                                    editProfileController
                                                        .cLanguage.text
                                                        .substring(
                                                            0,
                                                            editProfileController
                                                                    .cLanguage
                                                                    .text
                                                                    .length -
                                                                1); //remove last ","
                                              }
                                              editProfileController.lId = global
                                                  .languageModelList!
                                                  .where((element) =>
                                                      element.isCheck == true)
                                                  .toList();
                                            }
                                            for (int j = 0;
                                                j <
                                                    editProfileController
                                                        .lId.length;
                                                j++) {
                                              global.user.languageId!.add(
                                                  LanguageModel(
                                                      id: editProfileController
                                                          .lId[j].id!));
                                            }
                                            editProfileController.update();
                                            editProfileController
                                                .updateValidateForm(5);
                                          }
                                        },
                                        child: Text(
                                          editProfileController.index != 5
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
              ),
            );
          }),
    );
  }

  void getdocumentsDetails() async {
    await editProfileController.getdocumentsDetail();
  }
}
