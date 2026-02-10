import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/messageConst.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../models/time_availability_model.dart';
import '../../../models/week_model.dart';
import '../../../utils/global.dart' as global;
import '../../../widgets/common_padding.dart';
import '../../../widgets/common_textfield_widget.dart';
import '../../HomeScreen/Profile/CustomStepper.dart';
import '../../HomeScreen/Profile/StepperConfig.dart';

class SignupStepSix extends StatefulWidget {
  const SignupStepSix({super.key, required this.signupController});

  final SignupController signupController;

  @override
  State<SignupStepSix> createState() => _SignupStepSixState();
}

class _SignupStepSixState extends State<SignupStepSix> {
  FocusNode startavailabletimeFocus = FocusNode();
  FocusNode endavailableFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: Column(
        children: [
          // Custom Stepper
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomStepper(
              currentIndex: widget.signupController.index,
              stepTitle: StepperConfig.stepConfigs[5]!['title'] as String,
              stepIcon: StepperConfig.stepConfigs[5]!['icon'] as IconData,
              stepLabels:
                  StepperConfig.stepConfigs[5]!['labels'] as List<String>,
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: GetBuilder<SignupController>(
                builder: (signupController) => CommonPadding(
                  child: Column(
                    children: [
                      // Header Section
                      _buildHeaderSection(),
                      const SizedBox(height: 24),

                      // Daily Schedule Title
                      _buildScheduleTitle(),
                      const SizedBox(height: 16),

                      // Week Schedule
                      Expanded(
                        child: _buildWeekSchedule(signupController),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.indigo.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 40,
            color: Colors.purple[700],
          ),
          const SizedBox(height: 8),
          Text(
            "Set Your Availability",
            style: Get.theme.primaryTextTheme.displayMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ).tr(),
        ],
      ),
    );
  }

  // Schedule Title
  Widget _buildScheduleTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Daily Schedule Time',
            style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ).tr(),
        ],
      ),
    );
  }

  // Week Schedule
  Widget _buildWeekSchedule(SignupController signupController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: signupController.week!.length,
      itemBuilder: (BuildContext context, int index) {
        final day = signupController.week![index];
        return day.day != ""
            ? Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Name
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: _getDayColor(day.day!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          day.day!,
                          style:
                              Get.theme.primaryTextTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Time Slots
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          if (day.timeAvailabilityList!.isNotEmpty)
                            ...List.generate(
                              day.timeAvailabilityList!.length,
                              (i) => _buildTimeSlot(
                                  day, i, index, signupController),
                            ),
                        ],
                      ),
                    ),

                    // Add Button
                    const SizedBox(width: 12),
                    _buildAddButton(index, signupController),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }

  // Time Slot Widget
  Widget _buildTimeSlot(
      Week day, int i, int index, SignupController signupController) {
    final timeSlot = day.timeAvailabilityList![i];
    final hasTime = timeSlot.fromTime != "" && timeSlot.fromTime != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasTime
                  ? "${timeSlot.fromTime} - ${timeSlot.toTime}"
                  : "Tap to set time",
              style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                color: hasTime ? Colors.grey[800] : Colors.grey[500],
                fontWeight: hasTime ? FontWeight.w500 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          if (hasTime && day.timeAvailabilityList!.length > 1)
            GestureDetector(
              onTap: () => _showDeleteConfirmation(index, i, signupController),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.red[600],
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Add Button
  Widget _buildAddButton(int index, SignupController signupController) {
    return GestureDetector(
      onTap: () {
        signupController.clearTime();
        for (int j = 0;
            j < signupController.week![index].timeAvailabilityList!.length;
            j++) {
          if (signupController
                  .week![index].timeAvailabilityList!.last.fromTime !=
              "") {
            signupController.week![index].timeAvailabilityList!.add(
              TimeAvailabilityModel(fromTime: "", toTime: ""),
            );
          }
        }
        showAvailabilityDialog(
            context, 1, signupController.week![index].day!, index);
        signupController.update();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Get.theme.primaryColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmation(
      int dayIndex, int timeIndex, SignupController signupController) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Delete Time Slot?",
          style: Get.theme.primaryTextTheme.titleLarge,
        ).tr(),
        content: Text(
          "Are you sure you want to delete this time slot?",
          style: Get.theme.primaryTextTheme.titleMedium,
        ).tr(),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              MessageConstants.No,
              style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ).tr(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              signupController.week![dayIndex].timeAvailabilityList!
                  .removeWhere(
                (element) =>
                    element.fromTime ==
                    signupController.week![dayIndex]
                        .timeAvailabilityList![timeIndex].fromTime,
              );
              signupController.update();
              Get.back();
            },
            child: const Text(MessageConstants.YES).tr(),
          ),
        ],
      ),
    );
  }

  // Get Day Color
  Color _getDayColor(String day) {
    switch (day) {
      case "Sunday":
        return Colors.red[400]!;
      case "Monday":
        return Colors.blue[400]!;
      case "Tuesday":
        return Colors.green[400]!;
      case "Wednesday":
        return Colors.orange[400]!;
      case "Thursday":
        return Colors.purple[400]!;
      case "Friday":
        return Colors.teal[400]!;
      case "Saturday":
        return Colors.indigo[400]!;
      default:
        return Get.theme.primaryColor;
    }
  }

  // Availability Dialog
  void showAvailabilityDialog(
      BuildContext context, int days, String isTapDay, int widgetIndex) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Header
              Center(
                child: Text(
                  "Set Available Time",
                  style: Get.theme.primaryTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ).tr(),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "For $isTapDay",
                  style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Start Time
              _buildTimeField(
                label: 'Available Time Start',
                focusNode: startavailabletimeFocus,
                controller: widget.signupController.cStartTime,
                onTap: () {
                  startavailabletimeFocus.unfocus();
                  widget.signupController.selectStartTime(context);
                },
              ),
              const SizedBox(height: 16),

              // End Time
              _buildTimeField(
                label: 'Available Time End',
                focusNode: endavailableFocus,
                controller: widget.signupController.cEndTime,
                onTap: () {
                  endavailableFocus.unfocus();
                  widget.signupController.selectEndTime(context);
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ).tr(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _saveTimeSlot(isTapDay, widgetIndex),
                      child: const Text("Save").tr(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Time Field Builder
  Widget _buildTimeField({
    required String label,
    required FocusNode focusNode,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ).tr(),
        const SizedBox(height: 6),
        CommonTextFieldWidget(
          focusNode: focusNode,
          textEditingController: controller,
          hintText: tr('Select Time'),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          readOnly: false,
          suffixIcon: Icons.schedule_outlined,
          onTap: onTap,
        ),
      ],
    );
  }

  // Save Time Slot Logic
  VoidCallback _saveTimeSlot(String isTapDay, int widgetIndex) {
    return () {
      if (widget.signupController.cStartTime.text.isEmpty ||
          widget.signupController.cEndTime.text.isEmpty) {
        global.showToast(message: tr("Please select both start and end time"));
        return;
      }

      // Find empty slot and fill it
      for (int j = 0;
          j <
              widget.signupController.week![widgetIndex].timeAvailabilityList!
                  .length;
          j++) {
        if (widget.signupController.week![widgetIndex].timeAvailabilityList![j]
                .fromTime ==
            "") {
          widget.signupController.week![widgetIndex].timeAvailabilityList![j]
              .fromTime = widget.signupController.cStartTime.text;
          widget.signupController.week![widgetIndex].timeAvailabilityList![j]
              .toTime = widget.signupController.cEndTime.text;
          break;
        }
      }

      Get.back();
      widget.signupController.update();
    };
  }
}
