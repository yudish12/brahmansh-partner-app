// ignore_for_file: file_names

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/widgets/bounce_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/KpScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/astavargaTablescreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/basicdetailwidget.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/kundliDetailsScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/screens/kundlichartscreen.dart';
import 'package:sizer/sizer.dart';
import 'DashaScreen.dart';
import 'DoshaScreen.dart';
import 'planetReportscreen.dart';
import 'reportScreen.dart';

class GetKundliDetailScreen extends StatefulWidget {
  final bool isKundali;
  final int? userid;
  final String? pdflink;
  const GetKundliDetailScreen({
    super.key,
    required this.userid,
    required this.pdflink,
    required this.isKundali,
  });

  @override
  State<GetKundliDetailScreen> createState() => _GetKundliDetailScreenState();
}

class _GetKundliDetailScreenState extends State<GetKundliDetailScreen>
    with AutomaticKeepAliveClientMixin<GetKundliDetailScreen> {
  @override
  bool get wantKeepAlive => true;
  int currentIndex = 0;
  final kundlicontroller = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool hasPdfLink = widget.pdflink != null &&
        widget.pdflink!.isNotEmpty &&
        (widget.pdflink!.startsWith('http://') ||
            widget.pdflink!.startsWith('https://'));

    debugPrint("hasPdfLink $hasPdfLink");

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child:  Icon(Icons.arrow_back,
            color:  COLORS().textColor,),
          ),
          title:  Text('Kundli Details',
          style: TextStyle(
            color: COLORS().textColor
          ),),
          actions: [
            hasPdfLink
                ? BounceWrapper(
                    onTap: () {
                      Get.to(
                        () => KundliDetailsScreen(pdfLink: widget.pdflink!),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 0.78.h,
                      ),
                      child: const Text(
                        "PDF",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    height: 5.h,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: COLORS().blackColor, width: 0.5)),
                      unselectedLabelColor: Colors.white,
                      isScrollable: true,
                      indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 4,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dragStartBehavior: DragStartBehavior.start,
                      tabAlignment: TabAlignment.start,
                      labelColor: Colors.black,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                              fontSize: 11.sp, fontWeight: FontWeight.w500),
                      unselectedLabelStyle: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(
                          fontSize: 10.sp, fontWeight: FontWeight.w500),
                      tabs: [
                        Tab(text: tr('Basic Details')),
                        Tab(text: tr('Charts')),
                        Tab(text: tr('KP')),
                        Tab(text: tr('Ashtakvarga')),
                        Tab(text: tr('Report')),
                        Tab(text: tr('Planet Report')),
                        Tab(text: tr('Dasha')),
                        Tab(text: tr('Dosha')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BasicDetailsWidget(basicDetails: kundlicontroller.basicDeatilmodel),
            KundliChartScreen(
              userid: widget.userid,
              planetDetails: kundlicontroller.basicDeatilmodel?.planetDetails,
              isKundali: widget.isKundali,
            ),
            KpScreen(
              userid: widget.userid,
              planetDetails: kundlicontroller.basicDeatilmodel?.planetDetails,
              isKundali: widget.isKundali,
            ),
            AshtakvargaTable(
              userid: widget.userid,
              iskundali: widget.isKundali,
            ),
            ReportScreen(userid: widget.userid, isKundali: widget.isKundali),
            PlanetReportScreen(
              userid: widget.userid,
              isKundali: widget.isKundali,
            ),
            DashaScreen(userid: widget.userid, isKundali: widget.isKundali),
            DoshaScreen(userid: widget.userid, isKundali: widget.isKundali),
          ],
        ),
      ),
    );
  }
}
