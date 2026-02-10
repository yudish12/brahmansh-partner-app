// ignore_for_file: unrelated_type_equality_checks, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../controllers/free_kundli_controller.dart';

class ReportScreen extends StatefulWidget {
  final bool isKundali;
  final int? userid;
  const ReportScreen({super.key, required this.userid,required this.isKundali});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final kundlicontroller = Get.find<KundliController>();

  @override
  void initState() {
    super.initState();
    loadDatafromApi();
  }

  loadDatafromApi() async {
    await kundlicontroller.getReport(widget.userid,widget.isKundali);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<KundliController>(
          builder: (kundlicontroller) => Column(
            children: [
              SizedBox(height: 2.h),
              kundlicontroller.reportDetailList == null ||
                      kundlicontroller.reportDetailList == ""
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: 100.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 1.h),
                        itemCount: kundlicontroller.reportDetailList!.length,
                        itemBuilder: (context, index) {
                          final detail =
                              kundlicontroller.reportDetailList![index];
                          final isEven = index % 2 == 0;

                          // Check if the current item is one of the long text fields
                          final isLongText =
                              detail['label'] == 'Spiritual Advice' ||
                                  detail['label'] == 'General prediction' ||
                                  detail['label'] == 'Personalized Prediction';

                          if (isLongText) {
                            // Display long text items in a column
                            return Container(
                              width: 100.w,
                              color: isEven
                                  ? COLORS().primaryColor.withValues(alpha: 0.3)
                                  : Colors.grey.shade200,
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(detail['label']!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                  ).tr(),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    detail['value'] ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w300,
                                        ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Display regular items in a row
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 5.h,
                              ),
                              child: Container(
                                color: isEven
                                    ? COLORS().primaryColor.withValues(alpha: 0.3)
                                    : Colors.grey.shade200,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 3.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr(detail['label']!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.sp),
                                    ).tr(),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                        detail['value']!.removeAllWhitespace,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12.sp),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
