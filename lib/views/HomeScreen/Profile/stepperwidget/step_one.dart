import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import '../../../../controllers/HomeController/edit_profile_controller.dart';
import '../../../Authentication/login_screen.dart';
import '../stepper_one.dart';

class StepOneWidget extends StatefulWidget {
  const StepOneWidget({super.key, required this.editProfileController});

  final EditProfileController editProfileController;

  @override
  State<StepOneWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StepOneWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  COLORS().primaryColor.withOpacity(0.1),
                  Colors.blue[50]!,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: COLORS().primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_pin,
                    color: COLORS().primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Please provide your basic personal details",
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
          ),

          // Name Field
          buildFormField(
            label: "Full Name",
            hintText: "Enter your full name",
            controller: widget.editProfileController.cName,
            focusNode: widget.editProfileController.fName,
            nextFocusNode: widget.editProfileController.fEmail,
            icon: Icons.person_outline,
            readOnly: true,
            context: context,
            formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
          ),

          // Email Field
          buildFormField(
            context: context,
            label: "Email Address",
            hintText: "user@gmail.com",
            controller: widget.editProfileController.cEmail,
            focusNode: widget.editProfileController.fEmail,
            nextFocusNode: widget.editProfileController.fMobileNumber,
            icon: Icons.email_outlined,
            readOnly: true,
            keyboardType: TextInputType.emailAddress,
          ),

          // Mobile Number Field
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone_iphone,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Mobile Number",
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
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildphoneNumberWidget(
                            context, widget.editProfileController),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Terms & Conditions
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Obx(
                  () => Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: widget.editProfileController.termAndCondtion.value
                          ? COLORS().primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            widget.editProfileController.termAndCondtion.value
                                ? COLORS().primaryColor
                                : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: widget.editProfileController.termAndCondtion.value
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.editProfileController.termAndCondtion.value =
                          !widget.editProfileController.termAndCondtion.value;
                    },
                    child: Text(
                      "I agree to the Terms and Conditions",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
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

  Container _buildphoneNumberWidget(
      BuildContext context, EditProfileController editProfileController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.grey)),
      child: SizedBox(
        child: Theme(
          data: ThemeData(
            dialogTheme: DialogThemeData(
              contentTextStyle: const TextStyle(color: Colors.white),
              backgroundColor: Colors.grey[800],
              surfaceTintColor: Colors.grey[800],
            ),
          ),
          //MOBILE
          child: InternationalPhoneNumberInput(
            isEnabled: false,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            focusNode: editProfileController.fMobileNumber,
            spaceBetweenSelectorAndTextField: 0,
            maxLength: 10,
            scrollPadding: EdgeInsets.zero,
            textFieldController: editProfileController.cMobileNumber,
            inputDecoration: InputDecoration(
              hintText: tr('Mobile Number'),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15.sp,
                fontFamily: "verdana_regular",
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
            ),
            onInputValidated: (bool value) {},
            selectorConfig: const SelectorConfig(
              trailingSpace: false,
              leadingPadding: 2,
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: const TextStyle(color: Colors.black),
            searchBoxDecoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                )),
            initialValue: initialPhone,
            formatInput: false,
            inputBorder: InputBorder.none,
            onSaved: (PhoneNumber number) {
              debugPrint('On Saved: ${number.dialCode}');
              editProfileController.updateCountryCode(number.dialCode);
              editProfileController.update();
            },
            onFieldSubmitted: (value) {
              debugPrint('On onFieldSubmitted: $value');
              FocusScope.of(context).unfocus();
            },
            onInputChanged: (PhoneNumber number) {
              debugPrint('On onInputChanged: ${number.dialCode}');
              editProfileController.updateCountryCode(number.dialCode);
              editProfileController.update();
            },
            onSubmit: () {
              debugPrint('On onSubmit:');
            },
          ),
        ),
      ),
    );
  }
}
