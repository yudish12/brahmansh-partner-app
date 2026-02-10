// ignore_for_file: must_be_immutable, file_names

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/callAvailability_controller.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get/get.dart';

class CallAvailabilityScreen extends StatefulWidget {
  const CallAvailabilityScreen({super.key});

  @override
  State<CallAvailabilityScreen> createState() => _CallAvailabilityScreenState();
}

class _CallAvailabilityScreenState extends State<CallAvailabilityScreen> {
  final callAvailabilityController = Get.find<CallAvailabilityController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callAvailabilityController.loadCallAvailabilityFromPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
            iconData:  IconThemeData(color:  COLORS().textColor),
            height: 80,
            backgroundColor: COLORS().primaryColor,
            title:  Text("Call Availability",
                    style: TextStyle(color: COLORS().textColor))
                .tr()),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<CallAvailabilityController>(
              builder: (callAvailabilityController) {
            return Column(children: [
              ListTile(
                enabled: true,
                tileColor: Colors.white,
                title: Center(
                  child: Text(
                    "Change your availability for call",
                    style: Theme.of(context).primaryTextTheme.displaySmall,
                  ).tr(),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: callAvailabilityController.callType,
                    activeColor: COLORS().primaryColor,
                    onChanged: (val) {
                      callAvailabilityController.setCallAvailability(
                          val, "Online");
                      callAvailabilityController.showAvailableTime = true;
                      callAvailabilityController.update();
                    },
                  ),
                  Text(
                    'Online',
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                  ).tr()
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: callAvailabilityController.callType,
                    activeColor: COLORS().primaryColor,
                    onChanged: (val) {
                      callAvailabilityController.setCallAvailability(
                          val, "Offline");
                      callAvailabilityController.showAvailableTime = true;
                      callAvailabilityController.update();
                    },
                  ),
                  Text(
                    'Offline',
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                  ).tr()
                ],
              ),
            ]);
          }),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: COLORS().primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          height: 45,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () async {
              global.user.callStatus =
                  callAvailabilityController.callStatusName;
              global.user.dateTime = callAvailabilityController.waitTime.text;
              global.showOnlyLoaderDialog();
              //! Set Call Availibility Status online offline wait
              await callAvailabilityController.statusCallChange(
                  astroId: global.user.id!,
                  callStatus: callAvailabilityController.callStatusName,
                  callTime: callAvailabilityController.waitTime.text);
              global.hideLoader();
              callAvailabilityController.showAvailableTime = true;
              callAvailabilityController.update();
              Get.back();
            },
            child:  Text(
              "Submit",
              style: TextStyle(color:  COLORS().textColor),
            ).tr(),
          ),
        ),
      ),
    );
  }
}
