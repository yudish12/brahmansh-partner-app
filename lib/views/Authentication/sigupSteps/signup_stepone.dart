import 'dart:developer';
import 'package:brahmanshtalk/views/Authentication/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/colorConst.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../utils/config.dart';
import '../../../widgets/common_padding.dart';
import '../../../widgets/common_textfield_widget.dart';
import '../../HomeScreen/Profile/CustomStepper.dart';
import '../../HomeScreen/Profile/StepperConfig.dart';

class SignupStepOne extends StatefulWidget {
  const SignupStepOne({super.key, required this.signupController});

  final SignupController signupController;

  @override
  State<SignupStepOne> createState() => _SignupStepOneState();
}

class _SignupStepOneState extends State<SignupStepOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.h),
      child: Column(
        children: [
          CustomStepper(
            currentIndex: widget.signupController.index,
            stepTitle: StepperConfig.stepConfigs[0]!['title'] as String,
            stepIcon: StepperConfig.stepConfigs[0]!['icon'] as IconData,
            stepLabels: StepperConfig.stepConfigs[0]!['labels'] as List<String>,
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
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Personal Details Form
                    _buildPersonalDetailsForm(),

                    // Terms & Conditions
                    _buildTermsAndConditions(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Personal Details Form
  Widget _buildPersonalDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          _buildFormField(
            label: "Full Name",
            icon: Icons.person_2_outlined,
            child: CommonTextFieldWidget(
              hintText: tr("Enter your full name"),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              formatter: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
              ],
              textEditingController: widget.signupController.cName,
              focusNode: widget.signupController.fName,
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.dsplyfName);
              },
            ),
          ),

          SizedBox(height: 3.w),

          // Display Name Field
          _buildFormField(
            label: "Display Name",
            icon: Icons.badge_outlined,
            child: CommonTextFieldWidget(
              maxLines: 1,
              hintText: tr("How would you like to be called"),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              formatter: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
              ],
              textEditingController: widget.signupController.dsplyName,
              focusNode: widget.signupController.dsplyfName,
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fEmail);
              },
            ),
          ),

          SizedBox(height: 3.w),

          // Email Field
          _buildFormField(
            label: "Email Address",
            icon: Icons.email_outlined,
            child: CommonTextFieldWidget(
              hintText: "your@gmail.com",
              keyboardType: TextInputType.emailAddress,
              textEditingController: widget.signupController.cEmail,
              focusNode: widget.signupController.fEmail,
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fMobileNumber);
              },
            ),
          ),

          SizedBox(height: 3.w),

          // Mobile Number Field
          _buildFormField(
            label: "Mobile Number",
            icon: Icons.phone_iphone_outlined,
            child: _buildPhoneNumberWidget(widget.signupController),
          ),
        ],
      ),
    );
  }

  // Terms & Conditions Section
  Widget _buildTermsAndConditions() {
    return Container(
      margin: EdgeInsets.only(top: 1.w),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  margin: EdgeInsets.only(right: 12, top: 1.4.h),
                  height: 24,
                  width: 24,
                  child: Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      activeColor: COLORS().primaryColor,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: widget.signupController.termAndCondtion.value,
                      onChanged: (value) {
                        widget.signupController.termAndCondtion.value = value!;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse(termsconditionurl));
                      },
                      child: RichText(
                        text: TextSpan(
                          style:
                              Get.theme.primaryTextTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: tr("I agree to the "),
                            ),
                            TextSpan(
                              text: tr("Terms and Conditions"),
                              style: TextStyle(
                                color: COLORS().primaryColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: tr(" and acknowledge the privacy policy"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Form Field Builder
  Widget _buildFormField(
      {required String label, required IconData icon, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: COLORS().primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ).tr(),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  // Phone Number Widget
  Widget _buildPhoneNumberWidget(SignupController signupController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          dialogTheme: DialogThemeData(
            contentTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.grey[800],
            surfaceTintColor: Colors.grey[800],
          ),
        ),
        child: SizedBox(
          child: InternationalPhoneNumberInput(
            spaceBetweenSelectorAndTextField: 0,
            selectorButtonOnErrorPadding: 0,
            maxLength: 10,
            scrollPadding: EdgeInsets.zero,
            textFieldController: widget.signupController.cMobileNumber,
            inputDecoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 3.2.w, horizontal: 12),
              border: InputBorder.none,
              hintText: 'Enter phone number',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.sp,
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w400,
              ),
              counterText: '',
            ),
            onInputValidated: (bool value) {
              debugPrint('$value');
            },
            selectorConfig: const SelectorConfig(
              trailingSpace: false,
              leadingPadding: 2,
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              setSelectorButtonAsPrefixIcon: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            searchBoxDecoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search country",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            initialValue: initialPhone,
            formatInput: false,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: false),
            inputBorder: InputBorder.none,
            onSaved: (PhoneNumber number) {
              log('On Saved: ${number.dialCode}');
              widget.signupController.updateCountryCode(number.dialCode);
              widget.signupController.update();
              widget.signupController
                  .updatephoneno(widget.signupController.cMobileNumber.text);
              widget.signupController.update();
            },
            onFieldSubmitted: (value) {
              log('On onFieldSubmitted: $value');
            },
            onInputChanged: (PhoneNumber number) {
              log('On onInputChanged: ${number.dialCode}');
              log('On length: ${widget.signupController.cMobileNumber.text.length}');
              widget.signupController.updateCountryCode(number.dialCode);
              // UnFocus KeyBoard Mobile Number Length 10
              if (widget.signupController.cMobileNumber.text.length == 10) {
                widget.signupController.fMobileNumber.unfocus();
              }
              widget.signupController.update();
              widget.signupController
                  .updatephoneno(widget.signupController.cMobileNumber.text);
              widget.signupController.update();
            },
            onSubmit: () {
              log('On onSubmit:');
            },
          ),
        ),
      ),
    );
  }
}
