// ignore_for_file: file_names, unrelated_type_equality_checks

import 'dart:developer';
import 'package:brahmanshtalk/Courses/model/Detailmodel.dart';
import 'package:brahmanshtalk/Courses/model/coursemodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/courseController.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class Courseschapterscreen extends StatefulWidget {
  final CourseModel courses;
  const Courseschapterscreen({super.key, required this.courses});

  @override
  State<Courseschapterscreen> createState() => _CourseschapterscreenState();
}

class _CourseschapterscreenState extends State<Courseschapterscreen> {
  final courseController = Get.find<CoursesController>();

  @override
  void initState() {
    super.initState();
    getDetailCourses();
  }

  getDetailCourses() async {
    log('course id is ${widget.courses.id}');
    await courseController.getCourseDetailsList(widget.courses.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Get.theme.primaryColor,
        elevation: 0,
        title: Text(
          'Course Details',
          style: Get.theme.textTheme.headlineSmall!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ).tr(),
        centerTitle: true,
      ),
      bottomNavigationBar: GetBuilder<CoursesController>(
          builder: (coursecontroller) =>
              coursecontroller.detailchapterlist?.courseOrderStatus == false
                  ? _buildPurchaseButton()
                  : const SizedBox()),
      body: GetBuilder<CoursesController>(builder: (coursecontroller) {
        return courseController.detailchapterlist != null &&
                courseController.detailchapterlist != ''
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    // Course Header Card
                    Container(
                      margin: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Course Image
                          Container(
                            height: 180.sp,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${courseController.detailchapterlist?.image}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Get.theme.primaryColor),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.school_rounded,
                                    size: 50.sp,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Course Info
                          Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and Price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        courseController
                                                .detailchapterlist?.name ??
                                            '',
                                        style: Get.theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.sp,
                                        vertical: 6.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Get.theme.primaryColor,
                                            Get.theme.primaryColor
                                                .withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: _buildPriceWidget(),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12.sp),

                                // Description
                                Text(
                                  courseController
                                          .detailchapterlist?.description ??
                                      '',
                                  style:
                                      Get.theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),

                                SizedBox(height: 16.sp),

                                // Chapters Header
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.sp),
                                  decoration: BoxDecoration(
                                    color:
                                        Get.theme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.list_alt_rounded,
                                        color: Get.theme.primaryColor,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 8.sp),
                                      Text(
                                        "Course Chapters",
                                        style: Get.theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                        ),
                                      ).tr(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chapters List
                    if (coursecontroller.detailchapterlist?.chapters != null &&
                        coursecontroller
                            .detailchapterlist!.chapters!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: coursecontroller
                              .detailchapterlist!.chapters!.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.sp),
                          itemBuilder: (context, index) {
                            final chapter = coursecontroller
                                .detailchapterlist!.chapters![index];
                            return _buildChapterCard(chapter, index);
                          },
                        ),
                      ),

                    SizedBox(height: 20.sp),
                  ],
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
                      'Loading Details...',
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildPriceWidget() {
    return !global.isCoinWallet()
        ? Text(
            "${global.getSystemFlagValue(global.systemFlagNameList.currency)}${courseController.detailchapterlist!.coursePrice.toString()}",
            style: Get.theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: global
                    .getSystemFlagValue(global.systemFlagNameList.coinIcon),
                height: 16.sp,
                width: 16.sp,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 4.sp),
              Text(
                courseController.detailchapterlist!.coursePrice.toString(),
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ],
          );
  }

  Widget _buildChapterCard(Chapter chapter, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        leading: Container(
          width: 32.sp,
          height: 32.sp,
          decoration: BoxDecoration(
            color: Get.theme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Get.theme.primaryColor,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        title: Text(
          chapter.chapterName ?? 'Untitled Chapter',
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Text(
              chapter.chapterDescription ?? 'N/A',
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await courseController.buyCourse(
                  global.user.id, widget.courses.id!);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.sp),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Get.theme.primaryColor,
                    Get.theme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.sp),
                  Text(
                    "BUY NOW",
                    style: Get.theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ).tr(),
                  SizedBox(width: 8.sp),
                  _buildPriceWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
