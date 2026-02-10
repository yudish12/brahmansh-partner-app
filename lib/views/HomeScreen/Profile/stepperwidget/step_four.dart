import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/HomeController/edit_profile_controller.dart';
import '../../../../utils/global.dart' as global;
import '../../../../widgets/common_drop_down.dart';
import '../../../../widgets/common_textfield_widget.dart';
import '../stepper_one.dart';

class StepFourWidget extends StatefulWidget {
  const StepFourWidget({super.key , required this.editProfileController});

  final EditProfileController editProfileController;

  @override
  State<StepFourWidget> createState() => _StepFourWidgetState();
}

class _StepFourWidgetState extends State<StepFourWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          // Background Information Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.public_rounded,
                        color: Color(0xFF667eea),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Background & Experience",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),

                // Full time job
                buildFormFieldWithIcon(
                  label: "Are you currently working a \n fulltime job?",
                  icon: Icons.work_outline_rounded,
                  child: CommonDropDown(
                    val: widget.editProfileController.selectedCurrentlyWorkingJob,
                    list:
                        global.jobWorkingList!.map((e) => e.workName).toList(),
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.editProfileController.selectedCurrentlyWorkingJob =
                          selectedValue;
                      widget.editProfileController.update();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Astrologer Qualities Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Astrologer Qualities",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Good qualities
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "What are some good qualities \n of a perfect astrologer?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: CommonTextFieldWidget(
                          readOnly: true,
                          maxLines: 5,
                          textEditingController:
                              widget.editProfileController.cGoodQuality,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          hintText:
                              "Describe the qualities that make a great astrologer...",
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Professional Scenarios Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.chalkboard,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Professional Scenarios",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Biggest challenge
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "What was the biggest challenge you  \nfaced and how did you overcome it?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: CommonTextFieldWidget(
                          readOnly: true,
                          maxLines: 5,
                          textEditingController:
                              widget.editProfileController.cBiggestChallenge,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          hintText:
                              "Describe your biggest challenge and solution...",
                          contentPadding: const EdgeInsets.all(12),
                          onFieldSubmitted: (f) {
                            FocusScope.of(context).requestFocus(
                                widget.editProfileController.fRepeatedQuestion);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Repeated question scenario
                Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.repeat_rounded,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "A customer is asking the same question \n repeatedly: what will you do?",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: CommonTextFieldWidget(
                          readOnly: true,
                          maxLines: 5,
                          textEditingController:
                              widget.editProfileController.cRepeatedQuestion,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          hintText:
                              "Describe how you would handle this situation...",
                          contentPadding: const EdgeInsets.all(12),
                          onFieldSubmitted: (f) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tips Section
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Take your time to provide thoughtful answers. These scenarios help us understand your problem-solving approach and professional mindset.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
