// ignore_for_file: file_names, unrelated_type_equality_checks

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/dashdetailmodel.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/arrowbox.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/kundlichartscreen.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

import '../../../../../constants/colorConst.dart';
import '../../../../../controllers/free_kundli_controller.dart';

class DashaScreen extends StatefulWidget {
  final bool isKundali;
  final int? userid;
  const DashaScreen({super.key, required this.userid, required this.isKundali});

  @override
  State<DashaScreen> createState() => _DashaScreenState();
}

class _DashaScreenState extends State<DashaScreen> {
  final kundlicontroller = Get.find<KundliController>();

  @override
  void initState() {
    super.initState();
    loadDatafromApi();
  }

  loadDatafromApi() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kundlicontroller.addedItemsTable.contains('mahadasha >')) {
        kundlicontroller.addedItemsTable.add('mahadasha >');
        kundlicontroller.update();
      }
    });
    await kundlicontroller.getDasha(widget.userid, widget.isKundali);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(
      builder: (kundlicontroller) => Scaffold(
        body: SingleChildScrollView(
            child: kundlicontroller.dashaDeatilmodel == null ||
                    kundlicontroller.dashaDeatilmodel == ""
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: 100.w,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: 4.h),
                      _buildtwobuttonswidget(kundlicontroller),
                      kundlicontroller.selecteddashaoption == 'vimshottari'
                          ? GetBuilder<KundliController>(
                              builder: (kundlicontroller) => Column(
                                children: [
                                  SizedBox(height: 4.h),
                                  if (kundlicontroller
                                      .addedItemsTable.isNotEmpty)
                                    Container(
                                      height: 5.h,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(width: 1.w),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: kundlicontroller
                                            .addedItemsTable.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                              onTap: () {
                                                _removehandleHorizontalItemClick(
                                                    index);
                                              },
                                              child: ArrowBoxWidget(
                                                  datatitle: kundlicontroller
                                                      .addedItemsTable,
                                                  index: index));
                                        },
                                      ),
                                    ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 2.w),
                                    height: 46.h,
                                    child: kundlicontroller.tableindex == 0
                                        ? customMahadashTab(
                                            kundlicontroller.dashaDeatilmodel
                                                ?.mahaDasha?.response!,
                                          )
                                        : kundlicontroller.tableindex == 1
                                            ? customAntardashTab(
                                                kundlicontroller
                                                    .dashaDeatilmodel
                                                    ?.antarDasha
                                                    ?.response)
                                            : kundlicontroller.tableindex == 2
                                                ? custompratyantarashTab(
                                                    kundlicontroller
                                                        .dashaDeatilmodel
                                                        ?.paryantarDasha
                                                        ?.response)
                                                : const SizedBox(),
                                  ),
                                  _buildTopheading(
                                      tr('Understanding Your dasha')),
                                  SizedBox(height: 2.h),
                                  _buildtitlewidget(tr('Sun Mahadasha')),
                                  SizedBox(height: 1.h),
                                  _builddashdatawidget(
                                      kundlicontroller, context),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(height: 2.h),
                                if (kundlicontroller
                                    .yaginiaddedItemsTable.isNotEmpty)
                                  SizedBox(height: 2.h),
                                Container(
                                  height: 5.h,
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 1.w),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: kundlicontroller
                                        .yaginiaddedItemsTable.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            _removehandleHorizontalItemClickyogini(
                                                index);
                                          },
                                          child: ArrowBoxWidget(
                                              datatitle: kundlicontroller
                                                  .yaginiaddedItemsTable,
                                              index: index));
                                    },
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  height: 60.h,
                                  width: 90.w,
                                  child: kundlicontroller.yagnitableindex == 0
                                      ? yoginidashTab(kundlicontroller
                                          .dashaDeatilmodel
                                          ?.yoginiDashaMain
                                          ?.response)
                                      : yagnisubdashTab(kundlicontroller
                                          .dashaDeatilmodel?.yoginiDashaSub),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                    ],
                  )),
      ),
    );
  }

  Container _buildtwobuttonswidget(KundliController kundlicontroller) {
    return Container(
      height: 7.h,
      width: 100.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  kundlicontroller.selecteddashaoption = 'vimshottari';

                  kundlicontroller.update();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(2.w),
                        topLeft: Radius.circular(2.w)),
                    color: kundlicontroller.selecteddashaoption == 'vimshottari'
                        ? COLORS().primaryColor.withValues(alpha: 0.3)
                        : Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      'Vimshottari',
                      style: TextStyle(
                        color: kundlicontroller.selecteddashaoption ==
                                'vimshottari'
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ).tr(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  kundlicontroller.selecteddashaoption = 'Yogini';
                  kundlicontroller.update();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(2.w),
                        topRight: Radius.circular(2.w)),
                    color: kundlicontroller.selecteddashaoption == 'Yogini'
                        ? COLORS().primaryColor.withValues(alpha: 0.3)
                        : Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      'Yogini',
                      style: TextStyle(
                        color: kundlicontroller.selecteddashaoption == 'Yogini'
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ).tr(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _removehandleHorizontalItemClick(int index) {
    log('remove index is $index');
    if (kundlicontroller.tableindex <= 0) {
      return;
    }
    kundlicontroller.addedItemsTable =
        kundlicontroller.addedItemsTable.sublist(0, index + 1);
    kundlicontroller.tableindex = index;
    kundlicontroller.update();
  }

  void _removehandleHorizontalItemClickyogini(int index) {
    log('remove index is $index');
    if (kundlicontroller.yagnitableindex <= 0) {
      return;
    }
    kundlicontroller.yaginiaddedItemsTable =
        kundlicontroller.yaginiaddedItemsTable.sublist(0, index + 1);
    kundlicontroller.yagnitableindex = index;
    kundlicontroller.update();
  }

  yoginidashTab(YoginiDashaMainResponse? dashalist) {
    return Column(
      children: [
        Container(
          // height: 5.h,
          decoration: BoxDecoration(
            color: COLORS().primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              buildTableHeaderCell("Planet"),
              buildVerticalDivider(),
              buildTableHeaderCell("End-Date"),
              buildVerticalDivider(),
              buildTableHeaderCell("Dasha Lord"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: kundlicontroller
                .dashaDeatilmodel?.yoginiDashaMain?.response?.dashaList?.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      kundlicontroller.yagnidashaindextable = index;
                      kundlicontroller.yagnitableindex =
                          kundlicontroller.yagnidashaindextable + 1;
                      if (!kundlicontroller.yaginiaddedItemsTable
                          .contains('${dashalist?.dashaList?[index].name}')) {
                        kundlicontroller.yaginiaddedItemsTable
                            .add('${dashalist?.dashaList?[index].name} >');
                      }
                      kundlicontroller.update();
                    },
                    child: Row(
                      children: [
                        buildVerticalDivider(),
                        buildTableCell(dashalist?.dashaList?[index].name ?? ""),
                        buildVerticalDivider(),
                        buildTableCell(dashalist?.dashaEndDates?[index] ?? ""),
                        buildVerticalDivider(),
                        buildTableCell(dashalist?.dashaLordList?[index] ?? ""),
                        Icon(Icons.arrow_forward_ios, size: 13.sp),
                        buildVerticalDivider(),
                      ],
                    ),
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

  customMahadashTab(MahaDashaResponse? dashalist) {
    return Column(
      children: [
        Container(
          height: 5.h,
          decoration: BoxDecoration(
            color: COLORS().primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              buildTableHeaderCell("Planet"),
              buildVerticalDivider(),
              buildTableHeaderCell("End-Date"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction
                ?.response!.dashas!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      kundlicontroller.dashaindextable = index;
                      kundlicontroller.tableindex =
                          kundlicontroller.tableindex + 1;
                      if (!kundlicontroller.addedItemsTable
                          .contains('AntarDasha >')) {
                        kundlicontroller.addedItemsTable.add('AntarDasha >');
                      }
                      kundlicontroller.update();

                      log('colum clicked is ${kundlicontroller.dashaindextable} and inner index is ${kundlicontroller.tableindex}');
                    },
                    child: Row(
                      children: [
                        buildVerticalDivider(),
                        buildTableCell(dashalist?.mahadasha?[index] ?? ""),
                        buildVerticalDivider(),
                        buildTableCell(dashalist?.mahadashaOrder?[index] ?? ""),
                        Icon(Icons.arrow_forward_ios, size: 13.sp),
                        buildVerticalDivider(),
                      ],
                    ),
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

//1
  yagnisubdashTab(YoginiDashaSub? chardasha) {
    return GetBuilder<KundliController>(
      builder: (kundlicontroller) => Column(
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: COLORS().primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Row(
              children: [
                buildTableHeaderCell("Planet"),
                buildVerticalDivider(),
                buildTableHeaderCell("End-Date"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chardasha?.response?[kundlicontroller.yagnitableindex]
                      .subDashaList?.length ??
                  0,
              itemBuilder: (context, index) {
                log('chardasha subdashalist ${chardasha!.response?[kundlicontroller.yagnitableindex].subDashaList![index].name}');
                log('chardasha subdashalist 2 ${chardasha.response?[kundlicontroller.yagnitableindex].subDashaList?.length}');
                return Column(
                  children: [
                    Row(
                      children: [
                        buildVerticalDivider(),
                        buildTableCell(chardasha
                            .response?[kundlicontroller.yagnitableindex]
                            .subDashaList![index]
                            .name),
                        buildVerticalDivider(),
                        buildTableCell(
                          chardasha.response?[kundlicontroller.yagnitableindex]
                              .subDashaEndDates![index]
                              .toString(),
                        ),
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
      ),
    );
  }

//1
  customAntardashTab(AntarDashaResponse? dashalist) {
    return GetBuilder<KundliController>(
      builder: (kundlicontroller) => Column(
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: COLORS().primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Row(
              children: [
                buildTableHeaderCell("Antardasha"),
                buildVerticalDivider(),
                buildTableHeaderCell("End-Date"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dashalist?.antardashas?.length ?? 0,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        kundlicontroller.dashaindextable = index;
                        kundlicontroller.tableindex =
                            kundlicontroller.tableindex + 1;
                        if (!kundlicontroller.addedItemsTable
                            .contains('pratyantarDasha >')) {
                          kundlicontroller.addedItemsTable
                              .add('pratyantarDasha >');
                        }
                        kundlicontroller.update();

                        log('colum clicked is ${kundlicontroller.dashaindextable} and inner index is ${kundlicontroller.tableindex}');
                      },
                      child: Row(
                        children: [
                          buildVerticalDivider(),
                          buildTableCell(dashalist!.antardashas![
                              kundlicontroller.dashaindextable][index]),
                          buildVerticalDivider(),
                          buildTableCell(dashalist.antardashaOrder![
                              kundlicontroller.dashaindextable][index]),
                          Icon(Icons.arrow_forward_ios, size: 13.sp),
                          buildVerticalDivider(),
                        ],
                      ),
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
      ),
    );
  }

//3 tab in table
  custompratyantarashTab(ParyantarDashaResponse? prayantarlist) {
    return GetBuilder<KundliController>(
      builder: (kundlicontroller) => Column(
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: COLORS().primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Row(
              children: [
                buildTableHeaderCell("Prayantar"),
                buildVerticalDivider(),
                buildTableHeaderCell("End-Date"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: prayantarlist?.paryantardasha?.length ?? 0,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        buildVerticalDivider(),
                        buildTableCell(prayantarlist?.paryantardasha?[0]
                            [kundlicontroller.dashaindextable][index]),
                        buildVerticalDivider(),
                        buildTableCell(prayantarlist?.paryantardashaOrder?[0]
                            [kundlicontroller.dashaindextable][index]),
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
      ),
    );
  }
}

Container _buildtitlewidget(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.symmetric(horizontal: 5.w),
    child: Text(
      title,
      style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 13.sp,
      ),
    ).tr(),
  );
}

Container _buildTopheading(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.symmetric(horizontal: 5.w),
    child: global.buildTranslatedText(
        title,
        Get.theme.primaryTextTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w300,
          color: Colors.black87,
          fontSize: 12.sp,
        )),
  );
}

_builddashdatawidget(kundlicontroller, context) {
  return Column(
    children: List.generate(
        kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction?.response!
                .dashas!.length ??
            0, (index) {
      return Column(
        children: [
          SizedBox(height: 2.h),
          Container(
            width: 100.w,
            height: 5.h,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '${kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction?.response!.dashas?[index].dasha}',
                    style: Get.theme.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp),
                  ),
                  Text(
                    '(${kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction?.response!.dashas?[index].dashaStartYear}',
                    style: Get.theme.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp),
                  ),
                  Text(
                    '-${kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction?.response!.dashas?[index].dashaEndYear})',
                    style: Get.theme.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: tr('Prediction'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 13.sp)),
                  TextSpan(
                      text: tr(': '),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 13.sp)),
                  TextSpan(
                      text:
                          '${kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction?.response!.dashas?[index].prediction}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          )),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 100.w,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: tr('Planet in Zodiac'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 13.sp),
                  ),
                  TextSpan(
                      text: tr(': '),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 13.sp)),
                  TextSpan(
                    text:
                        '${kundlicontroller.dashaDeatilmodel?.mahaDashaPrediction?.response!.dashas?[index].planetInZodiac}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }),
  );
}
