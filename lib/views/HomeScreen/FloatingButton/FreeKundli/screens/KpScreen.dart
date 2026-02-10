// ignore_for_file: file_names

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/FullSizeSvgPainter.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/kundlichartscreen.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/colorConst.dart';
import '../model/basicDetailmodel.dart';

class KpScreen extends StatefulWidget {
  final bool isKundali;
  final int? userid;
  final PlanetDetails? planetDetails;

  const KpScreen(
      {super.key,
      required this.userid,
      required this.planetDetails,
      required this.isKundali});

  @override
  State<KpScreen> createState() => _KpScreenState();
}

class _KpScreenState extends State<KpScreen> {
  final kundlicontroller = Get.find<KundliController>();
  TapDownDetails? _doubleTapDetails;
  final _transformationController = TransformationController();
  @override
  void initState() {
    super.initState();
    log('kp user id is->  ${widget.userid}');
    log('kp key->  kp_chalit');
    _fetchDataForKpTab("kp_chalit");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3.h),
            GetBuilder<KundliController>(
              builder: (kundlicontroller) => SizedBox(
                height: 8.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            kundlicontroller.selectedDirection = 'north';
                            kundlicontroller.svgImageKp = null;

                            kundlicontroller.update();

                            _fetchDataForKpTab(
                              "kp_chalit",
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(2.w),
                                  topLeft: Radius.circular(2.w)),
                              color:
                                  kundlicontroller.selectedDirection == 'north'
                                      ? Get.theme.primaryColor
                                      : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                'North',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            kundlicontroller.selectedDirection = 'south';
                            kundlicontroller.svgImageKp = null;
                            kundlicontroller.update();
                            _fetchDataForKpTab('kp_chalit');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(2.w),
                                  topRight: Radius.circular(2.w)),
                              color:
                                  kundlicontroller.selectedDirection == 'south'
                                      ? Get.theme.primaryColor
                                      : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                'South',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            GetBuilder<KundliController>(
              builder: (kundlicontroller) => Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onDoubleTapDown: (d) => _doubleTapDetails = d,
                    onDoubleTap: _handleDoubleTap,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(10.0),
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Center(
                        child: SizedBox(
                          width: 90.w,
                          height: 80.w,
                          child: kundlicontroller.isDataLoaded
                              ? (kundlicontroller.svgImageKp != null
                                  ? CustomPaint(
                                      painter: FullSizeSvgPainter(
                                          kundlicontroller.svgImageKp),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator()))
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: -2.h,
                    child: InkWell(
                        onTapDown: (d) => _doubleTapDetails = d,
                        onTap: _handleDoubleTap,
                        child: CircleAvatar(
                          radius: 3.h,
                          backgroundColor: Colors.black26,
                          child: Icon(
                            Icons.zoom_in,
                            size: 22.sp,
                          ),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              alignment: Alignment.centerLeft,
              child: Text('Planet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  )).tr(),
            ),
            Column(
              children: [
                GetBuilder<KundliController>(
                  builder: (kundlicontroller) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    height: 10.h,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //signin
                            kundlicontroller.isNakshatraTapped = false;
                            kundlicontroller.update();
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.w),
                                ),
                                border: kundlicontroller.isNakshatraTapped ==
                                        false
                                    ? Border.all(color: Colors.pink, width: 1)
                                    : Border.all(
                                        color: Colors.grey, width: 0.5),
                                color:
                                    kundlicontroller.isNakshatraTapped == false
                                        ? Colors.pink.shade50
                                        : Colors.grey.shade50),
                            child: Text(
                              'Sign',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ).tr(),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        GestureDetector(
                          onTap: () {
                            //Nakshatra
                            kundlicontroller.isNakshatraTapped = true;
                            kundlicontroller.update();
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.w),
                                ),
                                border: kundlicontroller.isNakshatraTapped
                                    ? Border.all(color: Colors.pink, width: 1)
                                    : Border.all(
                                        color: Colors.grey, width: 0.5),
                                color: kundlicontroller.isNakshatraTapped
                                    ? Colors.pink.shade50
                                    : Colors.grey.shade50),
                            child: Text(
                              'Nakshatra',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ).tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GetBuilder<KundliController>(
                  builder: (kundlicontroller) => Container(
                    padding: EdgeInsets.all(4.w),
                    height: 60.h,
                    child: kundlicontroller.isNakshatraTapped == false
                        ? customSignInTableWidget(widget.planetDetails)
                        : customNakshatraInTableWidget(widget.planetDetails),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  customNakshatraInTableWidget(PlanetDetails? planetDetails) {
    var astrolist = widget.planetDetails?.response;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: COLORS().primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              buildTableHeaderCell("Planet"),
              buildVerticalDivider(),
              buildTableHeaderCell("Nakshatra"),
              buildVerticalDivider(),
              buildTableHeaderCell("Naksh lord"),
              buildVerticalDivider(),
              buildTableHeaderCell("House"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              Map<int, The0?> astroMap = {
                0: astrolist?.the0,
                1: astrolist?.the1,
                2: astrolist?.the2,
                3: astrolist?.the3,
                4: astrolist?.the4,
                5: astrolist?.the5,
                6: astrolist?.the6,
                7: astrolist?.the7,
                8: astrolist?.the8,
                9: astrolist?.the9,
              };
              return Column(
                children: [
                  Row(
                    children: [
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.fullName ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.nakshatra ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.nakshatraLord ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]?.house.toString() ?? ""),
                      buildVerticalDivider(),
                    ],
                  ),
                  Container(
                    height: 0.4,
                    width: 100.w,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  customSignInTableWidget(PlanetDetails? planetDetails) {
    var astrolist = widget.planetDetails?.response;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: COLORS().primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              buildTableHeaderCell("Planet"),
              buildVerticalDivider(),
              buildTableHeaderCell("Sign"),
              buildVerticalDivider(),
              buildTableHeaderCell("Signlord"),
              buildVerticalDivider(),
              buildTableHeaderCell("Degree"),
              buildVerticalDivider(),
              buildTableHeaderCell("House"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              Map<int, The0?> astroMap = {
                0: astrolist?.the0,
                1: astrolist?.the1,
                2: astrolist?.the2,
                3: astrolist?.the3,
                4: astrolist?.the4,
                5: astrolist?.the5,
                6: astrolist?.the6,
                7: astrolist?.the7,
                8: astrolist?.the8,
                9: astrolist?.the9,
              };

              return Column(
                children: [
                  Row(
                    children: [
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.fullName ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.zodiac ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.zodiacLord ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(
                          astroMap[index]?.localDegree!.toStringAsFixed(2) ??
                              ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]?.house.toString() ?? ""),
                      buildVerticalDivider(),
                    ],
                  ),
                  Container(
                    height: 0.4,
                    width: 100.w,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position!.dx, -position.dy)
        ..scale(1.5);
    }
  }

  void _fetchDataForKpTab(String tabKey) async {
    if (widget.userid == null) return;

    debugPrint('Fetching  with userId ${widget.userid}');
    await kundlicontroller.getChartDetails(widget.userid!, tabKey,
        kundlicontroller.selectedDirection, widget.isKundali);
    await createSvgImage(kundlicontroller.chartDeatilmodel?.chartDetails ?? '');
  }

  Future createSvgImage(String svg) async {
    if (svg.isEmpty) return;

    try {
      final pictureInfo = await vg.loadPicture(SvgStringLoader(svg), null);
      final img = await pictureInfo.picture.toImage(500, 500);

      kundlicontroller.svgImageKp = img;
      pictureInfo.picture.dispose();

      // Ensure the state update is handled correctly
      kundlicontroller.isDataLoaded = true;
      kundlicontroller.update();
    } catch (e) {
      debugPrint('Error creating SVG image: $e');
      kundlicontroller.isDataLoaded = false;
      kundlicontroller.update();
    }
  }
}
