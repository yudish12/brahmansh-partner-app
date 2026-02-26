// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/Courses/screen/MyCoursesListScreen.dart';
import 'package:brahmanshtalk/controllers/HomeController/chat_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/boostController/profileBoostController.dart';
import 'package:brahmanshtalk/controllers/following_controller.dart';
import 'package:brahmanshtalk/controllers/panchangController.dart';
import 'package:brahmanshtalk/utils/global.dart';
import 'package:brahmanshtalk/views/HomeScreen/Assistant/assistant_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/OfferDiscountsScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/follower_list_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/profileBoost/profileBoostScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/todays_panchang/panchangScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../Courses/screen/coursesScreen.dart';
import '../../../constants/messageConst.dart';
import '../../../controllers/AssistantController/add_assistant_controller.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../controllers/HomeController/astrology_blog_controller.dart';
import '../../../controllers/HomeController/call_controller.dart';
import '../../../controllers/HomeController/home_controller.dart';
import '../../../controllers/HomeController/report_controller.dart';
import '../../../controllers/HomeController/wallet_controller.dart';
import '../../../controllers/dailyHoroscopeController.dart';
import '../../../models/user_model.dart';
import '../../../services/apiHelper.dart';
import '../Drawer/Wallet/Wallet_screen.dart';
import '../Drawer/customer_review_screen.dart';
import '../FloatingButton/AstroBlog/astrology_blog_screen.dart';
import '../FloatingButton/DailyHoroscope/dailyHoroscopeScreen.dart';
import '../FloatingButton/DailyHoroscope/dailyHoroscopeVedic.dart';
import '../FloatingButton/FreeKundli/kundliScreen.dart';
import '../FloatingButton/KundliMatching/kundli_matching_screen.dart';
import '../Report_Module/report_request_screen.dart';
import '../call/hms/hmsLivescreen.dart';
import '../call/zegocloud/zegoLiveScreen.dart';
import '../history/HistroryScreen.dart';
import '../live/live_screen.dart';
import '../poojaModule/mycustompuja.dart';
import '../poojaModule/poojaOrderScreen.dart';
import '../products/productScreen.dart';
import '../tabs/callTab.dart';
import '../tabs/chatTab.dart';
import '../tabs/waitlist_tab.dart';
import '../../../controllers/chatAvailability_controller.dart';
import '../../../controllers/callAvailability_controller.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final signupController = Get.find<SignupController>();
  final walletController = Get.find<WalletController>();
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final reportController = Get.put(ReportController());
  final followingController = Get.put(FollowingController());
  final panchangController = Get.put(PanchangController());
  final profileboostController = Get.find<Profileboostcontroller>();
  final chatAvailabilityController = Get.find<ChatAvailabilityController>();
  final callAvailabilityController = Get.find<CallAvailabilityController>();

  bool isChatOnline = false;
  bool isCallOnline = false;
  bool isVideoCallOnline = false;
  bool isProfileBoostActive = false;

  // Add these status variables
  String chatStatus = "Offline";
  String callStatus = "Offline";
  String videoCallStatus = "Offline";
  String boostStatus = "Inactive";

  @override
  void initState() {
    super.initState();
    _loadInitialStatus();
  }

  /// Load initial chat/call status from global.user
  void _loadInitialStatus() {
    log('loadInitialStatus');
    log('userChatStatus ${global.user.chatStatus}');
    log('userCallStatus ${global.user.callStatus}');
    // Load chat status
    final userChatStatus = global.user.chatStatus ?? "Offline";
    isChatOnline = userChatStatus == "Online";
    chatStatus = userChatStatus;

    // Load call status
    final userCallStatus = global.user.callStatus ?? "Offline";
    isCallOnline = userCallStatus == "Online";
    callStatus = userCallStatus;

    setState(() {
      isChatOnline = userChatStatus == "Online";
      chatStatus = userChatStatus;
      isCallOnline = userCallStatus == "Online";
      callStatus = userCallStatus;
    });
  }

  Widget _availabilityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          _availabilityRow(
              "Chat", "₹17.0/min", isChatOnline, chatStatus, isChatOnline,
              onChanged: (value) async {
            setState(() {
              isChatOnline = value;
              chatStatus = value ? "Online" : "Offline";
            });
            // Call API to update chat status
            await _updateServiceStatus("chat", value);
          }),
          Divider(),
          _availabilityRow(
              "Call", "₹17.0/min", isCallOnline, callStatus, isCallOnline,
              onChanged: (value) async {
            setState(() {
              isCallOnline = value;
              callStatus = value ? "Online" : "Offline";
            });
            // Call API to update call status
            await _updateServiceStatus("call", value);
          }),
          Divider(),
          // _availabilityRow("Video Call", "₹17.0/min", isVideoCallOnline,
          //     videoCallStatus, isVideoCallOnline, onChanged: (value) async {
          //   setState(() {
          //     isVideoCallOnline = value;
          //     videoCallStatus = value ? "Online" : "Offline";
          //   });
          //   // Call API to update video call status
          //   await _updateServiceStatus("video_call", value);
          // }),
        ],
      ),
    );
  }

  Widget _availabilityRow(
      String title, String rate, bool value, String status, bool isOnline,
      {required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        /// SERVICE INFO - Left side
        Expanded(
          flex: 4, // Increased flex for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              // Text(rate, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
            ],
          ),
        ),

        /// SPACER
        SizedBox(width: 2.w),

        /// SWITCH - Center
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Switch(
              value: value,
              activeColor: Colors.green,
              onChanged: onChanged,
            ),
          ),
        ),

        /// SPACER
        SizedBox(width: 2.w),

        /// STATUS CHIP - Right side
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: isOnline ? Colors.green.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9.sp,
                color: isOnline ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateServiceStatus(String serviceType, bool isOnline) async {
    try {
      final statusValue = isOnline ? "Online" : "Offline";
      final astroId = global.user.id;

      if (serviceType == "chat") {
        // Update chat availability using ChatAvailabilityController
        await chatAvailabilityController.statusChatChange(
          astroId: astroId,
          chatStatus: statusValue,
        );
        chatAvailabilityController.setChatAvailability(
          isOnline ? 1 : 2, // 1 = Online, 2 = Offline
          statusValue,
        );
      } else if (serviceType == "call") {
        // Update call availability using CallAvailabilityController
        await callAvailabilityController.statusCallChange(
          astroId: astroId,
          callStatus: statusValue,
        );
        callAvailabilityController.setCallAvailability(
          isOnline ? 1 : 2, // 1 = Online, 2 = Offline
          statusValue,
        );
      } else if (serviceType == "video_call") {
        // Video call uses the same call API (if applicable)
        await callAvailabilityController.statusCallChange(
          astroId: astroId,
          callStatus: statusValue,
        );
      }

      log("Updated $serviceType status to: $statusValue");
    } catch (e) {
      // Revert the state if API fails
      setState(() {
        if (serviceType == "chat") {
          isChatOnline = !isOnline;
          chatStatus = isChatOnline ? "Online" : "Offline";
        } else if (serviceType == "call") {
          isCallOnline = !isOnline;
          callStatus = isCallOnline ? "Online" : "Offline";
        } else if (serviceType == "video_call") {
          isVideoCallOnline = !isOnline;
          videoCallStatus = isVideoCallOnline ? "Online" : "Offline";
        }
      });

      global.showToast(
        message: "Failed to update $serviceType status. Please try again.",
      );

      log("Error updating $serviceType status: $e");
    }
  }

  Widget _earningCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DECEMBER Earning – ₹628.87",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Invoice Acknowledged", style: TextStyle(fontSize: 10.sp)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Check Details",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text("You can check your invoice in settings.",
              style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _todayProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's Progress",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text("Great Job! Stay online to increase your earnings.",
                          style: TextStyle(fontSize: 10.sp)),
                      SizedBox(height: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("Check Performance",
                            style: TextStyle(
                                fontSize: 10.sp, fontWeight: FontWeight.w600)),
                      ),
                    ]),
              ),
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("23h 30m",
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.bold)),
                      Text("Good",
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Availability target based on your past 30 days average availability hours.",
                  style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToBoostScreen() async {
    try {
      // First, load the boost data - use the correct method name
      await profileboostController
          .getBoostDetials(); // Changed from getProfileBoost()

      // Then navigate to the screen
      Get.to(() =>
          Profileboostscreen()); // Note: Profileboostscreen not ProfileBoostScreen
    } catch (e) {
      log("Error loading boost data: $e");
      global.showToast(
        message: "Failed to load boost information. Please try again.",
      );
      // Revert the switch state
      setState(() {
        isVideoCallOnline = false;
        videoCallStatus = "Inactive";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (homeController) => RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                chatController.getChatList(false, isLoading: 0),
                callController.getCallList(false, isLoading: 0),
                reportController.getReportList(false, isLoading: 0),
                followingController.followingList(false, isLoading: 0),
                signupController.astrologerProfileById(false, isLoading: 0),
                walletController.getAmountList(),
              ] as Iterable<Future<dynamic>>);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                children: [
                  /// ---------------- STATUS CARDS ----------------
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        GetBuilder<SignupController>(
                          builder: (ctrl) {
                            // Re-sync toggle state whenever the controller updates
                            if (ctrl.astrologerList.isNotEmpty &&
                                ctrl.astrologerList[0] != null) {
                              final freshChat =
                                  ctrl.astrologerList[0]!.chatStatus ?? "Offline";
                              final freshCall =
                                  ctrl.astrologerList[0]!.callStatus ?? "Offline";
                              isChatOnline = freshChat == "Online";
                              chatStatus = freshChat;
                              isCallOnline = freshCall == "Online";
                              callStatus = freshCall;
                            }
                            return _availabilityCard();
                          },
                        ),
                        // SizedBox(height: 1.5.h),
                        // _earningCard(),
                        // SizedBox(height: 1.5.h),
                        // _todayProgressCard(),
                        SizedBox(height: 1.5.h),

                        /// ---------------- BOOST YOUR PROFILE CARD ----------------
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.amber),
                            color: Colors.amber.shade50,
                          ),
                          child: Row(
                            children: [
                              /// SERVICE INFO - Left side
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Boost Your Profile",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber.shade800)),
                                    Text("Increase visibility & earnings",
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.amber.shade600)),
                                  ],
                                ),
                              ),

                              /// SPACER
                              SizedBox(width: 2.w),

                              /// SWITCH - Center
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Switch(
                                    value: isVideoCallOnline,
                                    activeColor: Colors.amber,
                                    onChanged: (value) async {
                                      setState(() {
                                        isVideoCallOnline = value;
                                        videoCallStatus =
                                            value ? "Active" : "Inactive";
                                      });

                                      if (value) {
                                        // Navigate to ProfileBoostScreen when turned ON
                                        await _navigateToBoostScreen();
                                      } else {
                                        // Call API to deactivate boost
                                        await _updateProfileBoostStatus(false);
                                      }
                                    },
                                  ),
                                ),
                              ),

                              /// SPACER
                              SizedBox(width: 2.w),

                              /// STATUS CHIP - Right side
                              Expanded(
                                flex: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isVideoCallOnline
                                        ? Colors.amber.shade100
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isVideoCallOnline ? "Active" : "Inactive",
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: isVideoCallOnline
                                          ? Colors.amber.shade800
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ---------------- FIRST ROW ----------------
                        _rowWrapper([
                          _homeBtn("Call Request", Colors.orange, Icons.call,
                              onTap: () => Get.to(() => const CallTab()),
                              badge: callController.callList.length),
                          _homeBtn("Chat Request", Colors.green, Icons.chat,
                              onTap: () => Get.to(() => const ChatTab()),
                              badge: chatController.chatList.length),
                          _homeBtn("Astromall", Colors.lightBlue,
                              Icons.shopping_bag_outlined,
                              onTap: () => Get.to(() => Productscreen(
                                  astroId: 0, isFromHomeScreen: true))),
                        ]),

                        /// ---------------- SECOND ROW ----------------
                        _rowWrapper([
                          _homeBtn("Waitlist", Colors.redAccent, null,
                              asset: 'assets/images/free_kundli.png',
                              onTap: () => Get.to(() => const WaitlistTab())),
                          GetBuilder<SignupController>(
                            builder: (signupcontroller) => signupcontroller
                                        .astrologerList.isNotEmpty &&
                                    signupcontroller.astrologerList[0]
                                            ?.isshowlivesections ==
                                        MessageConstants.ISLIVE_ENABLE
                                ? _homeBtn(
                                    "Go Live",
                                    Colors.brown,
                                    null,
                                    asset:
                                        'assets/images/bottombaricons/live.png',
                                    onTap: () async {
                                      await signupController
                                          .astrologerProfileById(false,
                                              isLoading: 0);
                                      LiveBottomSheet.show(
                                        context,
                                        onInstant: () {
                                          log("callmethod is ->  ${signupcontroller.astrologerList[0]?.callmethod}");
                                          liveAstrologerController.isImInLive =
                                              true;
                                          if (signupcontroller.astrologerList[0]
                                                  ?.callmethod ==
                                              "hms") {
                                            Get.to(() => const HMSLiveScreen());
                                          } else if (signupcontroller
                                                  .astrologerList[0]
                                                  ?.callmethod ==
                                              "agora") {
                                            Get.to(() => const LiveScreen());
                                          } else if (signupcontroller
                                                  .astrologerList[0]
                                                  ?.callmethod ==
                                              "zegocloud") {
                                            fetchToken();
                                          }
                                          homeController.update();
                                        },
                                        onLater: (dateTime) async {
                                          homeController.scheduleLiveSession(
                                            dateTime,
                                            signupcontroller
                                                    .astrologerList[0]?.id
                                                    .toString() ??
                                                "",
                                          );
                                          global.showToast(
                                              message:
                                                  "You will be notified When live Started");
                                        },
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ),
                          _homeBtn("Assistant\nChat", Colors.lightGreen, null,
                              asset:
                                  'assets/images/drawericons/assistantrequest.png',
                              onTap: () => Get.to(() => AssistantScreen())),
                        ]),

                        /// ---------------- THIRD ROW ----------------
                        _rowWrapper([
                          _homeBtn("Suggested Remedies", Colors.brown,
                              Icons.shopping_bag_outlined,
                              onTap: () =>
                                  Get.to(() => const MyCustomPujaListScreen())),
                          _homeBtn("My\nCommunity", Colors.pinkAccent,
                              Icons.people_outline,
                              onTap: () => Get.to(() => FollowerListScreen())),
                          _homeBtn("offers", Colors.red, null,
                              asset:
                                  'assets/images/profilescreenicons/reduce-cost.png',
                              onTap: () =>
                                  Get.to(() => const CommissionScreen())),
                        ]),

                        /// ---------------- FOURTH ROW ----------------
                        _rowWrapper([
                          _homeBtn(
                            "Customer\nReview",
                            Colors.pink,
                            null,
                            asset: 'assets/images/drawericons/feedback.png',
                            onTap: () async {
                              signupController.astrologerList.clear();
                              signupController.clearReply();
                              await signupController
                                  .astrologerProfileById(false);
                              signupController.update();
                              Get.to(() => CustomeReviewScreen());
                            },
                          ),
                          _homeBtn(
                              "Wallet\nTransactions", Colors.deepPurple, null,
                              asset: 'assets/images/drawericons/wallet.png',
                              onTap: () async {
                            await walletController.getAmountList();
                            Get.to(() => WalletScreen());
                          }),
                          _homeBtn(
                            "Settings",
                            Colors.purple,
                            null,
                            asset: 'assets/images/drawericons/settings.png',
                            onTap: () async {
                              await signupController
                                  .astrologerProfileById(true);
                              Get.to(() => const HistoryScreen());
                            },
                          ),
                        ]),
                        SizedBox(height: 1.5.h),

                        /// ---------------- LAST ROW ----------------
                        _rowWrapper([
                          _homeBtn("Astrology\nBlog", Colors.orangeAccent, null,
                              asset: 'assets/images/astrology_blog.png',
                              onTap: () => Get.to(() => AstrologyBlogScreen())),
                          _homeBtn("Today's\nPanchang", Colors.red, null,
                              asset: 'assets/images/worship.png',
                              onTap: () =>
                                  Get.to(() => const PanchangScreen())),
                          _homeBtn("Report\nRequest", Get.theme.primaryColor,
                              Icons.picture_as_pdf_outlined,
                              onTap: () => Get.to(() => ReportRequestScreen()),
                              badge: reportController.reportList.length),
                        ]),

                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Add this method for profile boost API
Future<void> _updateProfileBoostStatus(bool isActive) async {
  try {
    if (isActive) {
      // Navigate to ProfileBoostScreen when activated
      Get.to(() => Profileboostscreen());
    }

    // Call your API to update boost status
    // Example:
    // final response = await apiHelper.updateProfileBoostStatus(isActive: isActive);

    global.showToast(
      message:
          isActive ? "Profile boost activated!" : "Profile boost deactivated",
    );

    log("Updated profile boost status to: $isActive");
  } catch (e) {
    global.showToast(
      message: "Failed to update profile boost. Please try again.",
    );

    log("Error updating profile boost status: $e");
  }
}

/// ---------------- REUSABLE HOME BUTTON ----------------
Widget _homeBtn(String title, Color color, IconData? icon,
    {String? asset, int? badge, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: 13.h,
      width: 13.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ICON CIRCLE (PASTEL)
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: asset != null
                  ? Image.asset(asset, height: 22)
                  : Icon(icon, color: color, size: 22),
            ),
          ),

          SizedBox(height: 10),

          /// TITLE
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          /// BADGE (UNCHANGED)
          if (badge != null && badge > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CircleAvatar(
                radius: 9,
                backgroundColor: Colors.red,
                child: Text(
                  badge > 99 ? "99+" : badge.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _rowWrapper(List<Widget> children) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 1.2.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    ),
  );
}

void fetchToken() async {
  sp = await SharedPreferences.getInstance();
  CurrentUser userData = CurrentUser.fromJson(
    json.decode(sp!.getString("currentUser") ?? ""),
  );

  log('zego appid is ${global.getSystemFlagValue(global.systemFlagNameList.zegoAppId)} and zegotoken is ${global.getSystemFlagValue(global.systemFlagNameList.zegoAppSignIn)}');

  await liveAstrologerController.sendLiveToken(
      currentUserId, 'ZegoLive_$currentUserId', '', "");
  global.zegoLiveChannelName = 'ZegoLive_$currentUserId';

  Get.to(() => zegoLiveHostScreen(
        isHost: true,
        username: userData.name,
        userid: userData.id.toString(),
        profile: userData.imagePath,
      ));
}

class LiveBottomSheet {
  static void show(BuildContext context,
      {required Function onInstant,
      required Function(DateTime dateTime) onLater}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 50,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "Go Live",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Would you like to go live instantly or schedule it for later?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onInstant();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Go Live Instantly"),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      final scheduledDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      Navigator.pop(context);
                      onLater(scheduledDateTime);
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Schedule for Later",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}
