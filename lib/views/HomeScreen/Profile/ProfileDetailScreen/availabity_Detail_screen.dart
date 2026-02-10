// ignore_for_file: file_names, must_be_immutable

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailabiltyScreen extends StatelessWidget {
  AvailabiltyScreen({super.key});
  SignupController signupController = Get.find<SignupController>();

  Widget _buildTimeChip(String timeRange, bool isLast) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            COLORS().primaryColor.withOpacity(0.1),
            COLORS().primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: COLORS().primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 14,
            color: COLORS().blackColor,
          ),
          const SizedBox(width: 6),
          Text(
            timeRange,
            style: TextStyle(
              color: COLORS().blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(int index, BuildContext context) {
    final dayData = signupController.astrologerList[0]!.week![index];
    final hasTimeSlots = dayData.timeAvailabilityList!.isNotEmpty;
    final hasValidTimeSlots = hasTimeSlots &&
        dayData.timeAvailabilityList!.any((slot) =>
            slot.fromTime != null &&
            slot.fromTime!.isNotEmpty &&
            slot.toTime != null &&
            slot.toTime!.isNotEmpty);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  COLORS().primaryColor.withOpacity(0.4),
                  COLORS().primaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.01),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getDayIcon(dayData.day!),
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    dayData.day!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hasValidTimeSlots ? "Available" : "Not Available",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Time Slots
          Padding(
            padding: const EdgeInsets.all(16),
            child: hasValidTimeSlots
                ? Wrap(
                    children: [
                      for (int i = 0;
                          i < dayData.timeAvailabilityList!.length;
                          i++)
                        if (dayData.timeAvailabilityList![i].fromTime != null &&
                            dayData.timeAvailabilityList![i].fromTime!
                                .isNotEmpty &&
                            dayData.timeAvailabilityList![i].toTime != null &&
                            dayData.timeAvailabilityList![i].toTime!.isNotEmpty)
                          _buildTimeChip(
                            "${dayData.timeAvailabilityList![i].fromTime!} - ${dayData.timeAvailabilityList![i].toTime!}",
                            i == dayData.timeAvailabilityList!.length - 1,
                          ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No time slots added",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ).tr(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getDayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.calendar_today;
      case 'tuesday':
        return Icons.calendar_view_week;
      case 'wednesday':
        return Icons.calendar_view_month;
      case 'thursday':
        return Icons.date_range;
      case 'friday':
        return Icons.weekend;
      case 'saturday':
        return Icons.beach_access;
      case 'sunday':
        return Icons.free_breakfast;
      default:
        return Icons.calendar_today;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule_outlined,
                size: 50,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Availability Set",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ).tr(),
            const SizedBox(height: 12),
            Text(
              "You haven't set your availability yet. Add your working hours to start receiving bookings.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ).tr(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add functionality to set availability
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: COLORS().primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Set Availability",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: MyCustomAppBar(
        iconData:  IconThemeData(color: COLORS().textColor),
        height: 80,
        backgroundColor: COLORS().primaryColor,
        title:  Text("Availability", style: TextStyle(color: COLORS().textColor))
            .tr(),
      ),
      body: GetBuilder<SignupController>(
        builder: (signupController) {
          final isEmpty = signupController.astrologerList[0]!.week!.isEmpty ||
              signupController.astrologerList[0]!.week == [];

          if (isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Header Info Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      COLORS().primaryColor.withOpacity(0.1),
                      COLORS().primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: COLORS().primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: COLORS().blackColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Your weekly availability schedule",
                        style: TextStyle(
                          color: COLORS().blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                    ),
                  ],
                ),
              ),

              // Days List
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: signupController.astrologerList[0]!.week!.length,
                  itemBuilder: (context, index) {
                    return _buildDayCard(index, context);
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
