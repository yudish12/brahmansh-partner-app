// ignore_for_file: file_names
import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/boostController/profileBoostController.dart';
import 'package:brahmanshtalk/views/HomeScreen/profileBoost/profileBoostHistory.dart';
import 'package:brahmanshtalk/widgets/bounce_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';

class Profileboostscreen extends StatefulWidget {
  const Profileboostscreen({super.key});

  @override
  State<Profileboostscreen> createState() => _ProfileboostscreenState();
}

class _ProfileboostscreenState extends State<Profileboostscreen> {
  bool isChecked = true;
  int selectedOption = 1;
  final profileboostController = Get.find<Profileboostcontroller>();
  final googleTranslator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          GetBuilder<Profileboostcontroller>(builder: (profileboostController) {
        log('boost is ${profileboostController.boostData}');
        return profileboostController.boostData == null
            ? const SizedBox()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 23.h,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12),
                        decoration: BoxDecoration(
                            color: COLORS().primaryColor,
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: [
                                0.1,
                                0.5,
                              ],
                              colors: [
                                Color(0xff22211C),
                                Color(0xff343128),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  blurStyle: BlurStyle.outer)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL BOOST',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                            Text(
                              '${profileboostController.boostData!.remainingBoost}/${profileboostController.boostData!.profileBoost} Per Month',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Colors.amber,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Your Boost duration will be for 24 Hours',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                            SizedBox(
                              height: 2.h,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.amber,
                                          backgroundColor: Get
                                              .theme.primaryColor
                                              .withOpacity(0.38)),
                                      onPressed: () {
                                        Get.dialog(
                                          AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            content: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.purple.shade800,
                                                    Colors.indigo.shade900,
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 20,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Header design
                                                  Container(
                                                    height: 6.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.yellow
                                                                .shade300,
                                                            size: 20.sp,
                                                          ),
                                                          SizedBox(width: 2.w),
                                                          Text(
                                                            'Boost',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'serif',
                                                            ),
                                                          ).tr(),
                                                          SizedBox(width: 2.w),
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.yellow
                                                                .shade300,
                                                            size: 20.sp,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  // Content
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 3.h),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Note section with cosmic warning
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .orange
                                                                  .shade100
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .orange
                                                                    .shade300,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .warning_amber_rounded,
                                                                  color: Colors
                                                                      .orange
                                                                      .shade300,
                                                                  size: 18.sp,
                                                                ),
                                                                SizedBox(
                                                                    width: 3.w),
                                                                Expanded(
                                                                  child: Text(
                                                                    'Note:- Admin will get',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .orange
                                                                          .shade300,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          11.sp,
                                                                    ),
                                                                  ).tr(args: [
                                                                    "${profileboostController.boostData!.chatCommission}%",
                                                                    "${profileboostController.boostData!.callCommission}%"
                                                                  ]),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          SizedBox(height: 3.h),

                                                          // Main message with cosmic theme
                                                          Center(
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .auto_awesome,
                                                                  color: Colors
                                                                      .yellow
                                                                      .shade300,
                                                                  size: 30.sp,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        2.h),
                                                                Text(
                                                                  'Do you want to Boost Your Profile ?',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'serif',
                                                                  ),
                                                                ).tr(),
                                                                SizedBox(
                                                                    height:
                                                                        1.h),
                                                                Text(
                                                                  'Enhance your presence',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ).tr(),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.w,
                                                    vertical: 1.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // No button
                                                    BounceWrapper(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8.w,
                                                                vertical:
                                                                    1.5.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.grey
                                                                  .shade700,
                                                              Colors.grey
                                                                  .shade900,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 16.sp,
                                                            ),
                                                            SizedBox(
                                                                width: 2.w),
                                                            Text(
                                                              'No',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ).tr(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    // Yes button - Cosmic accept
                                                    BounceWrapper(
                                                      onTap: () {
                                                        profileboostController
                                                            .boostProfileScreen();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8.w,
                                                                vertical:
                                                                    1.5.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.green
                                                                  .shade600,
                                                              Colors.green
                                                                  .shade800,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .green
                                                                  .shade800
                                                                  .withOpacity(
                                                                      0.4),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .auto_awesome,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade300,
                                                              size: 16.sp,
                                                            ),
                                                            SizedBox(
                                                                width: 2.w),
                                                            Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ).tr(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'BOOST NOW',
                                      ).tr()),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.amber,
                                          backgroundColor: Get
                                              .theme.primaryColor
                                              .withOpacity(0.38)),
                                      onPressed: () {
                                        profileboostController
                                            .profileBoostHistory();
                                        Get.to(
                                            () => const Profileboosthistory());
                                      },
                                      child: const Text(
                                        'Check History',
                                      ).tr()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Benefits',
                                style: Get.textTheme.bodyMedium!.copyWith(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                              SizedBox(
                                height: 1.h,
                              ),
                              ListView.builder(
                                itemCount: profileboostController
                                    .boostData!.profileBoostBenefits!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.verified_outlined,
                                          color: Colors.green,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder<String>(
                                                  future: googleTranslator
                                                      .translate(
                                                        profileboostController
                                                                .boostData!
                                                                .profileBoostBenefits![
                                                            index],
                                                        to: Get.locale!
                                                            .languageCode,
                                                      )
                                                      .then((value) =>
                                                          value.text),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          profileboostController
                                                                  .boostData!
                                                                  .profileBoostBenefits![
                                                              index]);
                                                    } else {
                                                      return Text(snapshot
                                                              .data ??
                                                          "No translation available");
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  @override
  void dispose() {
    profileboostController.boostData = null;
    super.dispose();
  }

  Future<Translation> getItems(int index) async {
    return await profileboostController.boostData!.profileBoostBenefits![index]
        .translate(to: 'hi');
  }
}
