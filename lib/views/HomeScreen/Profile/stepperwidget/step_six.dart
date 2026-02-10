import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/messageConst.dart';
import '../../../../controllers/HomeController/edit_profile_controller.dart';
import '../../../../models/time_availability_model.dart';
import '../../../../utils/global.dart' as global;
import '../../../../widgets/common_padding.dart';
import '../../../../widgets/common_textfield_widget.dart';
import '../CustomStepper.dart';
import '../StepperConfig.dart';

class StepSixWidget extends StatefulWidget {
  const StepSixWidget({super.key, required this.editProfileController});

  final EditProfileController editProfileController;

  @override
  State<StepSixWidget> createState() => _StepFiveWidgetState();
}

class _StepFiveWidgetState extends State<StepSixWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CommonPadding(
        child: ListView(
          children: [
            CustomStepper(
              currentIndex: widget.editProfileController.index,
              stepTitle: StepperConfig.stepConfigs[5]!['title'] as String,
              stepIcon: StepperConfig.stepConfigs[5]!['icon'] as IconData,
              stepLabels:
                  StepperConfig.stepConfigs[5]!['labels'] as List<String>,
            ),

            //------------------------------Availability-----------------------
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  "Set Your Availability",
                  style: Get.theme.primaryTextTheme.displayMedium,
                ).tr(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Daily Schedual Time',
                style: Get.theme.primaryTextTheme.displayMedium,
              ).tr(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.editProfileController.week!.length,
                itemBuilder: (BuildContext context, int index) {
                  return widget.editProfileController.week![index].day != ""
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  '${widget.editProfileController.week![index].day}',
                                  style: Get.theme.primaryTextTheme.titleMedium,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget
                                      .editProfileController
                                      .week![index]
                                      .timeAvailabilityList!
                                      .length,
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8.0),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            widget
                                                            .editProfileController
                                                            .week![index]
                                                            .timeAvailabilityList![
                                                                i]
                                                            .fromTime !=
                                                        "" &&
                                                    widget
                                                            .editProfileController
                                                            .week![index]
                                                            .timeAvailabilityList![
                                                                i]
                                                            .fromTime !=
                                                        null
                                                ? widget
                                                            .editProfileController
                                                            .week![index]
                                                            .timeAvailabilityList!
                                                            .length !=
                                                        1
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Get.dialog(
                                                              AlertDialog(
                                                                title: const Text(
                                                                        "Are you sure you want delete this time?")
                                                                    .tr(),
                                                                content: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Get.theme.primaryColor),
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child: const Text(MessageConstants.No)
                                                                            .tr(),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Get.theme.primaryColor),
                                                                        onPressed:
                                                                            () {
                                                                          widget
                                                                              .editProfileController
                                                                              .week![index]
                                                                              .timeAvailabilityList!
                                                                              .removeWhere((element) => element.fromTime == widget.editProfileController.week![index].timeAvailabilityList![i].fromTime);
                                                                          Get.back();
                                                                          widget
                                                                              .editProfileController
                                                                              .update();
                                                                        },
                                                                        child: const Text(MessageConstants.YES)
                                                                            .tr(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox()
                                                : const SizedBox(),
                                            Center(
                                              child: Text(
                                                widget
                                                                .editProfileController
                                                                .week![index]
                                                                .timeAvailabilityList![
                                                                    i]
                                                                .fromTime !=
                                                            "" &&
                                                        widget
                                                                .editProfileController
                                                                .week![index]
                                                                .timeAvailabilityList![
                                                                    i]
                                                                .fromTime !=
                                                            null
                                                    ? "${widget.editProfileController.week![index].timeAvailabilityList![i].fromTime} - "
                                                        "${widget.editProfileController.week![index].timeAvailabilityList![i].toTime}"
                                                    : "",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  widget.editProfileController.clearTime();
                                  for (int j = 0;
                                      j <
                                          widget
                                              .editProfileController
                                              .week![index]
                                              .timeAvailabilityList!
                                              .length;
                                      j++) {
                                    if (widget
                                            .editProfileController
                                            .week![index]
                                            .timeAvailabilityList!
                                            .last
                                            .fromTime !=
                                        "") {
                                      widget.editProfileController.week![index]
                                          .timeAvailabilityList!
                                          .add(
                                        TimeAvailabilityModel(
                                            fromTime: "", toTime: ""),
                                      );
                                    }
                                  }

                                  showAvailabilityDialog(
                                      context,
                                      1,
                                      widget.editProfileController.week![index]
                                          .day!,
                                      index);
                                  widget.editProfileController.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox();
                },
              ),
            ),

            //---End--
          ],
        ),
      ),
    );
  }

  //Availability Dialog
  showAvailabilityDialog(
      BuildContext context, int days, String isTapDay, int widgetIndex) {
    return Get.dialog(
      AlertDialog(
        title: Center(
          child: const Text("Set Your Time").tr(),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 1 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Time Start',
                      style: Get.theme.primaryTextTheme.titleMedium,
                    ).tr(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.editProfileController.cStartTime,
                        hintText: 'Select Time',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        readOnly: false,
                        suffixIcon: Icons.schedule_outlined,
                        onTap: () {
                          widget.editProfileController.selectStartTime(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Available Time End',
                        style: Get.theme.primaryTextTheme.titleMedium,
                      ).tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.editProfileController.cEndTime,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Select Time',
                        readOnly: false,
                        suffixIcon: Icons.schedule_outlined,
                        onTap: () {
                          widget.editProfileController.selectEndTime(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor),
            onPressed: () {
              if (isTapDay == "Sunday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Monday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Tuesday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Wednesday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Thursday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Friday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Saturday") {
                for (int j = 0;
                    j <
                        widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList!.length;
                    j++) {
                  if (widget.editProfileController.week![widgetIndex]
                          .timeAvailabilityList![j].fromTime ==
                      "") {
                    widget.editProfileController.week![widgetIndex]
                            .timeAvailabilityList![j].fromTime =
                        widget.editProfileController.cStartTime.text;
                    widget
                        .editProfileController
                        .week![widgetIndex]
                        .timeAvailabilityList![j]
                        .toTime = widget.editProfileController.cEndTime.text;
                  }
                }
              } else {
                global.showToast(message: "Please Select Any One Time");
              }
              Get.back();
              widget.editProfileController.update();
            },
            child: const Text("Done").tr(),
          ),
        ],
      ),
    );
  }
}
