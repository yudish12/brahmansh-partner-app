// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../constants/imageConst.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../controllers/HomeController/chat_controller.dart';
import '../../../controllers/HomeController/home_controller.dart';
import '../../../controllers/HomeController/productController.dart';
import '../../../controllers/HomeController/wallet_controller.dart';
import '../../../widgets/wallet_history_screen.dart';
import '../Report_Module/report_history_list_screen.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../call_detail_screen.dart';
import '../chat/chat_screen.dart';
import '../home_screen.dart';
import '../poojaModule/poojaOrderScreen.dart';
import '../products/productScreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final homeController = Get.find<HomeController>();
  final chatController = Get.find<ChatController>();
  final walletController = Get.find<WalletController>();
  final productController = Get.find<Productcontroller>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "History",
          style: Get.theme.primaryTextTheme.titleLarge!
              .copyWith(color: COLORS().textColor),
        ),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: COLORS().textColor),
          onPressed: () {
            Get.off(() => HomeScreen());
          },
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (homeController) => DefaultTabController(
          length: 4,
          initialIndex: homeController.homeTabIndex,
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        spreadRadius: 0.2,
                        blurRadius: 0.2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    controller: homeController.historyTabController,
                    onTap: (index) {
                      homeController.onHistoryTabBarIndexChanged(index);
                    },
                    indicatorColor: COLORS().primaryColor,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    unselectedLabelColor: COLORS().bodyTextColor,
                    labelColor: Colors.black,
                    tabs: [
                      Text(
                        'Wallet',
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ).tr(),
                      Text(
                        'Puja',
                        style: TextStyle(
                          fontSize: 11.sp,
                        ),
                      ).tr(),
                      Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 11.sp,
                        ),
                      ).tr(),
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 11.sp,
                        ),
                      ).tr(),
                      Text(
                        'Report',
                        style: TextStyle(
                          fontSize: 11.sp,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: homeController.historyTabController,
                  children: [
                    //First Tabbar
                    const WalletHistoryScreen(),
                    //poojaOrder screen
                    const PoojaOrderScreen(showAppbar: false),

                    //Second Tabbar history of call
                    GetBuilder<SignupController>(
                      builder: (signupController) {
                        return signupController.astrologerList.isEmpty
                            ? SizedBox(
                                child: Center(
                                  child: const Text('Please Wait!!!!').tr(),
                                ),
                              )
                            : signupController
                                    .astrologerList[0]!.callHistory!.isEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 10, bottom: 200),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                COLORS().primaryColor,
                                          ),
                                          onPressed: () async {
                                            signupController.astrologerList
                                                .clear();
                                            await signupController
                                                .astrologerProfileById(false);
                                            signupController.update();
                                          },
                                          child: const Icon(
                                            Icons.refresh_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: const Text(
                                                  'No call history is here')
                                              .tr()),
                                    ],
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      await signupController
                                          .astrologerProfileById(false);
                                      signupController.update();
                                    },
                                    child: ListView.builder(
                                      itemCount: signupController
                                              .astrologerList.isNotEmpty
                                          ? signupController.astrologerList[0]!
                                                  .callHistory?.length ??
                                              0
                                          : 0,
                                      controller: signupController
                                          .callHistoryScrollController,
                                      physics: const ClampingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (signupController
                                                  .astrologerList.isNotEmpty) {
                                                Get.to(() => CallDetailScreen(
                                                      callHistorydata:
                                                          signupController
                                                                  .astrologerList[
                                                                      0]!
                                                                  .callHistory![
                                                              index],
                                                    ));
                                              }
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(2.w),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 6,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '#00${signupController.astrologerList[0]!.callHistory![index].id.toString()}s',
                                                                  style: Get
                                                                      .theme
                                                                      .primaryTextTheme
                                                                      .titleSmall,
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5.0),
                                                              child: Text(
                                                                signupController.astrologerList[0]!.callHistory![index].name !=
                                                                            null ||
                                                                        signupController
                                                                            .astrologerList[
                                                                                0]!
                                                                            .callHistory![
                                                                                index]
                                                                            .name
                                                                            .toString()
                                                                            .isNotEmpty
                                                                    ? signupController
                                                                        .astrologerList[
                                                                            0]!
                                                                        .callHistory![
                                                                            index]
                                                                        .name
                                                                        .toString()
                                                                    : "User",
                                                                style: Get
                                                                    .theme
                                                                    .primaryTextTheme
                                                                    .displaySmall,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    DateFormat(
                                                                            'dd MMM yyyy , hh:mm a')
                                                                        .format(
                                                                            DateTime.parse(
                                                                      signupController
                                                                          .astrologerList[
                                                                              0]!
                                                                          .callHistory![
                                                                              index]
                                                                          .createdAt
                                                                          .toString(),
                                                                    )),
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .titleMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5.0),
                                                              child: Text(
                                                                signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .callHistory![
                                                                        index]
                                                                    .callStatus!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Rate : ",
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .titleSmall,
                                                                  ).tr(),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      if (!global
                                                                          .isCoinWallet())
                                                                        Text(
                                                                          '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                                          style: Get
                                                                              .theme
                                                                              .primaryTextTheme
                                                                              .titleSmall,
                                                                        )
                                                                      else
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 4),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                global.getSystemFlagValue(global.systemFlagNameList.coinIcon),
                                                                            height:
                                                                                16,
                                                                            width:
                                                                                16,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      Text(
                                                                        '${signupController.astrologerList[0]!.callHistory![index].callRate} /min',
                                                                        style: Get
                                                                            .theme
                                                                            .primaryTextTheme
                                                                            .titleSmall,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 2.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Duration : ",
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .titleSmall,
                                                                  ).tr(),
                                                                  Text(
                                                                    signupController.astrologerList[0]!.callHistory![index].totalMin !=
                                                                                null &&
                                                                            signupController.astrologerList[0]!.callHistory![index].totalMin!.isNotEmpty
                                                                        ? "${signupController.astrologerList[0]!.callHistory![index].totalMin} min"
                                                                        : "0 min",
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .titleSmall,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 2.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Deduction : ",
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .titleSmall,
                                                                  ).tr(),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      if (!global
                                                                          .isCoinWallet())
                                                                        Text(
                                                                          "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ",
                                                                          style: Get
                                                                              .theme
                                                                              .primaryTextTheme
                                                                              .titleSmall,
                                                                        )
                                                                      else
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 4),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                global.getSystemFlagValue(global.systemFlagNameList.coinIcon),
                                                                            height:
                                                                                16,
                                                                            width:
                                                                                16,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      Text(
                                                                        "${signupController.astrologerList[0]!.callHistory![index].deduction}",
                                                                        style: Get
                                                                            .theme
                                                                            .primaryTextTheme
                                                                            .titleSmall,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                          minimumSize: Size(
                                                                              30
                                                                                  .w,
                                                                              10
                                                                                  .w),
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 2
                                                                                  .w),
                                                                          backgroundColor: Get
                                                                              .theme
                                                                              .primaryColor
                                                                              .withOpacity(
                                                                                  0.2),
                                                                          side: BorderSide(
                                                                              width: 0.5,
                                                                              color: Get.theme.primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.w))),
                                                                      onPressed: () {
                                                                        productController
                                                                            .getProductList();
                                                                        Get.to(() =>
                                                                            Productscreen(
                                                                              userid: signupController.astrologerList[0]!.callHistory![index].userId!,
                                                                              astroId: signupController.astrologerList[0]!.callHistory![index].userId!,
                                                                            ));
                                                                      },
                                                                      child: Text(
                                                                        'Share Remedy',
                                                                        style: Get
                                                                            .theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                                color: Get.theme.primaryColor,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 10.sp),
                                                                      )),
                                                                ],
                                                              ),
                                                              Container(
                                                                height: 75,
                                                                width: 75,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            50),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade100,
                                                                  image: signupController.astrologerList[0]!.callHistory![index].profile !=
                                                                              null &&
                                                                          signupController
                                                                              .astrologerList[
                                                                                  0]!
                                                                              .callHistory![
                                                                                  index]
                                                                              .profile!
                                                                              .isNotEmpty
                                                                      ? DecorationImage(
                                                                          scale:
                                                                              8,
                                                                          image:
                                                                              CachedNetworkImageProvider(
                                                                            "${signupController.astrologerList[0]!.callHistory![index].profile}",
                                                                          ))
                                                                      : const DecorationImage(
                                                                          scale:
                                                                              8,
                                                                          image:
                                                                              AssetImage(
                                                                            IMAGECONST.noCustomerImage,
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                signupController.isMoreDataAvailable ==
                                                            true &&
                                                        !signupController
                                                            .isAllDataLoaded &&
                                                        signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .callHistory!
                                                                    .length -
                                                                1 ==
                                                            index
                                                    ? const CircularProgressIndicator()
                                                    : const SizedBox(),
                                                index ==
                                                        signupController
                                                                .astrologerList[
                                                                    0]!
                                                                .callHistory!
                                                                .length -
                                                            1
                                                    ? const SizedBox(
                                                        height: 20,
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                      },
                    ),

                    //Third tabbar history if chat
                    GetBuilder<SignupController>(
                      builder: (signupController) {
                        return signupController.astrologerList.isEmpty
                            ? SizedBox(
                                child: Center(
                                  child: const Text('Please Wait!!!!').tr(),
                                ),
                              )
                            : signupController
                                    .astrologerList[0]!.chatHistory!.isEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 10, bottom: 200),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                COLORS().primaryColor,
                                          ),
                                          onPressed: () async {
                                            signupController.astrologerList
                                                .clear();
                                            await signupController
                                                .astrologerProfileById(false);
                                            signupController.update();
                                          },
                                          child: const Icon(
                                            Icons.refresh_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: const Text(
                                                  'No chat history is here')
                                              .tr()),
                                    ],
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      debugPrint('click refresh chat');
                                      await signupController
                                          .astrologerProfileById(false);
                                      signupController.update();
                                      getwalletamountlist();
                                    },
                                    child: ListView.builder(
                                      itemCount: signupController
                                          .astrologerList[0]!
                                          .chatHistory
                                          ?.length,
                                      controller: signupController
                                          .chatHistoryScrollController,
                                      physics: const ClampingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            int duration = (chatController
                                                        .chatList.isEmpty ||
                                                    chatController
                                                            .chatList[index]
                                                            .chatDuration ==
                                                        null)
                                                ? 0
                                                : int.parse(chatController
                                                    .chatList[index]
                                                    .chatDuration!);

                                            Get.to(
                                              () => ChatScreen(
                                                chatHistoryData:
                                                    signupController
                                                        .astrologerList[0]!
                                                        .chatHistory![index],
                                                flagId: 2,
                                                customerName: signupController
                                                    .astrologerList[0]!
                                                    .chatHistory![index]
                                                    .name!,
                                                customerProfile:
                                                    signupController
                                                        .astrologerList[0]!
                                                        .chatHistory![index]
                                                        .profile!,
                                                customerId: signupController
                                                    .astrologerList[0]!
                                                    .chatHistory![index]
                                                    .id!, //cutomer id here
                                                fireBasechatId: signupController
                                                    .astrologerList[0]!
                                                    .chatHistory![index]
                                                    .chatId!, //firebase chat id
                                                chatId: signupController
                                                    .astrologerList[0]!
                                                    .chatHistory![index]
                                                    .chatId!, //chat id
                                                astrologerId: signupController
                                                    .astrologerList[0]!
                                                    .chatHistory![index]
                                                    .astrologerId!,
                                                astrologerName: signupController
                                                    .astrologerList[0]!
                                                    .chatHistory![index]
                                                    .astrologerName!,
                                                chatduration: duration,
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: width,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          top: 8,
                                                          right: 8,
                                                          bottom: 10),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 6,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '#00${signupController.astrologerList[0]!.chatHistory![index].id.toString()}',
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .titleSmall,
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            5.0),
                                                                child: Text(
                                                                  signupController.astrologerList[0]!.chatHistory![index].name !=
                                                                              null &&
                                                                          signupController
                                                                              .astrologerList[
                                                                                  0]!
                                                                              .chatHistory![
                                                                                  index]
                                                                              .name!
                                                                              .isNotEmpty
                                                                      ? signupController
                                                                          .astrologerList[
                                                                              0]!
                                                                          .chatHistory![
                                                                              index]
                                                                          .name!
                                                                      : "User",
                                                                  style: Get
                                                                      .theme
                                                                      .primaryTextTheme
                                                                      .displaySmall,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            5.0),
                                                                child: Text(
                                                                  (() {
                                                                    try {
                                                                      final chathistory = signupController
                                                                          .astrologerList[
                                                                              0]!
                                                                          .chatHistory;

                                                                      // Check if callHistory is not null and index is within range
                                                                      if (chathistory ==
                                                                              null ||
                                                                          chathistory
                                                                              .isEmpty ||
                                                                          index >=
                                                                              chathistory.length) {
                                                                        return 'Date not available'; // Fallback for missing data
                                                                      }

                                                                      final createdAt =
                                                                          chathistory[index]
                                                                              .createdAt;

                                                                      // Ensure createdAt is not null or empty
                                                                      if (createdAt ==
                                                                          null) {
                                                                        return 'Date not available';
                                                                      }

                                                                      // Parse the date safely
                                                                      final parsedDate =
                                                                          DateTime.parse(
                                                                              createdAt.toString());

                                                                      // Format the parsed date
                                                                      return DateFormat(
                                                                              'dd MMM yyyy, hh:mm a')
                                                                          .format(
                                                                              parsedDate);
                                                                    } catch (e) {
                                                                      // Handle any parsing or unexpected errors
                                                                      return 'Invalid date format';
                                                                    }
                                                                  })(),
                                                                  style: Get
                                                                      .theme
                                                                      .primaryTextTheme
                                                                      .titleMedium,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            5.0),
                                                                child: Text(
                                                                  signupController
                                                                      .astrologerList[
                                                                          0]!
                                                                      .chatHistory![
                                                                          index]
                                                                      .chatStatus!,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            5.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Rate : ",
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .titleSmall,
                                                                    ).tr(),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        if (!global
                                                                            .isCoinWallet())
                                                                          Text(
                                                                            "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ",
                                                                            style:
                                                                                Get.theme.primaryTextTheme.titleSmall,
                                                                          )
                                                                        else
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 4),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: global.getSystemFlagValue(global.systemFlagNameList.coinIcon),
                                                                              height: 16,
                                                                              width: 16,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        Text(
                                                                          "${signupController.astrologerList[0]!.chatHistory![index].chatRate ?? 0} /min",
                                                                          style: Get
                                                                              .theme
                                                                              .primaryTextTheme
                                                                              .titleSmall,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            2.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Duration : ",
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .titleSmall,
                                                                    ).tr(),
                                                                    Text(
                                                                      signupController.astrologerList[0]!.chatHistory![index].totalMin != null &&
                                                                              signupController.astrologerList[0]!.chatHistory![index].totalMin!.isNotEmpty
                                                                          ? "${signupController.astrologerList[0]!.chatHistory![index].totalMin} min"
                                                                          : "0 min",
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .titleSmall,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            2.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Deduction : ",
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .titleSmall,
                                                                    ).tr(),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        if (!global
                                                                            .isCoinWallet())
                                                                          Text(
                                                                            "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ",
                                                                            style:
                                                                                Get.theme.primaryTextTheme.titleSmall,
                                                                          )
                                                                        else
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 4),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: global.getSystemFlagValue(global.systemFlagNameList.coinIcon),
                                                                              height: 16,
                                                                              width: 16,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        Text(
                                                                          "${signupController.astrologerList[0]!.chatHistory![index].deduction ?? 0}",
                                                                          style: Get
                                                                              .theme
                                                                              .primaryTextTheme
                                                                              .titleSmall,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              OutlinedButton(
                                                                  style: OutlinedButton.styleFrom(
                                                                      minimumSize: Size(
                                                                          30.w,
                                                                          10.w),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 2
                                                                              .w),
                                                                      backgroundColor: Get
                                                                          .theme
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              0.2),
                                                                      side: BorderSide(
                                                                          width:
                                                                              0.5,
                                                                          color: Get
                                                                              .theme
                                                                              .primaryColor),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.w))),
                                                                  onPressed: () async {
                                                                    await productController
                                                                        .getProductList();
                                                                    await Get.find<
                                                                            Productcontroller>()
                                                                        .getCustomPujaList();
                                                                    Get.to(() =>
                                                                        Productscreen(
                                                                          userid: signupController
                                                                              .astrologerList[0]!
                                                                              .chatHistory![index]
                                                                              .userId!,
                                                                          astroId: signupController
                                                                              .astrologerList[0]!
                                                                              .chatHistory![index]
                                                                              .userId!,
                                                                        ));
                                                                  },
                                                                  child: Text(
                                                                    'Share Remedy',
                                                                    style: Get.theme.textTheme.bodySmall!.copyWith(
                                                                        color: Get
                                                                            .theme
                                                                            .primaryColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            10.sp),
                                                                  )),

                                                              // InkWell(
                                                              //   onTap: () async{
                                                              //     //
                                                              //   await  productController
                                                              //         .getProductList();
                                                              //   await  Get.find<
                                                              //             Productcontroller>()
                                                              //         .getCustomPujaList();
                                                              //     Get.to(() =>
                                                              //         Productscreen(
                                                              //           userid: signupController
                                                              //               .astrologerList[
                                                              //                   0]!
                                                              //               .callHistory![
                                                              //                   index]
                                                              //               .userId!,
                                                              //           astroId: signupController
                                                              //               .astrologerList[
                                                              //                   0]!
                                                              //               .callHistory![
                                                              //                   index]
                                                              //               .userId!,
                                                              //         ));
                                                              //   },
                                                              //   child: SizedBox(
                                                              //       height: 4.h,
                                                              //       width: 4.h,
                                                              //       child: Icon(
                                                              //         Icons
                                                              //             .recommend_outlined,
                                                              //         size: 22.sp,
                                                              //         color: Colors
                                                              //             .green,
                                                              //       )),
                                                              // ),
                                                              Container(
                                                                height: 75,
                                                                width: 75,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            50),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade100,
                                                                  image: signupController.astrologerList[0]!.chatHistory![index].profile !=
                                                                              null &&
                                                                          signupController
                                                                              .astrologerList[
                                                                                  0]!
                                                                              .chatHistory![
                                                                                  index]
                                                                              .profile!
                                                                              .isNotEmpty
                                                                      ? DecorationImage(
                                                                          scale:
                                                                              8,
                                                                          image:
                                                                              CachedNetworkImageProvider(
                                                                            "${signupController.astrologerList[0]!.chatHistory![index].profile}",
                                                                          ))
                                                                      : const DecorationImage(
                                                                          scale:
                                                                              8,
                                                                          image:
                                                                              AssetImage(
                                                                            IMAGECONST.noCustomerImage,
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                signupController.isMoreDataAvailable ==
                                                            true &&
                                                        !signupController
                                                            .isAllDataLoaded &&
                                                        signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .chatHistory!
                                                                    .length -
                                                                1 ==
                                                            index
                                                    ? const CircularProgressIndicator()
                                                    : const SizedBox(),
                                                index ==
                                                        signupController
                                                                .astrologerList[
                                                                    0]!
                                                                .chatHistory!
                                                                .length -
                                                            1
                                                    ? const SizedBox(
                                                        height: 20,
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                      },
                    ),

                    //Fifth Tabbar
                    const ReportHistoryListScreen(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getwalletamountlist() async {
    await walletController.getAmountList();
    walletController.update();
  }
}
