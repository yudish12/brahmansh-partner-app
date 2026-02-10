// ignore_for_file: must_be_immutable, file_names

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/colorConst.dart';
import '../../../../../controllers/free_kundli_controller.dart';
import '../model/planetreportmodel.dart';

class PlanetReportScreen extends StatefulWidget {
  final bool isKundali;
  final int? userid;
  const PlanetReportScreen({super.key, required this.userid,required this.isKundali});

  @override
  State<PlanetReportScreen> createState() => _PlanetReportScreenState();
}

class _PlanetReportScreenState extends State<PlanetReportScreen>
    with SingleTickerProviderStateMixin {
  final kundlicontroller = Get.find<KundliController>();
  late TabController _tabController;
  List<String> celestialBodies = [
    'Sun',
    'Moon',
    'Mercury',
    'Venus',
    'Mars',
    'Saturn',
    'Jupiter',
    'Rahu',
    'Ketu'
  ];
  var tabIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(_handleTabChange);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _tabController.addListener(_handleTabChange);

    loadDatafromApi();
  }

  // void _handleTabChange() async {
  //   if (_tabController.indexIsChanging) {
  //     log(' Tab  value is : ${celestialBodies[_tabController.index]}');
  //     kundlicontroller.planetreport = null;
  //     kundlicontroller.update();
  //     await kundlicontroller.getPlanetReport(
  //         widget.userid, celestialBodies[_tabController.index]);
  //   }
  // }

  void _handleTabChange() async {
    if (tabIndex != _tabController.index) {
      tabIndex = _tabController.index;
      log('tab swiped to $tabIndex');
      setState(() {});
      log(' Tab  value is : ${celestialBodies[_tabController.index]}');
      kundlicontroller.planetreport = null;
      kundlicontroller.update();
      await kundlicontroller.getPlanetReport(
          widget.userid, celestialBodies[_tabController.index],widget.isKundali);
    }
  }

  loadDatafromApi() async {
    await kundlicontroller.getPlanetReport(widget.userid, celestialBodies[0],widget.isKundali);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            indicatorColor:COLORS().primaryColor,
            labelColor: COLORS().primaryColor,
            dividerColor: Colors.transparent,
            controller: _tabController,
            isScrollable: true,
            dragStartBehavior: DragStartBehavior.start,
            padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              ...celestialBodies.map((body) => Tab(text: tr(body))),
            ],
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  9,
                  (index) {
                    return GetBuilder<KundliController>(
                      builder: (kundlicontroller) =>
                          kundlicontroller.planetreport == null
                              ? const Center(child: CircularProgressIndicator())
                              : PlanetDetailTab(
                                  planetData: kundlicontroller.planetreport),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

class PlanetDetailTab extends StatelessWidget {
  PlanetReportModel? planetData;
  PlanetDetailTab({super.key, this.planetData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
      child: ListView(
        children: [
          _buildDetailRow(
              context,
              isbackgroundgreys: true,
              tr('planet Considered'),
              planetData!.planetReport?.response?[0].planetConsidered),
          SizedBox(height: 2.w),
          _buildDetailRow(context, tr('Planet Location'),
              planetData!.planetReport?.response?[0].planetLocation),
          SizedBox(height: 2.w),
          _buildDetailRow(
              context,
              isbackgroundgreys: true,
              tr('Planet Zodiac'),
              planetData!.planetReport?.response?[0].planetZodiac),
          SizedBox(height: 2.w),
          _buildDetailRow(context, tr('Zodiac Lord Streangth'),
              planetData!.planetReport?.response?[0].zodiacLordStrength),
          SizedBox(height: 2.w),
          _buildDetailRow(
              context,
              isbackgroundgreys: true,
              tr('Planet definition'),
              planetData!.planetReport?.response?[0].planetDefinitions),
          SizedBox(height: 2.w),
          _buildDetailRow(context, tr('Verbal Location'),
              planetData!.planetReport?.response?[0].verbalLocation),
          SizedBox(height: 2.w),
          _buildDetailRow(
              context,
              tr('Affliction'),
              isbackgroundgreys: true,
              planetData!.planetReport?.response?[0].affliction,
              isProgress: true),
          SizedBox(height: 2.w),
          _buildDetailRow(context, tr('Personalised Prediction'),
              planetData!.planetReport?.response?[0].personalisedPrediction),
          SizedBox(height: 2.w),
          _buildDetailRow(
              context,
              isbackgroundgreys: true,
              tr('Planet Zodiac Prediction'),
              planetData!.planetReport?.response?[0].planetZodiacPrediction),
          SizedBox(height: 2.w),
          SizedBox(height: 2.w),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    dynamic label,
    dynamic value, {
    bool isProgress = false,
    bool isbackgroundgreys = false,
  }) {
    bool isLongText = (value.toString().length > 30);

    return Container(
      color: isbackgroundgreys ? COLORS().primaryColor.withValues(alpha: 0.3) : Colors.grey.shade200,
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 3.w),
      child: isLongText
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
    );
  }
}
