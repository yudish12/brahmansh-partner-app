// ignore_for_file: file_names

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/chatAvailability_controller.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatAvailabilityScreen extends StatefulWidget {
  const ChatAvailabilityScreen({super.key});

  @override
  State<ChatAvailabilityScreen> createState() => _ChatAvailabilityScreenState();
}

class _ChatAvailabilityScreenState extends State<ChatAvailabilityScreen> {
  final chatAvailabilityController = Get.find<ChatAvailabilityController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatAvailabilityController.loadChatAvailabilityFromPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          iconData:  IconThemeData(color: COLORS().textColor),
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title:  Text(
            "Chat Availability",
            style: TextStyle(color:COLORS().textColor),
          ).tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<ChatAvailabilityController>(
            builder: (chatAvaialble) {
              return Column(
                children: [
                  ListTile(
                    enabled: true,
                    tileColor: Colors.white,
                    title: Center(
                      child: Text(
                        "Change your availability for chat",
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ).tr(),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: chatAvailabilityController.chatType,
                        activeColor: COLORS().primaryColor,
                        onChanged: (val) {
                          chatAvailabilityController.setChatAvailability(
                            val,
                            "Online",
                          );
                          chatAvailabilityController.showAvailableTime = true;
                          chatAvailabilityController.update();
                        },
                      ),
                      Text(
                        'Online',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ).tr(),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: chatAvailabilityController.chatType,
                        activeColor: COLORS().primaryColor,
                        onChanged: (val) {
                          chatAvailabilityController.setChatAvailability(
                            val,
                            "Offline",
                          );
                          chatAvailabilityController.showAvailableTime = true;
                          chatAvailabilityController.update();
                        },
                      ),
                      Text(
                        'Offline',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ).tr(),
                    ],
                  ),
                ],
              );
            },
          ),
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
              global.user.chatStatus =
                  chatAvailabilityController.chatStatusName;
              global.user.dateTime = chatAvailabilityController.waitTime.text;

              global.showOnlyLoaderDialog();
              await chatAvailabilityController.statusChatChange(
                astroId: global.user.id!,
                chatStatus: chatAvailabilityController.chatStatusName,
                chatTime: chatAvailabilityController.waitTime.text,
              );
              global.hideLoader();
              chatAvailabilityController.showAvailableTime = true;
              chatAvailabilityController.update();
              Get.back();
            },
            child:  Text(
              "Submit",
              style: TextStyle(color: COLORS().textColor),
            ).tr(),
          ),
        ),
      ),
    );
  }
}
