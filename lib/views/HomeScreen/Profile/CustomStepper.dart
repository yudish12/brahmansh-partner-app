import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomStepper extends StatelessWidget {
  final int currentIndex;
  final String stepTitle;
  final IconData stepIcon;
  final List<String> stepLabels;

  const CustomStepper({
    super.key,
    required this.currentIndex,
    required this.stepTitle,
    required this.stepIcon,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Stepper Title
          Row(
            children: [
              Icon(
                stepIcon,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Step ${currentIndex + 1} of 6",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Text(
                stepTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: COLORS().primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Custom Stepper
          SizedBox(
            height: 4,
            child: Row(
              children: List.generate(6, (index) {
                bool isActive = currentIndex >= index;
                bool isCurrent = currentIndex == index;

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color:
                          isActive ? COLORS().primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: COLORS().primaryColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        if (isCurrent)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(
                                  colors: [
                                    COLORS().primaryColor,
                                    COLORS().primaryColor.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Step Labels
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: stepLabels.asMap().entries.map((entry) {
                return buildStepLabel(entry.key, entry.value, currentIndex);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStepLabel(int stepIndex, String label, int currentIndex) {
    bool isActive = currentIndex >= stepIndex;
    bool isCurrent = currentIndex == stepIndex;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 7.sp,
            fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
            color: isActive ? COLORS().primaryColor : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
