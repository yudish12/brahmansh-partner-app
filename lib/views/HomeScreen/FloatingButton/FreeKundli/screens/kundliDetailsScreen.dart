// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../controllers/free_kundli_controller.dart';

// ignore: must_be_immutable
class KundliDetailsScreen extends StatefulWidget {
  String pdfLink;
  KundliDetailsScreen({super.key, required this.pdfLink});

  @override
  State<KundliDetailsScreen> createState() => _KundliDetailsScreenState();
}

class _KundliDetailsScreenState extends State<KundliDetailsScreen> {
  final kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    log('pdf link is ${widget.pdfLink}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        title: Text(
          'Kundli',
          style: Get.theme.primaryTextTheme.titleLarge!.copyWith(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white),
        ).tr(),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
              kIsWeb
                  ? Icons.arrow_back
                  : Platform.isIOS
                      ? Icons.arrow_back_ios
                      : Icons.arrow_back,
              color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () async {
              String encodedUrl = Uri.encodeFull(widget.pdfLink);

              await Share.share(
                "Hey! I am using AstrowayPro to get predictions related to marriage/career.Check my Kundali with .You should also try and see your Kundali ! \n\n\n\n"
                "$encodedUrl",
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
              child: const Row(
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfLink,
        onDocumentLoadFailed: (e) {
          global.showToast(message: "PDF Failed to Load");
          Get.back();
        },
        onDocumentLoaded: (e) {},
      ),
    );
  }
}
