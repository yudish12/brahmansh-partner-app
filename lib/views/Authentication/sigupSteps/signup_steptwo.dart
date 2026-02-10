import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../constants/messageConst.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../models/Master Table Model/all_skill_model.dart';
import '../../../models/Master Table Model/astrologer_category_list_model.dart';
import '../../../models/Master Table Model/language_list_model.dart';
import '../../../models/Master Table Model/primary_skill_model.dart';
import '../../../utils/global.dart' as global;
import '../../../widgets/common_drop_down.dart';
import '../../../widgets/common_padding.dart';
import '../../../widgets/common_textfield_widget.dart';
import '../../HomeScreen/Profile/CustomStepper.dart';
import '../../HomeScreen/Profile/StepperConfig.dart';

class SignupStepTwo extends StatefulWidget {
  const SignupStepTwo({super.key, required this.signupController});

  final SignupController signupController;

  @override
  State<SignupStepTwo> createState() => _SignupStepTwoState();
}

class _SignupStepTwoState extends State<SignupStepTwo> {
  FocusNode birthDateFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();
  FocusNode primaryskillFocus = FocusNode();
  FocusNode allskillFocus = FocusNode();
  FocusNode languageFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Stepper
        Container(
          margin: EdgeInsets.all(1.h),
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
            stepTitle: StepperConfig.stepConfigs[1]!['title'] as String,
            stepIcon: StepperConfig.stepConfigs[1]!['icon'] as IconData,
            stepLabels: StepperConfig.stepConfigs[1]!['labels'] as List<String>,
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

                  // Profile Photo Section
                  _buildProfilePhotoSection(),

                  // Personal Details Section
                  _buildPersonalDetailsSection(),

                  // Skills & Languages Section
                  _buildSkillsLanguagesSection(),

                  // Charges Section
                  _buildChargesSection(),

                  // Experience Section
                  _buildExperienceSection(),

                  // Bank Details Section
                  _buildBankDetailsSection(),

                  // Additional Info Section
                  _buildAdditionalInfoSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Profile Photo Section
  Widget _buildProfilePhotoSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Stack(
            clipBehavior: Clip.none,
            children: [
              widget.signupController.selectedImage != null
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.memory(
                            base64Decode(
                                widget.signupController.imagePath.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey[300]!,
                              Colors.grey[400]!,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
              Positioned(
                bottom: -5,
                right: MediaQuery.of(context).size.width / 2 - 85,
                child: Container(
                  decoration: BoxDecoration(
                    color: COLORS().primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        selectImageBottomSheetWidget(context),
                        backgroundColor: Colors.white,
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Personal Details Section
  Widget _buildPersonalDetailsSection() {
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
                Icons.person_outline,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Personal Details",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          // Gender
          _buildFormField(
            label: "Gender",
            child: CommonDropDown(
              val: widget.signupController.selectedGender,
              list: global.genderList.map((e) => e).toList(),
              onTap: () {},
              onChanged: (selectedValue) {
                widget.signupController.selectedGender = selectedValue;
                widget.signupController.update();
              },
            ),
          ),

          const SizedBox(height: 16),

          // Date of Birth
          _buildFormField(
            label: "DOB",
            child: CommonTextFieldWidget(
              focusNode: birthDateFocus,
              hintText: tr("Select Birth Date"),
              textEditingController: widget.signupController.cBirthDate,
              obscureText: false,
              readOnly: false,
              suffixIcon: Icons.calendar_month,
              onTap: () {
                birthDateFocus.unfocus();
                _selectDate(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Skills & Languages Section
  Widget _buildSkillsLanguagesSection() {
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
                Icons.psychology_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Skills & Languages",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          // Category
          _buildFormField(
            label: "Category",
            child: GetBuilder<SignupController>(
              init: widget.signupController,
              builder: (controller) {
                return CommonTextFieldWidget(
                  focusNode: categoryFocus,
                  hintText: tr("Choose Your category"),
                  textEditingController:
                      widget.signupController.cSelectCategory,
                  obscureText: false,
                  readOnly: false,
                  suffixIcon: Icons.arrow_drop_down,
                  onTap: () {
                    categoryFocus.unfocus();
                    _showCategoryDialog();
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Primary Skills
          _buildFormField(
            label: "Primary Skills",
            child: GetBuilder<SignupController>(
              init: widget.signupController,
              builder: (controller) {
                return CommonTextFieldWidget(
                  focusNode: primaryskillFocus,
                  hintText: tr("Choose Your Primary Skills"),
                  textEditingController: widget.signupController.cPrimarySkill,
                  obscureText: false,
                  readOnly: false,
                  suffixIcon: Icons.arrow_drop_down,
                  onTap: () {
                    primaryskillFocus.unfocus();
                    _showPrimarySkillsDialog();
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // All Skills
          _buildFormField(
            label: "All Skills",
            child: GetBuilder<SignupController>(
              init: widget.signupController,
              builder: (controller) {
                return CommonTextFieldWidget(
                  focusNode: allskillFocus,
                  hintText: tr("Choose Your All Skills"),
                  textEditingController: widget.signupController.cAllSkill,
                  obscureText: false,
                  readOnly: false,
                  suffixIcon: Icons.arrow_drop_down,
                  onTap: () {
                    allskillFocus.unfocus();
                    _showAllSkillsDialog();
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Language
          _buildFormField(
            label: "Language",
            child: GetBuilder<SignupController>(
              init: widget.signupController,
              builder: (controller) {
                return CommonTextFieldWidget(
                  focusNode: languageFocus,
                  hintText: tr("Choose Your Language"),
                  textEditingController: widget.signupController.cLanguage,
                  obscureText: false,
                  readOnly: false,
                  suffixIcon: Icons.arrow_drop_down,
                  onTap: () {
                    languageFocus.unfocus();
                    _showLanguageDialog();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Charges Section
  Widget _buildChargesSection() {
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
                Icons.attach_money_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Service Charges",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          // Two column layout for charges
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      label: "Local Charges/min",
                      child: CommonTextFieldWidget(
                        textEditingController: widget.signupController.cCharges,
                        focusNode: widget.signupController.fCharges,
                        formatter: [FilteringTextInputFormatter.digitsOnly],
                        counterText: '',
                        maxLength: 4,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fusdCharges);
                        },
                        hintText:
                            "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      label: "USD Charges/min",
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.signupController.cusdCharges,
                        focusNode: widget.signupController.fusdCharges,
                        formatter: [FilteringTextInputFormatter.digitsOnly],
                        counterText: '',
                        maxLength: 4,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fVideoCharges);
                        },
                        hintText: "\$20",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      label: "Video Charges",
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.signupController.cVideoCharges,
                        focusNode: widget.signupController.fVideoCharges,
                        counterText: '',
                        maxLength: 4,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fusdVideoCharges);
                        },
                        hintText:
                            "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      label: "USD Video Charges",
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.signupController.cusdVideoCharges,
                        focusNode: widget.signupController.fusdVideoCharges,
                        counterText: '',
                        maxLength: 4,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fReportCharges);
                        },
                        hintText: "\$20",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      label: "Report Charges",
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.signupController.cReportCharges,
                        focusNode: widget.signupController.fReportCharges,
                        counterText: '',
                        maxLength: 4,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context).requestFocus(
                              widget.signupController.fusdReportCharges);
                        },
                        hintText:
                            "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      label: "USD Report Charges",
                      child: CommonTextFieldWidget(
                        textEditingController:
                            widget.signupController.cusdReportCharges,
                        focusNode: widget.signupController.fusdReportCharges,
                        counterText: '',
                        maxLength: 4,
                        onFieldSubmitted: (f) {
                          FocusScope.of(context)
                              .requestFocus(widget.signupController.fExpirence);
                        },
                        hintText: "\$20",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Experience Section
  Widget _buildExperienceSection() {
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
                Icons.timeline_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Experience & Availability",
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
                  label: "Experience (Years)",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cExpirence,
                    focusNode: widget.signupController.fExpirence,
                    counterText: '',
                    maxLength: 2,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.signupController.fContributionHours);
                    },
                    hintText: tr("Experience"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  label: "Daily Hours",
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.signupController.cContributionHours,
                    focusNode: widget.signupController.fContributionHours,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    counterText: '',
                    maxLength: 2,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.signupController.fHearAboutAstroGuru);
                    },
                    hintText: tr("Hours per day"),
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

  // Bank Details Section
  Widget _buildBankDetailsSection() {
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
                Icons.account_balance_outlined,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Bank Details",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Details
          _buildFormField(
            label: "Whatsapp Number",
            child: CommonTextFieldWidget(
              textEditingController: widget.signupController.cwhatsappno,
              focusNode: widget.signupController.fwhatsappno,
              maxLength: 10,
              formatter: [FilteringTextInputFormatter.digitsOnly],
              counterText: '',
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fpancard);
              },
              hintText: tr("Whatsapp no"),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
            ),
          ),

          const SizedBox(height: 16),

          // Two column layout for document numbers
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Pancard Number",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cpancard,
                    focusNode: widget.signupController.fpancard,
                    counterText: '',
                    maxLength: 10,
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fadharno);
                    },
                    hintText: tr("Pancard no"),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  label: "Aadhar Number",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cadharno,
                    focusNode: widget.signupController.fadharno,
                    maxLength: 12,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    counterText: '',
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fIFSC);
                    },
                    hintText: tr("Aadhar no"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bank Information
          _buildFormField(
            label: "IFSC Code",
            child: CommonTextFieldWidget(
              textEditingController: widget.signupController.cIFSC,
              focusNode: widget.signupController.fIFSC,
              maxLength: 11,
              counterText: '',
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fbankbranch);
              },
              onChanged: (p0) {
                log("My Ifsc length ${widget.signupController.cIFSC.text.length}");
                log("My Ifsc codePo $p0");
                if (p0.length == 11) {
                  widget.signupController.getBankDetails(
                      widget.signupController.cIFSC.text.capitalize.toString());
                }
              },
              hintText: tr("IFSC"),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Bank Branch",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cbankbranch,
                    focusNode: widget.signupController.fbankbranch,
                    counterText: '',
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fbankname);
                    },
                    hintText: tr("Bank Branch"),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  label: "Bank Name",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.cbankname,
                    focusNode: widget.signupController.fbankname,
                    counterText: '',
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fbankname);
                    },
                    hintText: tr("Bank Name"),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildFormField(
            label: "Account Holder Name",
            child: CommonTextFieldWidget(
              textEditingController: widget.signupController.caccountHolderName,
              focusNode: widget.signupController.faccountHolderName,
              counterText: '',
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.faccountHolderName);
              },
              hintText: tr("Bank Account Holder Name"),
            ),
          ),

          const SizedBox(height: 16),

          _buildFormField(
            label: "Account Type",
            child: CommonDropDown(
              val: widget.signupController.defaultaccountType,
              list: widget.signupController.accountTypeOptions,
              onTap: () {},
              onChanged: (selectedValue) {
                widget.signupController.defaultaccountType = selectedValue;
                widget.signupController.update();
                log("Selected Account Type: ${widget.signupController.defaultaccountType}");
              },
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Account Number",
                  child: CommonTextFieldWidget(
                    textEditingController: widget.signupController.caccountno,
                    focusNode: widget.signupController.faccountno,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 18,
                    counterText: '',
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fupi);
                    },
                    hintText: tr("Account No"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormField(
                  label: "Confirm Account No",
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.signupController.cconfiaccountno,
                    focusNode: widget.signupController.fconfiaccountno,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 18,
                    counterText: '',
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.signupController.fupi);
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildFormField(
            label: "UPI ID",
            child: CommonTextFieldWidget(
              textEditingController: widget.signupController.cupi,
              focusNode: widget.signupController.fupi,
              counterText: '',
              onFieldSubmitted: (f) {
                FocusScope.of(context)
                    .requestFocus(widget.signupController.fHearAboutAstroGuru);
              },
              hintText: tr("UPI"),
            ),
          ),
        ],
      ),
    );
  }

  // Additional Info Section
  Widget _buildAdditionalInfoSection() {
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
                Icons.info_outline,
                color: COLORS().primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Additional Information",
                style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: "Where did you hear about Us? (Optional)",
            child: CommonTextFieldWidget(
              formatter: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
              ],
              focusNode: widget.signupController.fHearAboutAstroGuru,
              onFieldSubmitted: (f) {
                FocusScope.of(context).unfocus();
              },
              textEditingController:
                  widget.signupController.cHearAboutAstroGuru,
              hintText: "Youtube, Facebook",
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Are you working on any other platform?",
            style: Get.theme.primaryTextTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildRadioOption(
                      value: 1,
                      text: MessageConstants.YES,
                    ),
                  ),
                  Expanded(
                    child: _buildRadioOption(
                      value: 2,
                      text: MessageConstants.No,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.signupController.anyOnlinePlatform == 1) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border:
                    Border.all(color: COLORS().primaryColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
                color: COLORS().primaryColor.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: "Name of platform?",
                    child: CommonTextFieldWidget(
                      textEditingController:
                          widget.signupController.cNameOfPlatform,
                      focusNode: widget.signupController.fNameOfPlatform,
                      formatter: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                      ],
                      onFieldSubmitted: (f) {
                        FocusScope.of(context).requestFocus(
                            widget.signupController.fMonthlyEarning);
                      },
                      hintText: tr("Company Name"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    label: "Monthly Earning?",
                    child: CommonTextFieldWidget(
                      textEditingController:
                          widget.signupController.cMonthlyEarning,
                      focusNode: widget.signupController.fMonthlyEarning,
                      formatter: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 7,
                      counterText: '',
                      onFieldSubmitted: (f) {
                        FocusScope.of(context).unfocus();
                      },
                      hintText:
                          "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20000",
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildRadioOption({required int value, required String text}) {
    return GestureDetector(
      onTap: () {
        widget.signupController.setOnlinePlatform(value);
        widget.signupController.update();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.signupController.anyOnlinePlatform == value
              ? COLORS().primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.signupController.anyOnlinePlatform == value
                ? COLORS().primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio(
              value: value,
              groupValue: widget.signupController.anyOnlinePlatform,
              activeColor: COLORS().primaryColor,
              onChanged: (val) {
                widget.signupController.setOnlinePlatform(val);
                widget.signupController.update();
              },
            ),
            Text(
              text,
              style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                    color: widget.signupController.anyOnlinePlatform == value
                        ? COLORS().primaryColor
                        : Colors.grey[600],
                  ),
            ).tr(),
          ],
        ),
      ),
    );
  }

  // Dialog methods (keep the same implementation)
  void _showCategoryDialog() {
    Get.dialog(
      GetBuilder<SignupController>(
        init: widget.signupController,
        builder: (controller) {
          return AlertDialog(
            title: const Text("Select category").tr(),
            content: SizedBox(
              height: Get.height * 1 / 3,
              width: Get.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: global.astrologerCategoryModelList!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    checkColor: Colors.white,
                    tristate: false,
                    value: global.astrologerCategoryModelList![index].isCheck,
                    onChanged: (value) {
                      global.astrologerCategoryModelList![index].isCheck =
                          value;
                      widget.signupController.update();
                    },
                    title: Text(
                      global.astrologerCategoryModelList![index].name ??
                          tr("No category"),
                      style: Get.theme.primaryTextTheme.titleMedium,
                    ),
                    activeColor: COLORS().primaryColor,
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  for (int i = 0;
                      i < global.astrologerCategoryModelList!.length;
                      i++) {
                    if (global.astrologerCategoryModelList![i].isCheck ==
                        true) {
                      global.astrologerCategoryModelList![i].isCheck = false;
                    }
                  }
                  widget.signupController.cSelectCategory.text = "";
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Clear").tr(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  global.user.astrologerCategoryId = [];
                  widget.signupController.cSelectCategory.text = '';
                  for (int i = 0;
                      i < global.astrologerCategoryModelList!.length;
                      i++) {
                    if (global.astrologerCategoryModelList![i].isCheck ==
                        true) {
                      widget.signupController.cSelectCategory.text +=
                          "${global.astrologerCategoryModelList![i].name},";
                    }
                    if (i == global.astrologerCategoryModelList!.length - 1) {
                      widget.signupController.cSelectCategory.text = widget
                          .signupController.cSelectCategory.text
                          .substring(
                              0,
                              widget.signupController.cSelectCategory.text
                                      .length -
                                  1);
                    }
                    widget.signupController.astroId = global
                        .astrologerCategoryModelList!
                        .where((element) => element.isCheck == true)
                        .toList();
                  }
                  for (int j = 0;
                      j < widget.signupController.astroId.length;
                      j++) {
                    global.user.astrologerCategoryId!.add(
                        AstrolgoerCategoryModel(
                            id: widget.signupController.astroId[j].id));
                  }
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Done").tr(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPrimarySkillsDialog() {
    Get.dialog(
      GetBuilder<SignupController>(
        init: widget.signupController,
        builder: (controller) {
          return AlertDialog(
            title: const Text("Primary Skills").tr(),
            content: SizedBox(
              height: Get.height * 1 / 3,
              width: Get.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: global.skillModelList!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    checkColor: Colors.white,
                    tristate: false,
                    value: global.skillModelList![index].isCheck,
                    onChanged: (value) {
                      global.skillModelList![index].isCheck = value;
                      for (int i = 0; i < global.skillModelList!.length; i++) {
                        if (i != index) {
                          global.skillModelList![i].isCheck = false;
                          log("fjhsjfs");
                        }
                      }
                      widget.signupController.update();
                    },
                    title: Text(
                      global.skillModelList![index].name ?? tr("No Skills"),
                      style: Get.theme.primaryTextTheme.titleMedium,
                    ),
                    activeColor: COLORS().primaryColor,
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  for (int i = 0; i < global.skillModelList!.length; i++) {
                    if (global.skillModelList![i].isCheck == true) {
                      global.skillModelList![i].isCheck = false;
                    }
                  }
                  widget.signupController.cPrimarySkill.text = "";
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Clear").tr(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  global.user.primarySkillId = [];
                  widget.signupController.cPrimarySkill.text = '';
                  for (int i = 0; i < global.skillModelList!.length; i++) {
                    if (global.skillModelList![i].isCheck == true) {
                      widget.signupController.cPrimarySkill.text +=
                          "${global.skillModelList![i].name},";
                    }
                    if (i == global.skillModelList!.length - 1) {
                      widget.signupController.cPrimarySkill.text =
                          widget.signupController.cPrimarySkill.text.substring(
                              0,
                              widget.signupController.cPrimarySkill.text
                                      .length -
                                  1);
                    }
                    widget.signupController.primaryId = global.skillModelList!
                        .where((element) => element.isCheck == true)
                        .toList();
                  }
                  for (int j = 0;
                      j < widget.signupController.primaryId.length;
                      j++) {
                    global.user.primarySkillId!.add(PrimarySkillModel(
                        id: widget.signupController.primaryId[j].id!));
                  }
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Done").tr(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAllSkillsDialog() {
    Get.dialog(
      GetBuilder<SignupController>(
        init: widget.signupController,
        builder: (controller) {
          return AlertDialog(
            title: const Text("All Skills").tr(),
            content: SizedBox(
              height: Get.height * 1 / 3,
              width: Get.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: global.allSkillModelList!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    checkColor: Colors.white,
                    tristate: false,
                    value: global.allSkillModelList![index].isCheck,
                    onChanged: (value) {
                      global.allSkillModelList![index].isCheck = value ?? false;
                      widget.signupController.update();
                    },
                    title: Text(
                      global.allSkillModelList![index].name ?? tr("No Skills"),
                      style: Get.theme.primaryTextTheme.titleMedium,
                    ),
                    activeColor: COLORS().primaryColor,
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  for (int i = 0; i < global.allSkillModelList!.length; i++) {
                    if (global.allSkillModelList![i].isCheck == true) {
                      global.allSkillModelList![i].isCheck = false;
                    }
                  }
                  widget.signupController.cAllSkill.text = "";
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Clear").tr(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  global.user.allSkillId = [];
                  widget.signupController.cAllSkill.text = '';
                  for (int i = 0; i < global.allSkillModelList!.length; i++) {
                    if (global.allSkillModelList![i].isCheck == true) {
                      widget.signupController.cAllSkill.text +=
                          "${global.allSkillModelList![i].name},";
                    }
                    if (i == global.allSkillModelList!.length - 1) {
                      widget.signupController.cAllSkill.text =
                          widget.signupController.cAllSkill.text.substring(
                              0,
                              widget.signupController.cAllSkill.text.length -
                                  1);
                    }
                    widget.signupController.allId = global.allSkillModelList!
                        .where((element) => element.isCheck == true)
                        .toList();
                  }
                  for (int j = 0;
                      j < widget.signupController.allId.length;
                      j++) {
                    global.user.allSkillId!.add(AllSkillModel(
                        id: widget.signupController.allId[j].id!));
                  }
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Done").tr(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      GetBuilder<SignupController>(
        init: widget.signupController,
        builder: (controller) {
          return AlertDialog(
            title: const Text("All Language").tr(),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 2.3,
              width: Get.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: global.languageModelList!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    checkColor: Colors.white,
                    tristate: false,
                    value: global.languageModelList![index].isCheck,
                    onChanged: (value) {
                      global.languageModelList![index].isCheck = value ?? false;
                      widget.signupController.update();
                    },
                    title: Text(
                      global.languageModelList![index].name ?? tr("No Skills"),
                      style: Get.theme.primaryTextTheme.titleMedium,
                    ),
                    activeColor: COLORS().primaryColor,
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  for (int i = 0; i < global.languageModelList!.length; i++) {
                    if (global.languageModelList![i].isCheck == true) {
                      global.languageModelList![i].isCheck = false;
                    }
                  }
                  widget.signupController.cLanguage.text = "";
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Clear").tr(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor),
                onPressed: () {
                  global.user.languageId = [];
                  widget.signupController.cLanguage.text = '';
                  for (int i = 0; i < global.languageModelList!.length; i++) {
                    if (global.languageModelList![i].isCheck == true) {
                      widget.signupController.cLanguage.text +=
                          "${global.languageModelList![i].name},";
                    }
                    if (i == global.languageModelList!.length - 1) {
                      widget.signupController.cLanguage.text =
                          widget.signupController.cLanguage.text.substring(
                              0,
                              widget.signupController.cLanguage.text.length -
                                  1);
                    }
                    widget.signupController.lId = global.languageModelList!
                        .where((element) => element.isCheck == true)
                        .toList();
                  }
                  for (int j = 0; j < widget.signupController.lId.length; j++) {
                    global.user.languageId!.add(
                        LanguageModel(id: widget.signupController.lId[j].id!));
                  }
                  Get.back();
                  widget.signupController.update();
                },
                child: const Text("Done").tr(),
              ),
            ],
          );
        },
      ),
    );
  }

  // Keep the existing methods unchanged
  Widget selectImageBottomSheetWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: COLORS().blackColor,
              ),
              title: Text(
                "Camera",
                style: Get.theme.primaryTextTheme.titleMedium,
              ).tr(),
              onTap: () async {
                Get.back();
                widget.signupController.onOpenCamera();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Colors.blue,
              ),
              title: Text(
                "Gallery",
                style: Get.theme.primaryTextTheme.titleMedium,
              ).tr(),
              onTap: () async {
                Get.back();
                widget.signupController.onOpenGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: COLORS().errorColor),
              title: Text(
                "Cancel",
                style: Get.theme.primaryTextTheme.titleMedium,
              ).tr(),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.signupController.onDateSelected(picked);
    }
  }
}
