// ignore_for_file: must_be_immutable

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/Report_Module/report_history_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/imageConst.dart';

class ReportHistoryListScreen extends StatefulWidget {
  const ReportHistoryListScreen({super.key});

  @override
  State<ReportHistoryListScreen> createState() =>
      _ReportHistoryListScreenState();
}

class _ReportHistoryListScreenState extends State<ReportHistoryListScreen> {
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SignupController>(
      builder: (controller) {
        return signupController.astrologerList.isEmpty
            ? SizedBox(
                child: Center(
                  child: const Text('Please Wait!!!!').tr(),
                ),
              )
            : signupController.astrologerList[0]!.reportHistory!.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 10, bottom: 200),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: COLORS().primaryColor,
                          ),
                          onPressed: () async {
                            signupController.astrologerList.clear();
                            await signupController.astrologerProfileById(false);
                            signupController.update();
                          },
                          child: const Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                          child: const Text('No report history is here').tr()),
                    ],
                  )
                : GetBuilder<SignupController>(
                    builder: (signupController) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          signupController.astrologerList.clear();
                          await signupController.astrologerProfileById(false);
                          signupController.update();
                        },
                        child: ListView.builder(
                          itemCount: signupController
                              .astrologerList[0]!.reportHistory!.length,
                          controller:
                              signupController.reportHistoryScrollController,
                          physics: const ClampingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ReportHistoryDetailScreen(
                                      reportHistoryData: signupController
                                          .astrologerList[0]!
                                          .reportHistory![index],
                                    ));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 1.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.w),
                                      border: Border.all(
                                          width: 0.3, color: Colors.grey),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                child: signupController
                                                            .astrologerList[0]!
                                                            .reportHistory![
                                                                index]
                                                            .reportImage ==
                                                        ""
                                                    ? Image.asset(
                                                        "assets/images/2022Image.png",
                                                        height: 180,
                                                        width: Get.width,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            '${signupController.astrologerList[0]!.reportHistory![index].reportImage}',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 180,
                                                          width: Get.width,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image:
                                                                  imageProvider,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "assets/images/2022Image.png",
                                                          height: 180,
                                                          width: Get.width,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.w),
                                                      color: Colors.black
                                                          .withOpacity(0.5)),
                                                  child: Text(
                                                    signupController
                                                        .astrologerList[0]!
                                                        .reportHistory![index]
                                                        .reportType
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12.sp),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    color: COLORS().whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.w),
                                                    image: signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .reportHistory![
                                                                        index]
                                                                    .profile ==
                                                                "" ||
                                                            signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .reportHistory![
                                                                        index]
                                                                    .profile ==
                                                                null
                                                        ? const DecorationImage(
                                                            scale: 8,
                                                            image: AssetImage(
                                                              IMAGECONST
                                                                  .noCustomerImage,
                                                            ),
                                                          )
                                                        : DecorationImage(
                                                            image: NetworkImage(
                                                              '${signupController.astrologerList[0]!.reportHistory![index].profile}',
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.person,
                                                              color: COLORS()
                                                                  .primaryColor,
                                                              size: 20,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: Text(
                                                                signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .reportHistory![
                                                                        index]
                                                                    .firstName!,
                                                                style: Get
                                                                    .theme
                                                                    .primaryTextTheme
                                                                    .displaySmall,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_month_outlined,
                                                                color: COLORS()
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  DateFormat('dd-MM-yyyy').format(DateTime.parse(signupController
                                                                      .astrologerList[
                                                                          0]!
                                                                      .reportHistory![
                                                                          index]
                                                                      .birthDate
                                                                      .toString())),
                                                                  style: Get
                                                                      .theme
                                                                      .primaryTextTheme
                                                                      .titleSmall,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        signupController
                                                                    .astrologerList[
                                                                        0]!
                                                                    .reportHistory![
                                                                        index]
                                                                    .birthTime !=
                                                                null
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .schedule_outlined,
                                                                      color: COLORS()
                                                                          .primaryColor,
                                                                      size: 20,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        signupController
                                                                            .astrologerList[0]!
                                                                            .reportHistory![index]
                                                                            .birthTime!,
                                                                        style: Get
                                                                            .theme
                                                                            .primaryTextTheme
                                                                            .titleSmall,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  signupController.isMoreDataAvailable ==
                                              true &&
                                          !signupController.isAllDataLoaded &&
                                          signupController.astrologerList[0]!
                                                      .reportHistory!.length -
                                                  1 ==
                                              index
                                      ? const CircularProgressIndicator()
                                      : const SizedBox(),
                                  index ==
                                          signupController.astrologerList[0]!
                                                  .reportHistory!.length -
                                              1
                                      ? const SizedBox(
                                          height: 20,
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
      },
    );
  }
}
