import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/colorConst.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../utils/global.dart' as global;
import '../../../widgets/common_drop_down.dart';
import '../../../widgets/common_padding.dart';
import '../../../widgets/common_textfield_widget.dart';
import '../../HomeScreen/Profile/CustomStepper.dart';
import '../../HomeScreen/Profile/StepperConfig.dart';

class SignupthreeWidget extends StatefulWidget {
  const SignupthreeWidget({super.key, required this.signupController});
  final SignupController signupController;

  @override
  State<SignupthreeWidget> createState() => _SignupthreeWidgetState();
}

class _SignupthreeWidgetState extends State<SignupthreeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            stepTitle: StepperConfig.stepConfigs[2]!['title'] as String,
            stepIcon: StepperConfig.stepConfigs[2]!['icon'] as IconData,
            stepLabels: StepperConfig.stepConfigs[2]!['labels'] as List<String>,
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
            child: CommonPadding(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Header Section
                  // _buildHeaderSection(),
                  
                  // Interview & Location Section
                  _buildInterviewLocationSection(),
                  
                  // Education & Background Section
                  _buildEducationBackgroundSection(),
                  
                  // Earning Expectations Section
                  _buildEarningExpectationsSection(),
                  
                  // Bio Section
                  _buildBioSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  // Interview & Location Section
  Widget _buildInterviewLocationSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Interview & Location",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          _buildFormField(
            label: "Why do you think we should onboard you?",
            child: CommonTextFieldWidget(
              hintText: tr("Why we should on board you?"),
              textEditingController: widget.signupController.cOnBoardYou,
              focusNode: widget.signupController.fOnBoardYou,
              formatter: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
              ],
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fTimeForInterview);
              },
            ),
          ),

          const SizedBox(height: 16),

          _buildFormField(
            label: "What is suitable time for interview?",
            child: CommonTextFieldWidget(
              maxLines: 1,
              hintText: tr("Enter Suitable Time For Interview"),
              textEditingController: widget.signupController.cTimeForInterview,
              focusNode: widget.signupController.fTimeForInterview,
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fLiveCity);
              },
              onTap: () {
                widget.signupController.fTimeForInterview.unfocus();
                widget.signupController.timeforInterView(context);
                widget.signupController.update();
              },
            ),
          ),

          // const SizedBox(height: 16),

          // _buildFormField(
          //   label: "Which city do you currently live in? (Optional)",
          //   child: CommonTextFieldWidget(
          //     hintText: "Bardoli",
          //     textEditingController: widget.signupController.cLiveCity,
          //     focusNode: widget.signupController.fLiveCity,
          //     formatter: [
          //       FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
          //     ],
          //     onFieldSubmitted: (f) {
          //       FocusScope.of(context).unfocus();
          //     },
          //   ),
          // ),
       
       
        ],
      ),
    );
  }

  // Education & Background Section
  Widget _buildEducationBackgroundSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Education & Background",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          _buildFormField(
            label: "Main source of business (other than astrology)?",
            child: CommonDropDown(
              val: widget.signupController.selectedSourceOfBusiness,
              list: global.mainSourceBusinessModelList!
                  .map((e) => e.jobName)
                  .toList(),
              onTap: () {},
              onChanged: (selectedValue) {
                widget.signupController.selectedSourceOfBusiness = selectedValue;
                widget.signupController.update();
              },
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Highest Qualification",
                  child: CommonDropDown(
                    val: widget.signupController.selectedHighestQualification,
                    list: global.highestQualificationModelList!
                        .map((e) => e.qualificationName)
                        .toList(),
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.signupController.selectedHighestQualification = selectedValue;
                      widget.signupController.update();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  label: "Degree / Diploma",
                  child: CommonDropDown(
                    val: widget.signupController.selectedDegreeDiploma,
                    list: global.degreeDiplomaList!
                        .map((e) => e.degreeName)
                        .toList(),
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.signupController.selectedDegreeDiploma = selectedValue;
                      widget.signupController.update();
                    },
                  ),
                ),
              ),
            ],
          ),

          // const SizedBox(height: 16),

          // _buildFormField(
          //   label: "College/School/University (Optional)",
          //   child: CommonTextFieldWidget(
          //     maxLines: 1,
          //     hintText: tr("Enter your College/School/University Name"),
              
          //     textEditingController: widget.signupController.cCollegeSchoolUniversity,
          //     focusNode: widget.signupController.fCollegeSchoolUniversity,
          //     formatter: [
          //       FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
          //     ],
          //     onFieldSubmitted: (f) {
          //       FocusScope.of(context)
          //           .requestFocus(widget.signupController.fLearnAstroLogy);
          //     },
          //   ),
          // ),

          // const SizedBox(height: 16),

          // _buildFormField(
          //   label: "From where did you learn Skills? (Optional)",
          //   child: CommonTextFieldWidget(
          //     hintText: tr("From where did you learn Skills?"),
          //     textEditingController: widget.signupController.cLearnAstrology,
          //     formatter: [
          //       FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
          //     ],
          //     focusNode: widget.signupController.fLearnAstroLogy,
          //     onFieldSubmitted: (f) {
          //       FocusScope.of(context).requestFocus(widget.signupController.fInsta);
          //     },
          //   ),
          // ),
        
        ],
      ),
    );
  }

 
  // Earning Expectations Section
  Widget _buildEarningExpectationsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Earning Expectations",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Min Earning Expectation",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cExptectedMinimumEarning,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    focusNode: widget.signupController.fExpectedMinimumEarning,
                    counterText: '',
                    maxLength: 5,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fExpectedMaximumEarning);
                    },
                    hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  label: "Max Earning Expectation",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cExpectedMaximumEarning,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    focusNode: widget.signupController.fExpectedMaximumEarning,
                    counterText: '',
                    maxLength: 7,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fLongBio);
                    },
                    hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bio Section
  Widget _buildBioSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Professional Bio",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          _buildFormField(
            label: "Long Bio",
            child: CommonTextFieldWidget(
              maxLines: 5,
              textEditingController: widget.signupController.cLongBio,
              focusNode: widget.signupController.fLongBio,
              contentPadding: const EdgeInsets.all(12),
              onFieldSubmitted: (f) {
                FocusScope.of(context).unfocus();
              },
              hintText: tr("Describe your professional background, skills, and experience..."),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ).tr(),
        const SizedBox(height: 6),
        child,
      ],
    );
  }


}