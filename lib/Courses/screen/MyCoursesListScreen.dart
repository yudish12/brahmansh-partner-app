// ignore_for_file: file_names, unrelated_type_equality_checks

import 'dart:developer';
import 'package:brahmanshtalk/Courses/screen/mycoursedetailscreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:sizer/sizer.dart';
import '../controller/courseController.dart';

class MyCoursesListScreen extends StatefulWidget {
  const MyCoursesListScreen({super.key});

  @override
  State<MyCoursesListScreen> createState() => _MyCoursesListScreenState();
}

class _MyCoursesListScreenState extends State<MyCoursesListScreen> {
  final courseController = Get.find<CoursesController>();

  @override
  void initState() {
    super.initState();
    getCourseOrder();
  }

  Future<void> getCourseOrder() async {
    global.showOnlyLoaderDialog();
    await courseController.getCourseOrderList(global.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => HomeScreen());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "My Courses",
            style: Get.theme.textTheme.bodyMedium!.copyWith(
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ).tr(),
        ),
        body: GetBuilder<CoursesController>(
            builder: (courseController) => courseController.coursedetaillist !=
                        null &&
                    courseController.coursedetaillist != '' &&
                    courseController.coursedetaillist?.isNotEmpty == true
                ? ListView.builder(
                    itemCount: courseController.coursedetaillist?.length,
                    itemBuilder: (context, index) {
                      var course = courseController.coursedetaillist?[index];
                      log('course imag list ${course?.course?.image}');
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [
                                    0.1,
                                    0.9,
                                  ],
                                  colors: [
                                    Color(0xff22211C),
                                    Color(0xff343128),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      blurStyle: BlurStyle.outer)
                                ]),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 1.w),
                                  Text(
                                    '${course?.course?.name}',
                                    style:
                                        Get.theme.textTheme.bodySmall?.copyWith(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                            // color: const Color(0xff3e3e3e),
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${course?.course?.description}',
                                    style:
                                        Get.theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 3.w),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Get.theme.primaryColor)),
                                        child: Image.asset(
                                          'assets/images/rewards.png',
                                          height: 3.h,
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.w, vertical: 1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Get.theme.primaryColor,
                                                  width: 1,
                                                )),
                                            child: Text(
                                              '${course?.course?.courseBadge?.replaceAll(RegExp(r'[\[\]"]'), '')}',
                                              style: Get
                                                  .theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontSize: 14.sp,
                                                      color: Get
                                                          .theme.primaryColor,
                                                      fontWeight:
                                                          FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.w),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => MyCourseDetailScreen(
                                            coursesChapter:
                                                course?.courseChapters!,
                                            course: course?.course,
                                          ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Get.theme.primaryColor
                                              .withOpacity(0.8)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            tr("My Course").toUpperCase(),
                                            style: Get.theme.textTheme.bodySmall
                                                ?.copyWith(
                                                    fontSize: 15.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ).tr(),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              right: 5.w,
                              top: 5.w,
                              child: InkWell(
                                onTap: () async {
                                  courseController.coursedetaillist?[index]
                                              .courseCompletionStatus ==
                                          "incomplete"
                                      ? await courseController.markcourseRead(
                                          courseController
                                              .coursedetaillist?[index].id,
                                        )
                                      : null;
                                },
                                child: Icon(
                                  courseController.coursedetaillist?[index]
                                              .courseCompletionStatus ==
                                          "incomplete"
                                      ? Icons.visibility
                                      : Icons.check_circle_outline,
                                  color: courseController
                                              .coursedetaillist?[index]
                                              .courseCompletionStatus ==
                                          "incomplete"
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 22.sp,
                                ),
                              )),
                        ],
                      );
                    },
                  )
                : const Center(child: Text('No Course Found !'))),
      ),
    );
  }
}
