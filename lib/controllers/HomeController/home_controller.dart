// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:brahmanshtalk/controllers/HomeController/call_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/chat_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/report_controller.dart';
import 'package:brahmanshtalk/controllers/HomeController/wallet_controller.dart';
import 'package:brahmanshtalk/controllers/following_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/language.dart';
import '../../services/apiHelper.dart';
import '../../utils/constantskeys.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  String screen = 'home_controller.dart';
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final reportController = Get.find<ReportController>();
  final walletController = Get.find<WalletController>();
  final followingController = Get.find<FollowingController>();
  int? notificationHandlingremoteUID = 0;
  getOnlineAstro(val) {
    notificationHandlingremoteUID = val;
    log('is online homecontroller check-$notificationHandlingremoteUID');

    update();
  }

  int selectedItemPosition = 0;
  int previousposition = 0;
  bool? offlineSwitch;

  //Scroll  controller
  ScrollController chatScrollController = ScrollController();
  ScrollController callScrollController = ScrollController();
  ScrollController reportScrollController = ScrollController();
  ScrollController followingScrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0; //! WORK HERE
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isChatMoreDataAvailable = false;
  bool isCallMoreDataAvailable = false;
  bool isReportMoreDataAvailable = false;
  bool isFollowerMoreDataAvailable = false;
  TabController? historyTabController;
  TabController? tabController;
  final pcontroller = PersistentTabController(initialIndex: 0);

  List<Language> lan = [];
  APIHelper apiHelper = APIHelper();

  @override
  onInit() {
    init();
    historyTabController = TabController(length: 5, vsync: this);
    tabController = TabController(length: 3, vsync: this);

    super.onInit();
  }

  init() async {
    await walletController.getAmountList();
    paginateTask();
  }

  void paginateTask() {
    chatScrollController.addListener(() async {
      if (chatScrollController.position.pixels ==
              chatScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isChatMoreDataAvailable = true;
        print('scroll my following');
        update();
        await chatController.getChatList(true);
      }
    });
    callScrollController.addListener(() async {
      if (callScrollController.position.pixels ==
              callScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isCallMoreDataAvailable = true;
        print('scroll my following');
        update();
        await callController.getCallList(true);
      }
    });
    reportScrollController.addListener(() async {
      if (reportScrollController.position.pixels ==
              reportScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isReportMoreDataAvailable = true;
        print('scroll my following');
        update();
        await callController.getCallList(true);
      }
    });
    followingScrollController.addListener(() async {
      if (followingScrollController.position.pixels ==
              followingScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isFollowerMoreDataAvailable = true;
        print('scroll my following');
        update();
        await followingController.followingList(true);
      }
    });
  }

//Home Tabs
  int homeTabIndex = 0.obs();

//Histroey Tabs
  int historyCurrentIndex = 0;
  int historyTabIndex = 0.obs();

  onHistoryTabBarIndexChanged(value) {
    print("History tab change");
    print("$value");
    historyTabIndex = value;
    update();
  }

//Extras
  int? currentPage;
  int totalPage = 3;
//Bottom
  int isSelectedBottomIcon = 1.obs();
  bool isSelected = false;

  DateTime? currentBackPressTime;
  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      global.showToast(message: tr("Press again to exit"));
      return Future.value(false);
    }
    return Future.value(true);
  }

  int selectedIndex = 0;
  updateLan(int index) {
    selectedIndex = index;
    lan[index].isSelected = true;
    update();
    for (int i = 0; i < lan.length; i++) {
      if (i == index) {
        continue;
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    update();
  }

  updateLanIndex() async {
    global.spLanguage = await SharedPreferences.getInstance();
    var currentLan =
        global.spLanguage!.getString(ConstantsKeys.CURRENTLANGUAGE) ?? 'en';
    for (int i = 0; i < lan.length; i++) {
      if (lan[i].lanCode == currentLan) {
        selectedIndex = i;
        lan[i].isSelected = true;
        update();
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    print(selectedIndex);
  }

  Future<void> scheduleLiveSession(
      DateTime dateTime, String astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper
              .scheduleLive(
            dateTime: dateTime,
            astrologerId: astrologerId,
          )
              .then((result) {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(message: "Live scheduled successfully!");
            } else {
              global.showToast(message: "${result.message}");
            }
          });
        }
      });
    } catch (e) {
      print("Exception in scheduleLiveSession: $e");
    }
  }

  getLanguages() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          lan.clear(); // Clear existing languages
          lan.addAll(staticLanguageList); // Add static languages
          update();
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- $e");
    }
  }
}
