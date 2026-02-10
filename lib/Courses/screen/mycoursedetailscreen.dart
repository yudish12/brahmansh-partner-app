// ignore_for_file: file_names, unrelated_type_equality_checks
import 'dart:async';
import 'dart:developer';
import 'package:brahmanshtalk/Courses/model/courseorderlistmodel.dart';
import 'package:brahmanshtalk/Courses/screen/courseimagescreen.dart';
import 'package:brahmanshtalk/Courses/screen/pdfviewerCourses.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/courseController.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class MyCourseDetailScreen extends StatefulWidget {
  final List<CourseChapter>? coursesChapter;
  final Course? course;

  const MyCourseDetailScreen({
    super.key,
    required this.coursesChapter,
    required this.course,
  });

  @override
  State<MyCourseDetailScreen> createState() => _CourseschapterscreenState();
}

class _CourseschapterscreenState extends State<MyCourseDetailScreen> {
  final courseController = Get.find<CoursesController>();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    log('courses are ${widget.coursesChapter}');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Courses',
          style: Get.theme.textTheme.titleLarge!.copyWith(color: Colors.white),
        ).tr(),
      ),
      body: GetBuilder<CoursesController>(builder: (coursecontroller) {
        return widget.coursesChapter!.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                    children:
                        List.generate(widget.coursesChapter!.length, (index) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Stack(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 1.w),
                                CachedNetworkImage(
                                  imageUrl: '${widget.course!.image}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 10.h,
                                    width: 10.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: imageProvider,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/2022Image.png",
                                    height: 10.h,
                                    width: 10.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  widget.coursesChapter![index].chapterName!,
                                  style: Get.theme.textTheme.bodySmall
                                      ?.copyWith(
                                          fontSize: 16.sp,
                                          color: const Color(0xff3e3e3e)),
                                ).tr(),
                                Text(
                                  widget.coursesChapter![index]
                                      .chapterDescription!,
                                  style:
                                      Get.theme.textTheme.bodySmall?.copyWith(),
                                ),
                                SizedBox(
                                  height: 12.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //youtube
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: widget.coursesChapter![index]
                                                            .youtubeLink !=
                                                        null &&
                                                    widget
                                                            .coursesChapter![
                                                                index]
                                                            .youtubeLink !=
                                                        ''
                                                ? () {
                                                    launch(widget
                                                            .coursesChapter![
                                                                index]
                                                            .youtubeLink ??
                                                        '');
                                                  }
                                                : () {
                                                    global.showToast(
                                                        message: tr(
                                                            'Youtube link not available'));
                                                  },
                                            child: Icon(
                                              Icons.play_circle,
                                              size: 24.sp,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            'Youtube',
                                            style: Get.theme.textTheme.bodySmall
                                                ?.copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff3e3e3e),
                                            ),
                                          ).tr(),
                                        ],
                                      ),
                                      //images
                                      InkWell(
                                        onTap: widget.coursesChapter![index]
                                                        .chapterImages !=
                                                    null &&
                                                widget.coursesChapter![index]
                                                        .chapterImages !=
                                                    '' &&
                                                widget.coursesChapter![index]
                                                    .chapterImages!.isNotEmpty
                                            ? () {
                                                // image view
                                                Get.to(
                                                  () => ImageCourseScreen(
                                                      imagelist: widget
                                                          .coursesChapter![
                                                              index]
                                                          .chapterImages!),
                                                );
                                                for (var i = 0;
                                                    i <
                                                        widget
                                                            .coursesChapter![
                                                                index]
                                                            .chapterImages!
                                                            .length;
                                                    i++) {
                                                  var imagepath = widget
                                                      .coursesChapter![index]
                                                      .chapterImages![i];
                                                  log('imagepath is $imagepath');
                                                }
                                              }
                                            : () {
                                                global.showToast(
                                                    message: tr(
                                                        'images not available'));
                                              },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.picture_in_picture,
                                                size: 24.sp,
                                                color: Colors.blue),
                                            Text(
                                              'Pictures',
                                              style: Get
                                                  .theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff3e3e3e),
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                                      //pdf
                                      InkWell(
                                        onTap: widget.coursesChapter![index]
                                                        .chapterDocument !=
                                                    null &&
                                                widget.coursesChapter![index]
                                                        .chapterDocument !=
                                                    ''
                                            ? () {
                                                var pdfUrl =
                                                    "${widget.coursesChapter![index].chapterDocument}";
                                                Get.to(() =>
                                                    PdfViewerCoursespage(
                                                        url: pdfUrl));
                                              }
                                            : () {
                                                global.showToast(
                                                    message: tr(
                                                        'Pdf link not available'));
                                              },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              size: 24.sp,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              'Pdf',
                                              style: Get
                                                  .theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff3e3e3e),
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                          Positioned(
                            top: 2.w,
                            left: 2.w,
                            child: Text(
                              'Chapter',
                              style: Get.theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.green,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ).tr(
                              args: [
                                (index + 1).toString(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })),
              )
            : const SizedBox();
      }),
    );
  }
}
