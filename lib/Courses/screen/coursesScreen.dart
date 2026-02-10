// ignore_for_file: fileNames, unrelated_type_equality_checks
import 'dart:developer';
import 'package:brahmanshtalk/Courses/screen/coursesChapterscreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/courseController.dart';

class Coursesscreen extends StatefulWidget {
  const Coursesscreen({super.key});

  @override
  State<Coursesscreen> createState() => _CoursesscreenState();
}

class _CoursesscreenState extends State<Coursesscreen> {
  final courseController = Get.find<CoursesController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getCourses());
  }

  Future<void> getCourses() async {
    await courseController.getCoursesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Get.theme.primaryColor,
        elevation: 0,
        title: Text(
          "Courses",
          style: Get.theme.textTheme.headlineSmall!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ).tr(),
        centerTitle: true,
      ),
      body: GetBuilder<CoursesController>(
        builder: (courseController) => courseController.courselist != null &&
                courseController.courselist != ''
            ? Container(
                color: Colors.grey[50],
                child: ListView.separated(
                  padding: EdgeInsets.all(16.sp),
                  itemCount: courseController.courselist?.length ?? 0,
                  separatorBuilder: (context, index) => SizedBox(height: 16.sp),
                  itemBuilder: (context, index) {
                    var course = courseController.courselist?[index];
                    log('course imag list ${course?.image}');

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Get.to(
                                () => Courseschapterscreen(courses: course!));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${course?.name}',
                                            style: Get
                                                .theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontSize: 16.sp,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8.sp),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.sp,
                                              vertical: 4.sp,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '${course?.categoryName}',
                                              style: Get
                                                  .theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: 10.sp,
                                                color: Get.theme.primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Badge icon
                                    Container(
                                      width: 40.sp,
                                      height: 40.sp,
                                      decoration: BoxDecoration(
                                        color: Get.theme.primaryColor
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.workspace_premium_rounded,
                                        color: Get.theme.primaryColor,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16.sp),

                                // Description
                                Text(
                                  '${course?.description}',
                                  style:
                                      Get.theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(height: 16.sp),

                                // Badge section
                                if (course?.courseBadge != null &&
                                    course!.courseBadge!.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.sp,
                                      vertical: 8.sp,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Get.theme.primaryColor
                                              .withOpacity(0.8),
                                          Get.theme.primaryColor,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.emoji_events_rounded,
                                          color: Colors.white,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 8.sp),
                                        Flexible(
                                          child: Text(
                                            '${course.courseBadge?.replaceAll(RegExp(r'[\[\]"]'), '')}',
                                            style: Get.theme.textTheme.bodySmall
                                                ?.copyWith(
                                              fontSize: 11.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                SizedBox(height: 16.sp),

                                // Explore button
                                Container(
                                  width: double.infinity,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 12.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Get.theme.primaryColor,
                                        Get.theme.primaryColor.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        tr("Explore Course").toUpperCase(),
                                        style: Get.theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(width: 8.sp),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                    ),
                    SizedBox(height: 16.sp),
                    Text(
                      'Loading Courses...',
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
