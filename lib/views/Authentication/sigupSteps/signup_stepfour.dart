import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/widgets/common_textfield_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/global.dart' as global;
import '../../../widgets/common_drop_down.dart';
import '../../../widgets/common_padding.dart';
import '../../../widgets/primary_text_widget.dart';
import '../../HomeScreen/Profile/CustomStepper.dart';
import '../../HomeScreen/Profile/StepperConfig.dart';

class SignupStepFour extends StatefulWidget {
  const SignupStepFour({super.key, required this.signupController});
  final SignupController signupController;
  @override
  State<SignupStepFour> createState() => _SignupStepFourState();
}

class _SignupStepFourState extends State<SignupStepFour> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: Column(
        children: [
          CustomStepper(
            currentIndex: widget.signupController.index,
            stepTitle: StepperConfig.stepConfigs[3]!['title'] as String,
            stepIcon: StepperConfig.stepConfigs[3]!['icon'] as IconData,
            stepLabels: StepperConfig.stepConfigs[3]!['labels'] as List<String>,
          ),
          SizedBox(height: 1.h),
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
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: PrimaryTextWidget(
                          text: "Are you currently working a fulltime job?"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: CommonDropDown(
                        height: 60,
                        val:
                            widget.signupController.selectedCurrentlyWorkingJob,
                        list: global.jobWorkingList!
                            .map(
                              (e) => e.workName,
                            )
                            .toList(),
                        onTap: () {},
                        onChanged: (selectedValue) {
                          widget.signupController.selectedCurrentlyWorkingJob =
                              selectedValue;
                          widget.signupController.update();
                        },
                      ),
                    ),
                    //good quality of astrologer
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: PrimaryTextWidget(
                          text: "Tell us about your good qualities "),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: CommonTextFieldWidget(
                        maxLines: 5,
                        textEditingController:
                            widget.signupController.cGoodQuality,
                        focusNode: widget.signupController.fGoodQuality,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fBiggestChallenge);
                        },
                        hintText: tr("Describe Here"),
                      ),
                    ),
                    //biggest challenge
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: PrimaryTextWidget(
                          text:
                              "What was the biggest challenge you faced and how did you overcome it?"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: CommonTextFieldWidget(
                        maxLines: 5,
                        textEditingController:
                            widget.signupController.cBiggestChallenge,
                        focusNode: widget.signupController.fBiggestChallenge,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fRepeatedQuestion);
                        },
                        hintText: tr("Describe Here"),
                      ),
                    ),
                    //same question repeatedly
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: PrimaryTextWidget(
                          text:
                              "A customer is asking the same question repeatedly: what will you do?"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: CommonTextFieldWidget(
                        maxLines: 5,
                        textEditingController:
                            widget.signupController.cRepeatedQuestion,
                        focusNode: widget.signupController.fRepeatedQuestion,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).unfocus();
                        },
                        hintText: tr("Describe Here"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
