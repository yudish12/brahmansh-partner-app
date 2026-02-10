import 'dart:io';

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/models/History/report_history_model.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewReportPdfScreen extends StatelessWidget {
  int? flag = 0;
  File? file;
  final ReportHistoryModel? reportHistoryData;
  ViewReportPdfScreen(
      {super.key, this.reportHistoryData, this.flag, this.file});
  final SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          iconData: IconThemeData(color: COLORS().whiteColor),
          backgroundColor: COLORS().primaryColor,
          title: Text(
            "PDF",
            style: TextStyle(color: COLORS().whiteColor),
          ),
        ),
        body: flag == 1 && file != null
            ? SfPdfViewer.file(file!)
            : SfPdfViewer.network(
                '${reportHistoryData!.reportFile}',
                enableDocumentLinkAnnotation: false,
              ),
      ),
    );
  }
}
