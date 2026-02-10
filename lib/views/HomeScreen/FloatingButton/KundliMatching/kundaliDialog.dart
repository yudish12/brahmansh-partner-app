// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/kundli_matchig_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class KundliDialog extends StatefulWidget {
  const KundliDialog({super.key});

  @override
  _MyDialogState createState() => _MyDialogState();
}

final KundliMatchingController kundliMatchingController =
    Get.find<KundliMatchingController>();

class _MyDialogState extends State<KundliDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Direction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('South'),
            leading: Radio(
              activeColor: COLORS().primaryColor,
              value: 'South',
              groupValue: kundliMatchingController.selectedDirection,
              onChanged: (value) {
                setState(() {});
                kundliMatchingController.onDireactionChanged(value.toString());
              },
            ),
          ),
          ListTile(
            title: const Text('North'),
            leading: Radio(
              activeColor: COLORS().primaryColor,
              value: 'North',
              groupValue: kundliMatchingController.selectedDirection,
              onChanged: (value) {
                setState(() {});
                kundliMatchingController.onDireactionChanged(value.toString());
              },
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap:
            () async {
              Get.back();

              await kundliMatchingController.addKundliMatchData(true);
            },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 1.h
            ),
            decoration: BoxDecoration(
              color: COLORS().primaryColor,
              borderRadius: BorderRadius.circular(10.sp)
            ),
            child:  Text('OK',
            style: TextStyle(
              color: COLORS().textColor
            ),),
          ),
        ),
      ],
    );
  }
}
