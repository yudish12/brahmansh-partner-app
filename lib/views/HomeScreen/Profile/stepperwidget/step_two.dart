import 'dart:convert';
import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/HomeController/edit_profile_controller.dart';
import '../../../../utils/global.dart' as global;
import '../../../../widgets/common_drop_down.dart';
import '../../../../widgets/common_textfield_widget.dart';
import '../stepper_one.dart';

class StepTwoWidget extends StatefulWidget {
  const StepTwoWidget({super.key, required this.editProfileController});
  final EditProfileController editProfileController;
  @override
  State<StepTwoWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StepTwoWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          // Profile Image Section
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
                        Icons.camera_alt,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Photo",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Upload a clear profile picture",
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
                const SizedBox(height: 16),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    widget.editProfileController.userFile != null &&
                            widget.editProfileController.userFile != ''
                        ? Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Get.theme.primaryColor,
                                image: DecorationImage(
                                  image: FileImage(
                                      widget.editProfileController.userFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : global.user.imagePath != null &&
                                global.user.imagePath != ''
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Get.theme.primaryColor,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${global.user.imagePath}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                    color: COLORS().primaryColor,
                                  ),
                                ),
                              ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: COLORS().primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
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
          ),

          // Basic Information Card
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
                        Icons.person_outline,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Basic Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Gender
                buildFormFieldWithIcon(
                  label: "Gender",
                  icon: Icons.transgender,
                  child: CommonDropDown(
                    isEditable: false,
                    val: widget.editProfileController.selectedGender,
                    list: global.genderList,
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.editProfileController.selectedGender =
                          selectedValue;
                      widget.editProfileController.update();
                    },
                  ),
                ),

                // Date of Birth
                buildFormFieldWithIcon(
                  label: "Date of Birth",
                  icon: Icons.calendar_today,
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    hintText: tr("Select Birth Date"),
                    textEditingController:
                        widget.editProfileController.cBirthDate,
                    suffixIcon: Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ),

          // Skills & Categories Card
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
                        Icons.workspace_premium,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Skills & Specializations",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Astrologer Category
                buildMultiSelectField(
                  label: "Astrologer Category",
                  icon: Icons.category,
                  controller: widget.editProfileController.cSelectCategory,
                  onTap: () => showCategoryDialog(widget.editProfileController),
                ),

                // Primary Skills
                buildMultiSelectField(
                  label: "Primary Skills",
                  icon: Icons.star,
                  controller: widget.editProfileController.cPrimarySkill,
                  onTap: () =>
                      showPrimarySkillsDialog(widget.editProfileController),
                ),

                // All Skills
                buildMultiSelectField(
                  label: "All Skills",
                  icon: Icons.psychology,
                  controller: widget.editProfileController.cAllSkill,
                  onTap: () =>
                      showAllSkillsDialog(widget.editProfileController),
                ),

                // Languages
                buildMultiSelectField(
                  label: "Languages",
                  icon: Icons.language,
                  controller: widget.editProfileController.cLanguage,
                  onTap: () =>
                      showLanguagesDialog(widget.editProfileController),
                ),
              ],
            ),
          ),

          // Pricing & Charges Card
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
                        Icons.attach_money,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Service Charges",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Charges Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: [
                    buildChargeField(
                      "Chat/Minute",
                      widget.editProfileController.cCharges,
                      global.getSystemFlagValue(
                          global.systemFlagNameList.currency),
                    ),
                    buildChargeField(
                      "Chat/Minute (USD)",
                      widget.editProfileController.cusdCharges,
                      "\$",
                    ),
                    buildChargeField(
                      "Video Call",
                      widget.editProfileController.cVideoCharges,
                      global.getSystemFlagValue(
                          global.systemFlagNameList.currency),
                    ),
                    buildChargeField(
                      "Video Call (USD)",
                      widget.editProfileController.cusdVideoCharges,
                      "\$",
                    ),
                    buildChargeField(
                      "Report",
                      widget.editProfileController.cReportCharges,
                      global.getSystemFlagValue(
                          global.systemFlagNameList.currency),
                    ),
                    buildChargeField(
                      "Report (USD)",
                      widget.editProfileController.cusdReportCharges,
                      "\$",
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Additional Information Card
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
                      "Experience & Availability",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Experience
                buildFormFieldWithIcon(
                  label: "Experience In Years",
                  icon: Icons.work_history,
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    textEditingController:
                        widget.editProfileController.cExpirence,
                    hintText: "Enter Your Experience",
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.fContributionHours);
                    },
                  ),
                ),

                // Contribution Hours
                buildFormFieldWithIcon(
                  label: "Daily Contribution Hours",
                  icon: Icons.access_time,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cContributionHours,
                    hintText: "Hours per day",
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.fHearAboutAstroGuru);
                    },
                  ),
                ),

                // Referral Source
                buildFormFieldWithIcon(
                  label: "How did you hear about us?",
                  icon: Icons.handshake_outlined,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cHearAboutAstroGuru,
                    hintText: "YouTube, Facebook, etc.",
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Contact & Identification Card
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
                        Icons.contact_phone,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Contact & Identification",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // WhatsApp Number
                buildFormFieldWithIcon(
                  label: "WhatsApp Number",
                  icon: FontAwesomeIcons.whatsapp,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cwhatsappno,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    hintText: tr("Enter your whatsapp no"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.editProfileController.fpancard);
                    },
                  ),
                ),

                // Pancard Number
                buildFormFieldWithIcon(
                  label: "Pancard Number",
                  icon: Icons.badge,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cpancard,
                    maxLength: 10,
                    textCapitalization: TextCapitalization.characters,
                    hintText: tr("Enter your pancard no"),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.editProfileController.fadharno);
                    },
                  ),
                ),

                // Aadhar Number
                buildFormFieldWithIcon(
                  label: "Aadhar Number",
                  icon: Icons.credit_card,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cadharno,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 12,
                    hintText: tr("Enter your Aadhar no"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.editProfileController.fIFSC);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bank Details Card
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
                        Icons.account_balance,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Bank Account Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // IFSC Code
                buildFormFieldWithIcon(
                  label: "IFSC Code",
                  icon: Icons.code,
                  child: CommonTextFieldWidget(
                    textEditingController: widget.editProfileController.cIFSC,
                    maxLength: 11,
                    hintText: tr("Enter your IFSC"),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.fbankbranch);
                    },
                    onChanged: (p0) {
                      log("My Ifsc length ${widget.editProfileController.cIFSC.text.length}");
                      log("My Ifsc codePo $p0");
                      if (p0.length == 11) {
                        widget.editProfileController.getBankDetails(widget
                            .editProfileController.cIFSC.text.capitalize
                            .toString());
                      }
                    },
                  ),
                ),

                // Bank Branch
                buildFormFieldWithIcon(
                  label: "Bank Branch",
                  icon: Icons.location_city,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cbankbranch,
                    hintText: tr("Enter Bank Branch"),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.editProfileController.fbankname);
                    },
                  ),
                ),

                // Bank Name
                buildFormFieldWithIcon(
                  label: "Bank Name",
                  icon: Icons.business,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cbankname,
                    hintText: tr("Enter Bank Name"),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.faccountHolderName);
                    },
                  ),
                ),

                // Bank Account Holder Name
                buildFormFieldWithIcon(
                  label: "Bank Account Holder Name",
                  icon: Icons.person,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.caccountHolderName,
                    hintText: tr("Bank Account Holder Name"),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.faccountno);
                    },
                  ),
                ),

                // Account Type
                buildFormFieldWithIcon(
                  label: "Account Type",
                  icon: Icons.account_balance_wallet,
                  child: CommonDropDown(
                    val: global.user.accountType,
                    list: widget.editProfileController.accountTypeOptions,
                    onTap: () {},
                    onChanged: (selectedValue) {
                      widget.editProfileController.defaultaccountType =
                          selectedValue;
                      widget.editProfileController.update();
                      log("Selected Account Type: ${widget.editProfileController.defaultaccountType}");
                    },
                  ),
                ),

                // Account Number
                buildFormFieldWithIcon(
                  label: "Account Number",
                  icon: Icons.numbers,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.caccountno,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 18,
                    hintText: tr("Account Number"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.fconfiaccountno);
                    },
                  ),
                ),

                // Confirm Account Number
                buildFormFieldWithIcon(
                  label: "Confirm Account Number",
                  icon: Icons.verified_user,
                  child: CommonTextFieldWidget(
                    textEditingController:
                        widget.editProfileController.cconfiaccountno,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 18,
                    hintText: tr("Confirm Your Account Number"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context)
                          .requestFocus(widget.editProfileController.fupi);
                    },
                  ),
                ),

                // UPI
                buildFormFieldWithIcon(
                  label: "UPI ID",
                  icon: Icons.payment,
                  child: CommonTextFieldWidget(
                    textEditingController: widget.editProfileController.cupi,
                    hintText: tr("UPI"),
                    onFieldSubmitted: (f) {
                      FocusScope.of(context).requestFocus(
                          widget.editProfileController.fHearAboutAstroGuru);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Other Platform Card
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
                        FontAwesomeIcons.gofore,
                        color: COLORS().primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Other Platform Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Working on other platform
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Are you working on any other platform?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          buildRadioOption(
                            value: 1,
                            groupValue:
                                widget.editProfileController.anyOnlinePlatform,
                            label: "Yes",
                            onChanged: (val) => widget.editProfileController
                                .setOnlinePlatform(val),
                          ),
                          const SizedBox(width: 20),
                          buildRadioOption(
                            value: 2,
                            groupValue:
                                widget.editProfileController.anyOnlinePlatform,
                            label: "No",
                            onChanged: (val) => widget.editProfileController
                                .setOnlinePlatform(val),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Platform details (conditional)
                if (widget.editProfileController.anyOnlinePlatform == 1)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildFormFieldWithIcon(
                          label: "Name of platform?",
                          icon: Icons.business_center,
                          child: CommonTextFieldWidget(
                            textEditingController:
                                widget.editProfileController.cNameOfPlatform,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            hintText: "Company Name",
                            onFieldSubmitted: (f) {
                              FocusScope.of(context).requestFocus(
                                  widget.editProfileController.fMonthlyEarning);
                            },
                          ),
                        ),
                        buildFormFieldWithIcon(
                          label: "Monthly Earning?",
                          icon: Icons.attach_money,
                          child: CommonTextFieldWidget(
                            textEditingController:
                                widget.editProfileController.cMonthlyEarning,
                            formatter: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 7,
                            hintText:
                                "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20000",
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: true),
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
        ],
      ),
    );
  }

//User Image
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
                widget.editProfileController.imageFile = await widget
                    .editProfileController
                    .imageService(ImageSource.camera);
                widget.editProfileController.userFile =
                    widget.editProfileController.imageFile;
                widget.editProfileController.profile = base64.encode(
                    widget.editProfileController.imageFile!.readAsBytesSync());
                widget.editProfileController.update();
                Get.back();
                // editProfileController.onOpenCamera();

                // _tImage = await br.openCamera(Theme.of(context).primaryColor, isProfile: true);
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
                widget.editProfileController.imageFile = await widget
                    .editProfileController
                    .imageService(ImageSource.gallery);
                widget.editProfileController.userFile =
                    widget.editProfileController.imageFile;
                widget.editProfileController.profile = base64.encode(
                    widget.editProfileController.imageFile!.readAsBytesSync());
                widget.editProfileController.update();
                Get.back();
                // editProfileController.onOpenGallery();
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
}
