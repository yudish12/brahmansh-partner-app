// ignore_for_file: must_be_immutable
import 'dart:math';
import 'package:brahmanshtalk/views/HomeScreen/home_screen.dart';
import 'package:brahmanshtalk/widgets/commonDialogWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../constants/colorConst.dart';
import '../../controllers/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationController = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
  }

  Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double width = Get.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.to(() => HomeScreen());
              },
              child:  Icon(Icons.arrow_back,
              color: COLORS().textColor,)),
          title:  Text("Notification",
          style: TextStyle(
            color: COLORS().textColor
          ),).tr(),
          actions: [
            IconButton(
              onPressed: () {
                showCommonDialog(
                    title: "Are you sure you want delete all notifications?",
                    subtitle:
                        "This action will permanently delete all your notification history.",
                    primaryButtonText: "Delete",
                    secondaryButtonText: "Cancle",
                    onSecondaryPressed: () {
                      Get.back();
                    },
                    primaryButtonColor: Colors.red,
                    onPrimaryPressed: () async {
                      Get.back();
                      await notificationController.deleteAllNotification();
                    });
              },
              icon:  Icon(Icons.delete, color: COLORS().textColor),
            ),
          ],
        ),
        body: GetBuilder<NotificationController>(
          builder: (notificationController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: height,
              width: width,
              child: notificationController.notificationList.isEmpty
                  ? Center(child: const Text('No Notification is here').tr())
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 1.h);
                      },
                      itemCount: notificationController.notificationList.length,
                      itemBuilder: (context, index) {
                        String formattedDate = DateFormat("dd/MMM/yyyy hh:mm a")
                            .format(DateTime.parse(notificationController
                                .notificationList[index].updatedAt
                                .toString()));

                        debugPrint('date time is $formattedDate');
                        debugPrint(
                            'title is ${notificationController.notificationList[index].title}');
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: notificationController
                                                .notificationList[index]
                                                .callStatus ==
                                            'Rejected' ||
                                        notificationController
                                                .notificationList[index]
                                                .chatStatus ==
                                            'Rejected' ||
                                        notificationController
                                                .notificationList[index]
                                                .callStatus ==
                                            'Accepted' ||
                                        notificationController
                                                .notificationList[index]
                                                .chatStatus ==
                                            'Accepted'
                                    ? const Color.fromARGB(255, 247, 210, 186)
                                    : Colors.grey.shade400,
                                width: 0.5),
                            color: notificationController
                                            .notificationList[index]
                                            .callStatus ==
                                        'Rejected' ||
                                    notificationController
                                            .notificationList[index]
                                            .chatStatus ==
                                        'Rejected' ||
                                    notificationController
                                            .notificationList[index]
                                            .callStatus ==
                                        'Accepted' ||
                                    notificationController
                                            .notificationList[index]
                                            .chatStatus ==
                                        'Accepted'
                                ? const Color(0xffffe5d4)
                                : Colors.grey.shade200,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 4.h,
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("WOAH!".toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 10.sp,
                                                  color:
                                                      const Color(0xff423934))),
                                      const Spacer(),
                                      Text(
                                        formattedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 8.sp,
                                              color: const Color(0xffab9d94),
                                            ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          debugPrint(
                                              'delete ${notificationController.notificationList[index].id}');
                                          await notificationController
                                              .deleteNotification(
                                                  notificationController
                                                      .notificationList[index]
                                                      .id!);
                                        },
                                        child: SizedBox(
                                          width: 8.w,
                                          child: Icon(
                                            Icons.delete,
                                            size: 16.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  '${notificationController.notificationList[index].title}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                ),
                                notificationController.notificationList[index]
                                        .description!.isNotEmpty
                                    ? Text(
                                        '${notificationController.notificationList[index].description}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 11.sp,
                                                color: const Color(0xff83786e)),
                                      )
                                    : SizedBox(
                                        height: 2.h,
                                      ),
                              ]),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
