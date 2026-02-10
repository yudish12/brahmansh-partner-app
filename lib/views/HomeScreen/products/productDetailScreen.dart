// ignore_for_file: must_be_immutable, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

import '../../../constants/colorConst.dart';

class Productdetailscreen extends StatelessWidget {
  String image;
  String title;
  String desc;
  String? price;
  Productdetailscreen(
      {super.key,
      required this.image,
      required this.title,
      required this.desc,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: COLORS().textColor),
        title:  Text(
          "Products",
          style: TextStyle(color:COLORS().textColor),
        ).tr(),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Image.network(
                  image,
                  height: 35.h,
                  width: 92.w,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              child: Container(
                height: 55.h,
                width: 100.w,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        blurStyle: BlurStyle.outer,
                      )
                    ],
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(35))),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!global.isCoinWallet())
                            Text(
                              global.getSystemFlagValue(
                                  global.systemFlagNameList.currency),
                              style: Get.theme.textTheme.bodyMedium?.copyWith(
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: CachedNetworkImage(
                                imageUrl: global.getSystemFlagValue(
                                    global.systemFlagNameList.coinIcon),
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Text(
                            price ?? '0',
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text('Description',
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp)),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Text(
                        desc,
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700, fontSize: 12.sp),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
