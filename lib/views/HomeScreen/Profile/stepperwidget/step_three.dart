import 'package:brahmanshtalk/widgets/common_drop_down.dart'
    show CommonDropDown;
import 'package:flutter/material.dart';

import '../../../../constants/colorConst.dart';
import '../../../../controllers/HomeController/edit_profile_controller.dart';
import '../../../../utils/global.dart' as global;
import '../../../../widgets/common_textfield_widget.dart';
import '../stepper_one.dart';

class StepThreeWidget extends StatefulWidget {
  const StepThreeWidget({super.key, required this.editProfileController});

  final EditProfileController editProfileController;

  @override
  State<StepThreeWidget> createState() => _StepThreeWidgetState();
}

class _StepThreeWidgetState extends State<StepThreeWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          // Interview & Onboarding Card
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
                        color: COLORS().primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.work_outline,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Interview & Onboarding",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Why onboard you
                buildFormFieldWithIcon(
                  label: "Why should we onboard you?",
                  icon: Icons.help_outline,
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    maxLines: 1,
                    hintText: "Why we should on board you?",
                    textEditingController:
                        widget.editProfileController.cOnBoardYou,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),

                // Interview time
                buildFormFieldWithIcon(
                  label: "Suitable time for interview",
                  icon: Icons.access_time,
                  child: CommonTextFieldWidget(
                    maxLines: 1,
                    hintText: "Enter Suitable Time For Interview",
                    textEditingController:
                        widget.editProfileController.cTimeForInterview,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    readOnly: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    onTap: () {
                      widget.editProfileController.fTimeForInterview.unfocus();
                      widget.editProfileController.timeforInterView(context);
                      widget.editProfileController.update();
                    },
                  ),
                ),

                // Current city
                buildFormFieldWithIcon(
                  label: "Current city",
                  icon: Icons.location_on_outlined,
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    hintText: "Bardoli",
                    textEditingController:
                        widget.editProfileController.cLiveCity,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),

          // Education & Background Card
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
                        color: COLORS().primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Education & Background",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Source of business
                buildFormFieldWithIcon(
                  label: "Main source of business",
                  icon: Icons.business_center,
                  child: CommonDropDown(
                    isEditable: false,
                    val: widget.editProfileController.selectedSourceOfBusiness,
                    list: global.mainSourceBusinessModelList!
                        .map((e) => e.jobName)
                        .toList(),
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.editProfileController.selectedSourceOfBusiness =
                          selectedValue;
                      widget.editProfileController.update();
                    },
                  ),
                ),

                // Highest qualification
                buildFormFieldWithIcon(
                  label: "Highest qualification",
                  icon: Icons.workspace_premium,
                  child: CommonDropDown(
                    isEditable: false,
                    val: widget
                        .editProfileController.selectedHighestQualification,
                    list: global.highestQualificationModelList!
                        .map((e) => e.qualificationName)
                        .toList(),
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.editProfileController
                          .selectedHighestQualification = selectedValue;
                      widget.editProfileController.update();
                    },
                  ),
                ),

                // Degree/Diploma
                buildFormFieldWithIcon(
                  label: "Degree / Diploma",
                  icon: Icons.article_outlined,
                  child: CommonDropDown(
                    isEditable: false,
                    val: widget.editProfileController.selectedDegreeDiploma,
                    list: global.degreeDiplomaList!
                        .map((e) => e.degreeName)
                        .toList(),
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.editProfileController.selectedDegreeDiploma =
                          selectedValue;
                      widget.editProfileController.update();
                    },
                  ),
                ),

                // College/University
                buildFormFieldWithIcon(
                  label: "College/School/University (Optional)",
                  icon: Icons.account_balance_outlined,
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    maxLines: 1,
                    hintText: "Enter your College/School/University Name",
                    textEditingController:
                        widget.editProfileController.cCollegeSchoolUniversity,
                  ),
                ),

                // Learn astrology
                buildFormFieldWithIcon(
                  label: "Where did you learn Astrology?",
                  icon: Icons.psychology_outlined,
                  child: CommonTextFieldWidget(
                    maxLines: null, // null means auto-expand based on content
                    hintText: "From where did you learn Astrology?",
                    textEditingController:
                        widget.editProfileController.cLearnAstrology,
                  ),
                ),
              ],
            ),
          ),

          // Social Media Links Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            COLORS().primaryColor.withOpacity(0.8),
                            COLORS().primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Connect Your Social Media",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Add your profiles (Optional)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Horizontal Scrollable Social Media Links
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      buildSocialMediaCard(
                        "Instagram",
                        widget.editProfileController.cInsta,
                        Icons.camera_alt_rounded,
                        const Color(0xFFE4405F),
                        "https://instagram.com/",
                      ),
                      const SizedBox(width: 12),
                      buildSocialMediaCard(
                        "Facebook",
                        widget.editProfileController.cFacebook,
                        Icons.facebook_rounded,
                        const Color(0xFF1877F2),
                        "https://facebook.com/",
                      ),
                      const SizedBox(width: 12),
                      buildSocialMediaCard(
                        "LinkedIn",
                        widget.editProfileController.cLinkedIn,
                        Icons.linked_camera_rounded,
                        const Color(0xFF0A66C2),
                        "https://linkedin.com/in/",
                      ),
                      const SizedBox(width: 12),
                      buildSocialMediaCard(
                        "YouTube",
                        widget.editProfileController.cYoutube,
                        Icons.videocam_rounded,
                        const Color(0xFFFF0000),
                        "https://youtube.com/",
                      ),
                      const SizedBox(width: 12),
                      buildSocialMediaCard(
                        "Website",
                        widget.editProfileController.cWebSite,
                        Icons.language_rounded,
                        const Color(0xFF34A853),
                        "https://",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Referral & Expectations Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF667eea),
                            Color(0xFF764ba2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Referral & Income Expectations",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Share your referral and earning expectations",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Referral Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            color: COLORS().primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Were you referred to us?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Modern Radio Buttons
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: buildModernRadioOption(
                                value: 1,
                                groupValue:
                                    widget.editProfileController.referPerson,
                                label: "Yes",
                                icon: Icons.thumb_up_alt_rounded,
                                activeColor: const Color(0xFF10B981),
                                onChanged: (val) => widget.editProfileController
                                    .setReferPerson(val),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: buildModernRadioOption(
                                value: 2,
                                groupValue:
                                    widget.editProfileController.referPerson,
                                label: "No referral",
                                icon: Icons.thumb_down_alt_rounded,
                                activeColor: const Color(0xFFEF4444),
                                onChanged: (val) => widget.editProfileController
                                    .setReferPerson(val),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Referral Person Name (Conditional)
                      if (widget.editProfileController.referPerson == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Referrer's Name",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: TextField(
                                  controller: widget
                                      .editProfileController.cNameOfReferPerson,
                                  decoration: InputDecoration(
                                    hintText: "Enter referrer's name",
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    prefixIcon: Icon(
                                      Icons.person_rounded,
                                      color: Colors.grey[500],
                                      size: 18,
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Earning Expectations Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFf093fb).withOpacity(0.1),
                        const Color(0xFFf5576c).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_graph_rounded,
                            color: Color(0xFF8B5CF6),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Monthly Earning Expectations",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Min/Max Earnings in Single Line
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            // Minimum Earning
                            Expanded(
                              child: buildEarningField(
                                label: "Min Expected",
                                controller: widget.editProfileController
                                    .cExptectedMinimumEarning,
                                icon: Icons.arrow_downward_rounded,
                                color: const Color(0xFF10B981),
                                currency: global.getSystemFlagValue(
                                    global.systemFlagNameList.currency),
                              ),
                            ),

                            // Separator
                            Container(
                              width: 1,
                              height: 60,
                              color: Colors.grey[300],
                              child: Center(
                                child: Container(
                                  width: 20,
                                  height: 2,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),

                            // Maximum Earning
                            Expanded(
                              child: buildEarningField(
                                label: "Max Expected",
                                controller: widget.editProfileController
                                    .cExpectedMaximumEarning,
                                icon: Icons.arrow_upward_rounded,
                                color: const Color(0xFFEF4444),
                                currency: global.getSystemFlagValue(
                                    global.systemFlagNameList.currency),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ), // Long Bio Card
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
                        color: COLORS().primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Professional Bio",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildFormFieldWithIcon(
                  label: "Long bio",
                  icon: Icons.edit_note,
                  child: CommonTextFieldWidget(
                    maxLines: 5,
                    textEditingController:
                        widget.editProfileController.cLongBio,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    contentPadding: const EdgeInsets.all(12),
                    hintText:
                        "Describe your professional background and expertise...",
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
