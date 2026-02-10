// ignore_for_file: file_names

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/boostController/profileBoostController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class Profileboosthistory extends StatefulWidget {
  const Profileboosthistory({super.key});

  @override
  State<Profileboosthistory> createState() => _ProfileboosthistoryState();
}

class _ProfileboosthistoryState extends State<Profileboosthistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Profile Boost Screen",
                  style: TextStyle(color: Colors.white))
              .tr(),
        ),
        body: GetBuilder<Profileboostcontroller>(builder: (profileController) {
          return ListView.builder(
              itemCount: profileController.profileboosthistoryData.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: COLORS().primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.sp)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_outlined,
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            global.buildTranslatedText(
                                "Your Profile has been boosted for 24 hours at ${profileController.profileboosthistoryData[index].boostedDatetime!.hour}:${profileController.profileboosthistoryData[index].boostedDatetime!.minute} on ${profileController.profileboosthistoryData[index].boostedDatetime!.toString().split(" ").first}",
                                const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //     width: 85.w,
                      //     child: Text(
                      //       "Your Profile has been boosted for 24 hours at ${profileController.profileboosthistoryData[index].boostedDatetime!.hour}:${profileController.profileboosthistoryData[index].boostedDatetime!.minute} on ${profileController.profileboosthistoryData[index].boostedDatetime!.toString().split(" ").first}",
                      //       style: const TextStyle(
                      //         color: Colors.black,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     )),
                    ],
                  ),
                );
              });
        }));
  }
}
