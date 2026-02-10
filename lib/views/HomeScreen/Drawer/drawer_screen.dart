// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/AssistantController/add_assistant_controller.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/app_review_controller.dart';
import 'package:brahmanshtalk/controllers/customerReview_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/Assistant/assistant_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/AppReview/app_review_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/Setting/setting_list_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/appversionwidget.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/customerSupport/SupportTicketScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/imageConst.dart';
import '../../../controllers/AssistantController/astrologer_assistant_chat_controller.dart';
import '../../../controllers/HomeController/edit_profile_controller.dart';
import '../Assistant/assistant_chat_request_screen.dart';
import '../Profile/edit_profile_screen.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});
  final assistantController = Get.find<AddAssistantController>();
  final customerReviewController = Get.find<CustomerReviewController>();
  final signupController = Get.find<SignupController>();
  final homeController = Get.find<HomeController>();
  final walletController = Get.find<WalletController>();
  final appReviewController = Get.find<AppReviewController>();
  final editProfileController = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
     log('imagepath ${signupController.astrologerList[0]!.imagePath}');
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(120),
                        )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              editProfileController.fillAstrologer(global.user);
                              editProfileController.updateId = global.user.id;
                              Get.to(() => const EditProfileScreen());
                              editProfileController.index = 0;
                              // homeController.isSelectedBottomIcon = 3;
                              // homeController.update();
                              // Navigator.pop(context);
                            },
                            child: signupController.astrologerList.isNotEmpty &&
                                    global.user.imagePath != null &&
                                    global.user.imagePath!.isNotEmpty
                                ? signupController.astrologerList[0]!.imagePath!
                                        .isNotEmpty
                                    ? Container(
                                        height: Get.height * 0.13,
                                        width: Get.width * 0.23,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.white),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                             global.buildImageUrl("${signupController.astrologerList[0]!.imagePath}"),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: Get.height * 0.13,
                                        width: Get.width * 0.23,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              global.buildImageUrl("${global.user.imagePath}")),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                      )
                                : Container(
                                    height: 80,
                                    width: 80,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: COLORS().primaryColor),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 45,
                                      backgroundImage: AssetImage(
                                        IMAGECONST.noCustomerImage,
                                      ),
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  global.user.name != null &&
                                          global.user.name != ''
                                      ? '${global.user.name}'
                                      : "Astrologer",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .displayMedium!
                                      .copyWith(color: COLORS().textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          global.user.countrycode ?? '+91',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color:COLORS().textColor),
                                        ),
                                      ),
                                      Text(
                                        global.user.contactNo != null &&
                                                global.user.contactNo != ''
                                            ? '${global.user.contactNo}'
                                            : "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 10.sp,
                                                color: COLORS().textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Experience_in_years',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontSize: 10.sp, color: COLORS().textColor),
                                ).tr(args: [
                                  global.user.expirenceInYear.toString()
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Image.asset('assets/images/drawericons/review.png',
                          height: 3.h, fit: BoxFit.fill, color: Colors.blue),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "App Review",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 12.sp),
                        ).tr(),
                      ),
                    ],
                  ),
                  onTap: () async {
                    appReviewController.getAppReview();
                    Get.to(() => const AppReviewScreen());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/drawericons/assistantrequest.png',
                        height: 3.h,
                        fit: BoxFit.fill,
                        color: COLORS().primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Assistant Request",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 12.sp),
                        ).tr(),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final astrologerAssistantChatController =
                        Get.find<AstrologerAssistantChatController>();
                    global.showOnlyLoaderDialog();
                    await astrologerAssistantChatController
                        .getAstrologerAssistantChatRequest();
                    global.hideLoader();
                    Get.to(() => const AssistantChatRequestScreen());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/drawericons/call-center.png',
                        height: 3.h,
                        fit: BoxFit.fill,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "My Assistant",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 12.sp),
                        ).tr(),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await assistantController.getAstrologerAssistantList();
                    Get.to(() => AssistantScreen());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/drawericons/customer-support.png',
                        height: 3.h,
                        fit: BoxFit.fill,
                        color: Colors.redAccent,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Customer Support",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 12.sp),
                        ).tr(),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const SupportTicketsScreen());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      SizedBox(
                        child: Image.asset(
                            'assets/images/drawericons/settings.png',
                            height: 3.h,
                            fit: BoxFit.fill,
                            color: Colors.deepOrange),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Settings",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 12.sp),
                        ).tr(),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => SettingListScreen());
                  },
                ),
              ),
              const Spacer(),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
              ),
              SizedBox(
                height: 30.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 1.h),
                    Text(
                      "Also Available On",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                      ),
                    ).tr(),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (!await launchUrl(Uri.parse(
                                global.getSystemFlagValue(
                                    global.systemFlagNameList.facebook)))) {
                              throw Exception(
                                  'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.facebook)}');
                            }
                          },
                          child: Image.asset(
                            "assets/images/facebook.png",
                            fit: BoxFit.cover,
                            height: 30,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.instra) ==
                                ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  if (!await launchUrl(Uri.parse(
                                      global.getSystemFlagValue(
                                          global.systemFlagNameList.instra)))) {
                                    throw Exception(
                                        'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.instra)}');
                                  }
                                },
                                child: Image.asset(
                                  "assets/images/instagram.png",
                                  fit: BoxFit.cover,
                                  height: 30,
                                ),
                              ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.telegram) ==
                                ""
                            ? const SizedBox()
                            : SizedBox(
                                width: 2.w,
                              ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.telegram) ==
                                ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  log('clicked ${global.getSystemFlagValue(global.systemFlagNameList.telegram)}');
                                  if (!await launchUrl(Uri.parse(
                                      global.getSystemFlagValue(global
                                          .systemFlagNameList.telegram)))) {
                                    throw Exception(
                                        'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.telegram)}');
                                  }
                                },
                                child: Image.asset("assets/images/telegram.png",
                                    fit: BoxFit.cover, height: 30),
                              ),
                        SizedBox(
                          width: 2.w,
                        ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.linkedin) ==
                                ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  log('clicked ${global.getSystemFlagValue(global.systemFlagNameList.linkedin)}');
                                  if (!await launchUrl(Uri.parse(
                                      global.getSystemFlagValue(global
                                          .systemFlagNameList.linkedin)))) {
                                    throw Exception(
                                        'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.linkedin)}');
                                  }
                                },
                                child: Image.asset("assets/images/linkedin.png",
                                    fit: BoxFit.cover, height: 30),
                              ),
                        SizedBox(
                          width: 2.w,
                        ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.youtube) ==
                                ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  if (!await launchUrl(Uri.parse(
                                      global.getSystemFlagValue(global
                                          .systemFlagNameList.youtube)))) {
                                    throw Exception(
                                        'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.youtube)}');
                                  }
                                },
                                child: Image.asset("assets/images/youtube.png",
                                    fit: BoxFit.fitHeight, height: 30),
                              ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.twitter) ==
                                ""
                            ? const SizedBox()
                            : SizedBox(
                                width: 2.w,
                              ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.twitter) ==
                                ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  if (!await launchUrl(Uri.parse(
                                      global.getSystemFlagValue(global
                                          .systemFlagNameList.twitter)))) {
                                    throw Exception(
                                        'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.twitter)}');
                                  }
                                },
                                child: Image.asset("assets/images/twitter.png",
                                    fit: BoxFit.fitHeight, height: 30),
                              ),
                        SizedBox(
                          width: 2.w,
                        ),
                        global.getSystemFlagValue(
                                    global.systemFlagNameList.whatsapp) ==
                                ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  if (!await launchUrl(Uri.parse(
                                      global.getSystemFlagValue(global
                                          .systemFlagNameList.whatsapp)))) {
                                    throw Exception(
                                        'Could not launch ${global.getSystemFlagValue(global.systemFlagNameList.whatsapp)}');
                                  }
                                },
                                child: Image.asset("assets/images/whatsapp.png",
                                    fit: BoxFit.fitHeight, height: 30),
                              ),
                        SizedBox(
                          width: 2.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    const AppVersionWidget(),
                    const SizedBox(height: 4),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
