// ignore_for_file: must_be_immutable, unnecessary_null_comparison, avoid_print, prefer_typing_uninitialized_variables, deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/AssistantController/add_assistant_controller.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/HistoryController/call_history_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/chat_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/edit_profile_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/home_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/live_astrologer_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/HomeController/report_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/boostController/profileBoostController.dart';
import 'package:brahmanshtalk/controllers/following_controller.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/controllers/networkController.dart';
import 'package:brahmanshtalk/controllers/notification_controller.dart';
import 'package:brahmanshtalk/utils/foreground_task_handler.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/drawer_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/edit_profile_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/profile_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/MovableRejoinBanner.dart';
import 'package:brahmanshtalk/views/HomeScreen/history/HistroryScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/notification_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/products/productScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/profileBoost/MainHomeScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/profileBoost/profileBoostScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/tabs/languageScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/voice_test_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController/call_controller.dart';
import '../../controllers/dailyHoroscopeController.dart';
import '../../controllers/splashController.dart';
import '../../controllers/storiescontroller.dart';
import '../../services/apiHelper.dart';

class HomeScreen extends StatefulWidget {
  int isId;
  HomeScreen({super.key, this.isId = 0});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final callHistoryController = Get.find<CallHistoryController>();
  final reportController = Get.find<ReportController>();
  final signupController = Get.find<SignupController>();
  final walletController = Get.find<WalletController>();
  final followingController = Get.find<FollowingController>();
  final storycontroller = Get.find<StoriesController>();
  final editProfileController = Get.put(EditProfileController());
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final notificationController = Get.find<NotificationController>();
  final networkController = Get.find<NetworkController>();
  final homeController = Get.find<HomeController>();
  final splashController = Get.find<SplashController>();
  final productController = Get.find<Productcontroller>();
  final kundlicontroller = Get.find<KundliController>();
  final dailyhoroscopeController = Get.find<DailyHoroscopeController>();
  final apiHelper = APIHelper();
  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;
  Color selectedColor = Colors.grey.shade500;
  Color unselectedColor = Colors.blueGrey;
  int previousposition = 0;
  final assistantController = Get.find<AddAssistantController>();
  final profileboostController = Get.put(Profileboostcontroller());
  final scrollController1 = ScrollController();
  final scrollController2 = ScrollController();
  final scrollController3 = ScrollController();
  final scrollController4 = ScrollController();
  final scrollController5 = ScrollController();

  @override
  void initState() {
    super.initState();
    log('wiget id ${widget.isId}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ForegroundServiceManager.checkAndRequestPermissions();
      getwalletamountlist();
      notificationController.notificationList.clear();
      notificationController.getNotificationList(false);
      if (global.isCallTimerStarted == true) {
        widget.isId != 0
            ? Future.delayed(const Duration(seconds: 3), () {
                print("isInpopscren ${widget.isId}");
                global.isCallTimerStarted = false;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 12.h,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/interrogation-mark.png',
                                height: 7.h,
                              )),
                        ),
                      ),
                      actions: <Widget>[
                        Text('Do you want to Recommend a Product ?',
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp, fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 3.w),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Yes'),
                              onPressed: () async {
                                Get.back();
                                await productController.getProductList();
                                productController.update();
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  Get.to(() =>
                                      Productscreen(astroId: widget.isId));
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              })
            : null;
      } else {
        log('already run ');
      }
    });
    Get.find<CallController>().callListTimer?.cancel();
  }

  // Widget _buildRateCard({
  //   required IconData icon,
  //   required String label,
  //   required String rate,
  //   required String status,
  //   required bool? isOnline,
  // }) {
  //   return Expanded(
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 0.5.w),
  //       padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade50,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: Colors.grey.shade200),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 icon,
  //                 size: 16,
  //                 color: Colors.grey.shade700,
  //               ),
  //               SizedBox(width: 1.5.w),
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   color: Colors.grey.shade700,
  //                   fontSize: 10.sp,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 0.3.h),
  //           Text(
  //             rate,
  //             style: TextStyle(
  //               color: COLORS().blackColor,
  //               fontSize: 11.sp,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           SizedBox(height: 0.3.h),
  //           if (isOnline != null)
  //             Row(
  //               children: [
  //                 Container(
  //                   width: 6,
  //                   height: 6,
  //                   decoration: BoxDecoration(
  //                     color: isOnline ? Colors.green : Colors.red,
  //                     shape: BoxShape.circle,
  //                   ),
  //                 ),
  //                 SizedBox(width: 1.w),
  //                 Expanded(
  //                   child: Text(
  //                     status,
  //                     style: TextStyle(
  //                       color: isOnline ? Colors.green : Colors.red,
  //                       fontSize: 8.sp,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //               ],
  //             )
  //           else
  //             Text(
  //               status,
  //               style: TextStyle(
  //                 color: Colors.grey.shade600,
  //                 fontSize: 8.sp,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GetBuilder<HomeController>(builder: (homeController) {
        return WillPopScope(
            onWillPop: () async {
              bool isExit = false;
              if (homeController.isSelectedBottomIcon == 1) {
                isExit = await homeController.onBackPressed();
                log('homescreen back press $isExit');
                if (isExit) {
                  log('homescreen back press true');
                  exit(0);
                }
              } else if (homeController.isSelectedBottomIcon == 2) {
                log('homescreen back press ${homeController.isSelectedBottomIcon}');

                global.showToast(
                    message: tr(
                        'You must end the call to exit the live streaming session.'));
              } else {
                log('homescreen back 1 ${homeController.isSelectedBottomIcon}');
                homeController.isSelectedBottomIcon = 1;
                homeController.update();
              }
              return isExit;
            },
            child: GetBuilder<SignupController>(
              builder: (signupController) => Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(
                      homeController.isSelectedBottomIcon == 1
                          ? kToolbarHeight +
                              0.h // Adjusted height for the new dashboard
                          : kToolbarHeight),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.white,
                          iconTheme: IconThemeData(color: COLORS().blackColor),
                          title: homeController.isSelectedBottomIcon == 4
                              ? Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  global.buildImageUrl("${signupController.astrologerList[0]!.imagePath}")
                                      ,
                                  height: 36,
                                  width: 36,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  global.user.name ?? "Astrologer",
                                  style: Get.theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: COLORS().blackColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                              : Text(
                            'Hi ${global.user.name.toString()}',
                            style: Get.theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: COLORS().blackColor,
                            ),
                          ).tr(),
                          actions: [
                            if (homeController.isSelectedBottomIcon == 1) ...[
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Get.to(() => const VoiceTestScreen()),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Icon(Icons.mic, color: COLORS().blackColor, size: 24),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      homeController.lan = [];
                                      await homeController.getLanguages();
                                      await homeController.updateLanIndex();
                                      print(homeController.lan);
                                      Get.to(() => LanguageScreen());
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      child: ImageIcon(
                                        AssetImage(
                                          'assets/images/translation.png',
                                        ),
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Stack(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            notificationController
                                                .notificationList
                                                .clear();
                                            notificationController
                                                .getNotificationList(false);
                                            log('notification in homescreen');
                                            Get.to(() =>
                                                const NotificationScreen());
                                          },
                                          icon: const Icon(
                                              Icons.notifications_outlined),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: 5,
                                          child: GetBuilder<
                                              NotificationController>(
                                            builder: (notificationController) {
                                              return notificationController
                                                      .notificationList
                                                      .isNotEmpty
                                                  ? InkWell(
                                                      onTap: () {
                                                        notificationController
                                                            .notificationList
                                                            .clear();
                                                        notificationController
                                                            .getNotificationList(
                                                                false);
                                                        log('notification in homescreen 2');
                                                        Get.to(() =>
                                                            const NotificationScreen());
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 16,
                                                          minHeight: 16,
                                                        ),
                                                        child: Text(
                                                          '${notificationController.notificationList.length}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GetBuilder<WalletController>(
                                    builder: (walletController) {
                                      return GestureDetector(
                                        onTap: () async {
                                          await walletController
                                              .getAmountList();
                                          Get.to(() => WalletScreen());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(1, 1, 3.w, 1),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (global.isCoinWallet())
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 4.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: global
                                                              .getSystemFlagValue(
                                                            global
                                                                .systemFlagNameList
                                                                .coinIcon,
                                                          ),
                                                          height: 18,
                                                          width: 18,
                                                        ),
                                                      )
                                                    else
                                                      Text(
                                                        '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                        style: Get
                                                            .theme
                                                            .primaryTextTheme
                                                            .displaySmall,
                                                      ),
                                                  ],
                                                ),
                                                Text(
                                                  walletController.withdraw
                                                              .walletAmount !=
                                                          null
                                                      ? walletController
                                                          .withdraw
                                                          .walletAmount!
                                                          .toString()
                                                          .split(".")
                                                          .first
                                                      : " 0",
                                                  style: Get
                                                      .theme
                                                      .primaryTextTheme
                                                      .displaySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ] else if (homeController.isSelectedBottomIcon ==
                                3) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: IconButton(
                                  onPressed: () {
                                    editProfileController
                                        .fillAstrologer(global.user);
                                    editProfileController.updateId =
                                        global.user.id;
                                    Get.to(() => const EditProfileScreen());
                                    editProfileController.index = 0;
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                drawer: DrawerScreen(),
                body: Stack(
                  children: [
                    GetBuilder<HomeController>(
                      builder: (homeController) => Column(
                        children: [
                          Expanded(
                            child: PersistentTabView(
                              decoration: NavBarDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              context,
                              controller: homeController.pcontroller,
                              screens: [
                                const MainHomeScreen(),
                                WalletScreen(),
                                const HistoryScreen(),
                                NotificationScreen(),
                                const ProfileScreen(),
                              ],
                              items: _navBarsItems(),
                              onItemSelected: (value) async {
                                log('on itme selected is $value');
                                if (value == 0) {
                                  homeController.isSelectedBottomIcon = 1;
                                  homeController.update();
                                }
                                if (value == 1) {
                                  homeController.isSelectedBottomIcon = 2;
                                  homeController.update();
                                }
                                if (value == 2) {
                                  homeController.isSelectedBottomIcon = 3;
                                  homeController.update();
                                  await profileboostController
                                      .getBoostDetials();
                                }
                                if (value == 3) {
                                  homeController.isSelectedBottomIcon = 3;
                                  homeController.update();
                                  await profileboostController
                                      .getBoostDetials();
                                } else if (value == 4) {
                                  print("onselect profile tab");
                                  followingController.followerList.clear();
                                  followingController.update();
                                  await followingController
                                      .followingList(false);
                                  await storycontroller.getAstroStory(
                                      signupController.astrologerList[0]!.id
                                          .toString());
                                  homeController.isSelectedBottomIcon = 4;
                                  followingController.update();
                                  // signupController.astrologerList.clear();
                                  // await signupController
                                  //     .astrologerProfileById(false);
                                  // signupController.update();
                                  homeController.update();
                                }
                              },
                              backgroundColor: Colors.white,
                              hideNavigationBarWhenKeyboardAppears: true,
                              padding: const EdgeInsets.only(top: 8),
                              isVisible: true,
                              animationSettings: const NavBarAnimationSettings(
                                navBarItemAnimation: ItemAnimationSettings(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.ease,
                                ),
                                screenTransitionAnimation:
                                    ScreenTransitionAnimationSettings(
                                  animateTabTransition: true,
                                  duration: Duration(milliseconds: 200),
                                  screenTransitionAnimationType:
                                      ScreenTransitionAnimationType.fadeIn,
                                ),
                              ),
                              confineToSafeArea: true,
                              navBarStyle: NavBarStyle.style15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Movable banner
                    const MovableRejoinBanner(),
                  ],
                ),
              ),
            ));
      }),
    );
  }

  void setLocale(Locale nLocale) {
    context.setLocale(nLocale);
    Get.updateLocale(nLocale);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: tr("Home"),
          opacity: 0.9,
          activeColorPrimary: Colors.grey,
          activeColorSecondary: COLORS().primaryColor,
          scrollController: scrollController1,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.account_balance_wallet), // Wallet icon
          title: tr("Wallet"),
          opacity: 0.9,
          activeColorPrimary: Colors.grey,
          activeColorSecondary: COLORS().primaryColor,
          scrollController: scrollController4,
        ),
        // PersistentBottomNavBarItem(
        //   icon: Stack(
        //     alignment: Alignment.center,
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           color: COLORS().primaryColor.withOpacity(0.9),
        //           shape: BoxShape.circle,
        //         ),
        //         child: const Icon(
        //           Icons.rocket,
        //           color: Colors.white,
        //           size: 30,
        //         ),
        //       ),
        //     ],
        //   ),
        //   title: tr("Boost"),
        //   opacity: 0.9,
        //   activeColorPrimary: COLORS().primaryColor,
        //   activeColorSecondary: Colors.white,
        //   scrollController: scrollController3,
        //   scrollToTopOnNavBarItemPress: true,
        // ),
        PersistentBottomNavBarItem(
          icon: Image.asset(
            'assets/images/bottombaricons/history.png',
          ),
          title: tr("Orders"),
          opacity: 0.9,
          activeColorPrimary: Colors.grey,
          activeColorSecondary: COLORS().primaryColor,
          scrollController: scrollController2,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.notifications_outlined),
          title: tr("Notice"),
          opacity: 0.9,
          activeColorPrimary: Colors.grey,
          activeColorSecondary: COLORS().primaryColor,
          scrollController: scrollController2,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(FontAwesomeIcons.user),
          title: tr("Profile"),
          opacity: 0.9,
          activeColorPrimary: Colors.grey,
          activeColorSecondary: COLORS().primaryColor,
          scrollController: scrollController5,
        ),
      ];

  void getwalletamountlist() async {
    Future.wait<void>([
      dailyhoroscopeController.getHororScopeSignData(),
      walletController.withdrawWalletAmount(),
      walletController.getAmountList()
      // chatController.getChatList(false),
      // callController.getCallList(false),
      // reportController.getReportList(false),
      // followingController.followingList(false),
      // signupController.astrologerProfileById(false),
      // liveAstrologerController.endLiveSession(true),
      // walletController.getAmountList(),
    ]);
    walletController.update();
  }
}
