// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:sizer/sizer.dart';

class YogniDash extends StatefulWidget {
  final int? userid;
  const YogniDash({super.key, required this.userid});

  @override
  State<YogniDash> createState() => _YogniDashState();
}

class _YogniDashState extends State<YogniDash> {
  final kundlicontroller = Get.find<KundliController>();

  @override
  void initState() {
    super.initState();

    loadDatafromApi();
  }

  loadDatafromApi() async {
    await kundlicontroller.getDasha(widget.userid, false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Container(
            width: 100.w,
            height: 5.h,
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade100, width: 0.5),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200, spreadRadius: 1, blurRadius: 5)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('Dasha',
                          style: Get.theme.primaryTextTheme.titleMedium!
                              .copyWith(color: Colors.pink))
                      .tr(),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
                Expanded(
                  child: Text('Dasha Lord',
                          style: Get.theme.primaryTextTheme.titleMedium!
                              .copyWith(color: Colors.pink))
                      .tr(),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
                Expanded(
                  child: Text('End Date',
                          style: Get.theme.primaryTextTheme.titleMedium!
                              .copyWith(color: Colors.pink))
                      .tr(),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: List.generate(
                kundlicontroller.dashaDeatilmodel?.yoginiDashaMain?.response
                        ?.dashaList?.length ??
                    0,
                (index) => Container(
                  width: 100.w,
                  margin: EdgeInsets.all(2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                            '${kundlicontroller.dashaDeatilmodel?.yoginiDashaMain?.response?.dashaList?[index]}',
                            style: Get.theme.textTheme.bodySmall!),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                      Expanded(
                        child: Text(
                            '${kundlicontroller.dashaDeatilmodel?.yoginiDashaMain?.response?.dashaLordList?[index]}',
                            style: Get.theme.textTheme.bodySmall!),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                      Expanded(
                        child: Text(
                            '${kundlicontroller.dashaDeatilmodel?.yoginiDashaMain?.response?.dashaEndDates?[index]}',
                            style: Get.theme.textTheme.bodySmall!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
