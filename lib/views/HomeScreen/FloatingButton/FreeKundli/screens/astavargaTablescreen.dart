// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:sizer/sizer.dart';

import '../model/kundlichartModel.dart';

class AshtakvargaTable extends StatefulWidget {
  final bool iskundali;
  final int? userid;
  const AshtakvargaTable({
    required this.userid,
    required this.iskundali,
    super.key,
  });

  @override
  State<AshtakvargaTable> createState() => _AshtakvargaTableState();
}

class _AshtakvargaTableState extends State<AshtakvargaTable> {
  final kundlicontroller = Get.find<KundliController>();
  AshtakvargaResponse? datalist;

  @override
  void initState() {
    super.initState();
    loadDatafromApi();
  }

  loadDatafromApi() async {
    await kundlicontroller.getAstaVarga(widget.userid, widget.iskundali);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20.0),
      minScale: 0.5,
      maxScale: 4.0,
      child: GetBuilder<KundliController>(
        builder: (kundlicontroller) => LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
                child: kundlicontroller.ashtakvargaPoints.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(height: 7.h),
                          SizedBox(
                            height: 6.h,
                            child: Text(
                              'Ashtakvarga Order',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ).tr(),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth,
                              maxHeight: constraints.maxHeight,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: DataTable(
                                border: TableBorder(
                                  left: const BorderSide(
                                      color: Colors.black, width: 1),
                                  right: const BorderSide(
                                      color: Colors.black, width: 1),
                                  bottom: const BorderSide(
                                      color: Colors.black, width: 1),
                                  top: const BorderSide(
                                      color: Colors.black, width: 1),
                                  verticalInside: const BorderSide(
                                      color: Colors.black, width: 1),
                                  horizontalInside: const BorderSide(
                                      color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                columns: [
                                  const DataColumn(label: Text('')),
                                  ...List.generate(
                                    kundlicontroller
                                            .ashtakvargaPoints.isNotEmpty
                                        ? kundlicontroller
                                            .ashtakvargaPoints[0].length
                                        : 0,
                                    (index) => DataColumn(
                                        label: Text('Col ${index + 1}')),
                                  ),
                                ],
                                rows: [
                                  ...List.generate(
                                    kundlicontroller.ashtakvargaList.length,
                                    (index) => DataRow(
                                      cells: [
                                        DataCell(Text(kundlicontroller
                                            .ashtakvargaList[index])),
                                        ...List.generate(
                                          kundlicontroller
                                                  .ashtakvargaPoints.isNotEmpty
                                              ? kundlicontroller
                                                  .ashtakvargaPoints[index]
                                                  .length
                                              : 0,
                                          (i) => DataCell(Text(
                                            kundlicontroller
                                                .ashtakvargaPoints[index][i]
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.sp),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataRow(
                                    cells: [
                                      const DataCell(Text('Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                      ...List.generate(
                                        kundlicontroller
                                            .ashtakvargaTotal.length,
                                        (i) => DataCell(Text(
                                          kundlicontroller.ashtakvargaTotal[i]
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.sp),
                                        )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 7.h),
                          SizedBox(
                            height: 6.h,
                            child: Text(
                              'binnashtakvarga',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ).tr(),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth,
                              maxHeight: constraints.maxHeight,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: DataTable(
                                border: TableBorder(
                                  left: const BorderSide(
                                      color: Colors.black, width: 1),
                                  right: const BorderSide(
                                      color: Colors.black, width: 1),
                                  bottom: const BorderSide(
                                      color: Colors.black, width: 1),
                                  top: const BorderSide(
                                      color: Colors.black, width: 1),
                                  verticalInside: const BorderSide(
                                      color: Colors.black, width: 1),
                                  horizontalInside: const BorderSide(
                                      color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                columns: [
                                  ...List.generate(
                                    kundlicontroller.columns.length,
                                    (index) => DataColumn(
                                        label: Text(
                                                kundlicontroller.columns[index])
                                            .tr()),
                                  ),
                                ],
                                rows: [
                                  ...List.generate(
                                    kundlicontroller.maxRows!.toInt(),
                                    (rowIndex) => DataRow(
                                      cells: [
                                        ...List.generate(
                                          kundlicontroller.columns.length,
                                          (colIndex) => DataCell(
                                            Text(
                                              kundlicontroller
                                                  .binnashtakvargaData![
                                                      kundlicontroller.columns[
                                                          colIndex]]![rowIndex]
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: 100.w,
                        height: constraints.maxHeight,
                        child: const Center(child: CircularProgressIndicator()),
                      )),
          ),
        ),
      ),
    );
  }
}
