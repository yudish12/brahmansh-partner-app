// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/controllers/panchangController.dart';
import 'package:brahmanshtalk/controllers/splashController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  final panchangController = Get.find<PanchangController>();
  final splashController = Get.find<SplashController>();

  @override
  void initState() {
    super.initState();
    resetpanchnagdatae();
  }

  @override
  void dispose() {
    super.dispose();
    panchangController.vedicPanchangModel = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          title: Text(
            'Panchang',
            style: Get.theme.primaryTextTheme.titleLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: COLORS().textColor),
          ).tr(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(Icons.arrow_back, color:COLORS().textColor),
          ),
        ),
        body: GetBuilder<PanchangController>(builder: (panchangController) {
          return panchangController.vedicPanchangModel != null &&
                  panchangController.vedicPanchangModel != ""
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Container
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(1.w),
                        margin: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xff06402B), width: 0.5),
                        ),
                        width: 100.w,
                        child: Column(
                          children: [
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await panchangController.nextDate(false);
                                  },
                                  child: Icon(
                                    Icons.keyboard_double_arrow_left,
                                    color: const Color(0xff06402B),
                                    size: 22.sp,
                                  ),
                                ),
                                Text(
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.date}",
                                  style:
                                      Get.theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xff06402B),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await panchangController.nextDate(true);
                                  },
                                  child: Icon(
                                    Icons.keyboard_double_arrow_right,
                                    color: const Color(0xff06402B),
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      ),

                      // Sun Cards
                      Container(
                        padding: EdgeInsets.all(1.w),
                        margin: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSunCardWidget(
                              title: tr("Sun Rise"),
                              time:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.sunRise}",
                              icon: CupertinoIcons.sunrise,
                              gradientColors: [Colors.orange, Colors.yellow],
                            ),
                            _buildSunCardWidget(
                              title: tr("Sun Set"),
                              time:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.sunSet}",
                              icon: CupertinoIcons.sunset,
                              gradientColors: [Colors.redAccent, Colors.orange],
                            ),
                          ],
                        ),
                      ),

                      // Panchang Details
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          children: [
                            // Tithi
                            _buildTitleCardWidget(
                              label: tr("Tithi"),
                              name:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.tithi!.name}",
                              value:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.tithi!.special}",
                              startTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.tithi!.start}",
                              endTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.tithi!.end}",
                              color: Colors.deepPurpleAccent,
                            ),

                            // Nakshatra
                            _buildTitleCardWidget(
                              label: tr("Nakshatra"),
                              name:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.nakshatra!.name}",
                              value:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.nakshatra!.special}",
                              startTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.nakshatra!.start}",
                              endTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.nakshatra!.end}",
                              color: Colors.redAccent,
                            ),

                            // Karana
                            _buildTitleCardWidget(
                              label: tr("Karana"),
                              name:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.karana!.name}",
                              value:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.karana!.special}",
                              startTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.karana!.start}",
                              endTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.karana!.end}",
                              color: Colors.purpleAccent,
                            ),

                            // Yoga
                            _buildTitleCardWidget(
                              label: tr("Yoga"),
                              name:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.yoga!.name}",
                              value:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.yoga!.special}",
                              startTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.yoga!.start}",
                              endTime:
                                  "${panchangController.vedicPanchangModel!.recordList!.response!.yoga!.end}",
                              color: Colors.blueAccent,
                            ),

                            // Rasi
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(1.w),
                              margin: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr("Rasi"),
                                      style:
                                          Get.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.primaryColor,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${panchangController.vedicPanchangModel!.recordList!.response!.rasi!.name}",
                                      style: Get.textTheme.bodyLarge?.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Additional Information
                      Container(
                        padding: EdgeInsets.all(1.w),
                        margin: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: Text(
                                "Additional Info",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                ),
                              ).tr(),
                            ),
                            const SizedBox(height: 8),

                            // Moon Cards
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildMoonCardWidget(
                                  title: tr("Moon Rise"),
                                  time:
                                      "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.moonRise}",
                                  icon: CupertinoIcons.moon_stars,
                                  colors: const Color(0xFF010AFF),
                                ),
                                _buildMoonCardWidget(
                                  title: tr("Moon Set"),
                                  time:
                                      "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.moonSet}",
                                  icon: CupertinoIcons.moon_zzz_fill,
                                  colors: Colors.black,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildMoonCardWidget(
                                  title: tr("Next Full Moon"),
                                  time:
                                      "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.nextFullMoon}",
                                  icon: CupertinoIcons.moon_circle,
                                  colors: Colors.pinkAccent,
                                ),
                                _buildMoonCardWidget(
                                  title: tr("Next Moon"),
                                  time:
                                      "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.nextNewMoon}",
                                  icon: CupertinoIcons.cloud_moon_bolt,
                                  colors: const Color(0xFFFC0606),
                                ),
                              ],
                            ),

                            // Masa Details
                            Container(
                              padding: EdgeInsets.all(1.w),
                              margin: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  // Amanta Month
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h, horizontal: 2.w),
                                          child: Text(
                                            "Amanta Month",
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ).tr(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h, horizontal: 2.w),
                                          child: Text(
                                            "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.masa!.amantaName}",
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Paksha
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h, horizontal: 2.w),
                                          child: Text(
                                            "Paksha",
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ).tr(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h, horizontal: 2.w),
                                          child: Text(
                                            "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.masa!.paksha}",
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Purnimanta
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h, horizontal: 2.w),
                                          child: Text(
                                            "Purnimanta",
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ).tr(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h, horizontal: 2.w),
                                          child: Text(
                                            "${panchangController.vedicPanchangModel!.recordList!.response!.advancedDetails!.masa!.purnimantaName}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 5),
                      Text('Loading...'),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  // Sun Card Widget
  Widget _buildSunCardWidget({
    required String title,
    required String time,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Moon Card Widget
  Widget _buildMoonCardWidget({
    required String title,
    required String time,
    required IconData icon,
    required Color colors,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: colors,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: colors,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Title Card Widget
  Widget _buildTitleCardWidget({
    required String label,
    required String name,
    required String value,
    required String startTime,
    required String endTime,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(1.w),
      margin: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 1.w),
            Text(
              name,
              style: Get.textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (value.isNotEmpty && value != "null") ...[
              SizedBox(height: 1.w),
              Text(
                value,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.green,
                ),
              ),
            ],
            SizedBox(height: 1.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Start: ${DateFormat('dd-MM-yyyy').format(DateFormat('EEE MMM dd yyyy').parse(startTime))}",
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  "End: ${DateFormat('dd-MM-yyyy').format(DateFormat('EEE MMM dd yyyy').parse(endTime))}",
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void resetpanchnagdatae() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      panchangController.commondate = 0;
      panchangController.update();
    });
  }
}
