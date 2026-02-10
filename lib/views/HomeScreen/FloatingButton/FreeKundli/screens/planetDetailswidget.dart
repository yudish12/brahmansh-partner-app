// ignore_for_file: must_be_immutable, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/model/basicDetailmodel.dart';
import 'package:sizer/sizer.dart';

class PlanetDetailsWidget extends StatefulWidget {
  final PlanetDetails? planetDetails;

  const PlanetDetailsWidget({super.key, required this.planetDetails});

  @override
  State<PlanetDetailsWidget> createState() => _PlanetDetailsWidgetState();
}

class _PlanetDetailsWidgetState extends State<PlanetDetailsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final kundlicontroller = Get.find<KundliController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var astrolist = widget.planetDetails?.response;
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            controller: _tabController,
            isScrollable: true,
            dragStartBehavior: DragStartBehavior.start,
            padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: '${astrolist?.the0?.fullName}'),
              Tab(text: '${astrolist?.the1?.fullName}'),
              Tab(text: '${astrolist?.the2?.fullName}'),
              Tab(text: '${astrolist?.the3?.fullName}'),
              Tab(text: '${astrolist?.the4?.fullName}'),
              Tab(text: '${astrolist?.the5?.fullName}'),
              Tab(text: '${astrolist?.the6?.fullName}'),
              Tab(text: '${astrolist?.the7?.fullName}'),
              Tab(text: '${astrolist?.the8?.fullName}'),
              Tab(text: '${astrolist?.the9?.fullName}'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PlanetDetailTab(
                    planetData: astrolist?.the0, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the1, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the2, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the3, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the4, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the5, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the6, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the7, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the8, detailsdata: astrolist),
                PlanetDetailTab(
                    planetData: astrolist?.the9, detailsdata: astrolist),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanetDetailTab extends StatelessWidget {
  dynamic planetData;
  dynamic detailsdata;

  PlanetDetailTab(
      {super.key, required this.planetData, required this.detailsdata});

  @override
  Widget build(BuildContext context) {
    if (planetData == null) {
      return const Center(child: Text('No data available'));
    }

    return ListView(
      children: [
        _buildDetailRow(
            context,
            isbackgroundgreys: true,
            tr('Full Name'),
            planetData!.fullName),
        SizedBox(height: 2.w),
        _buildDetailRow(context, tr('House'), planetData!.house),
        SizedBox(height: 2.w),
        _buildDetailRow(
            context,
            isbackgroundgreys: true,
            tr('Rasi No'),
            planetData!.rasiNo),
        SizedBox(height: 2.w),
        _buildDetailRow(context, tr('Nakshatra'), planetData!.nakshatra),
        SizedBox(height: 2.w),
        _buildDetailRow(
            context,
            isbackgroundgreys: true,
            tr('Nakshatra Lord'),
            planetData!.nakshatraLord),
        SizedBox(height: 2.w),
        _buildDetailRow(context, tr('Nakshatra No'), planetData!.nakshatraNo),
        SizedBox(height: 2.w),
        _buildDetailRow(
            context,
            tr('Progress in Percentage'),
            isbackgroundgreys: true,
            planetData!.progressInPercentage,
            isProgress: true),
        SizedBox(height: 2.w),
        _buildDetailRow(context, tr('Zodiac'), planetData!.zodiac),
        SizedBox(height: 2.w),
        _buildDetailRow(
            context,
            isbackgroundgreys: true,
            tr('Zodiac Lord'),
            planetData!.zodiacLord),
        SizedBox(height: 2.w),
        _buildDetailRow(context, tr('Lucky Number'), detailsdata?.luckyNum),
        SizedBox(height: 2.w),
        _buildDetailRow(
            context,
            isbackgroundgreys: true,
            tr('Lucky Color'),
            detailsdata?.luckyColors),
        SizedBox(height: 2.w),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, dynamic label, dynamic value,
      {bool isProgress = false, bool isbackgroundgreys = false}) {
    String displayValue =
        value.toString().replaceAll('[', '').replaceAll(']', '');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      height: 5.h,
      width: 100.w,
      color: isbackgroundgreys ? Colors.pink[50] : Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            label.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 17.sp, fontWeight: FontWeight.w300),
          )),
          isProgress
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: value / 100,
                        strokeWidth: 5.0,
                        backgroundColor: Colors.grey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      Center(
                        child: Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Text(
                    displayValue.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 16.sp,
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
