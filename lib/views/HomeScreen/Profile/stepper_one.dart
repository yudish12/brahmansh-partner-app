import 'package:brahmanshtalk/controllers/HomeController/edit_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/colorConst.dart';
import '../../../models/Master Table Model/all_skill_model.dart';
import '../../../models/Master Table Model/astrologer_category_list_model.dart';
import '../../../models/Master Table Model/language_list_model.dart';
import '../../../models/Master Table Model/primary_skill_model.dart';
import '../../../utils/global.dart' as global;
import '../../../widgets/common_textfield_widget.dart';

Widget buildStepLabel(int stepIndex, String label, int currentIndex) {
  bool isActive = currentIndex >= stepIndex;
  bool isCurrent = currentIndex == stepIndex;

  return Column(
    children: [
      Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isActive ? COLORS().primaryColor : Colors.grey[300],
          shape: BoxShape.circle,
          border: isCurrent
              ? Border.all(color: COLORS().primaryColor, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 9,
          color: isActive ? COLORS().primaryColor : Colors.grey[500],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget buildFormField({
  required String label,
  required String hintText,
  required TextEditingController controller,
  required FocusNode focusNode,
  required FocusNode nextFocusNode,
  required IconData icon,
  bool readOnly = false,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? formatter,
  required BuildContext context,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CommonTextFieldWidget(
          readOnly: readOnly,
          hintText: hintText,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          formatter: formatter,
          textEditingController: controller,
          focusNode: focusNode,
          onFieldSubmitted: (f) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
        ),
      ],
    ),
  );
}

Widget buildProfileImage(EditProfileController controller) {
  if (controller.userFile != null && controller.userFile != '') {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        controller.userFile!,
        fit: BoxFit.cover,
      ),
    );
  } else if (global.user.imagePath != null && global.user.imagePath != '') {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: "${global.user.imagePath}",
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: COLORS().primaryColor,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.person,
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  } else {
    return Center(
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}

Widget buildFormFieldWithIcon({
  required String label,
  required IconData icon,
  required Widget child,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

Widget buildMultiSelectField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CommonTextFieldWidget(
          hintText: "Select $label",
          textEditingController: controller,
          readOnly: true,
          suffixIcon: Icons.arrow_drop_down,
          onTap: onTap,
        ),
      ],
    ),
  );
}

Widget buildChargeField(
    String label, TextEditingController controller, String prefix) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Text(
                prefix,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
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

void showCategoryDialog(EditProfileController controller) {
  Get.dialog(
    _buildSelectionDialog(
      title: "Select Category",
      items: global.astrologerCategoryModelList!,
      onClear: () {
        for (int i = 0; i < global.astrologerCategoryModelList!.length; i++) {
          if (global.astrologerCategoryModelList![i].isCheck == true) {
            global.astrologerCategoryModelList![i].isCheck = false;
          }
        }
        controller.cSelectCategory.text = "";
        Get.back();
        controller.update();
      },
      onDone: () {
        global.user.astrologerCategoryId = [];
        controller.cSelectCategory.text = "";
        for (int i = 0; i < global.astrologerCategoryModelList!.length; i++) {
          if (global.astrologerCategoryModelList![i].isCheck == true) {
            controller.cSelectCategory.text +=
                "${global.astrologerCategoryModelList![i].name},";
          }
          if (i == global.astrologerCategoryModelList!.length - 1) {
            controller.cSelectCategory.text = controller.cSelectCategory.text
                .substring(0, controller.cSelectCategory.text.length - 1);
          }
          controller.astroId = global.astrologerCategoryModelList!
              .where((element) => element.isCheck == true)
              .toList();
        }
        for (int j = 0; j < controller.astroId.length; j++) {
          global.user.astrologerCategoryId!
              .add(AstrolgoerCategoryModel(id: controller.astroId[j].id));
        }
        Get.back();
        controller.update();
      },
    ),
  );
}

void showPrimarySkillsDialog(EditProfileController controller) {
  Get.dialog(
    _buildSelectionDialog(
      title: "Primary Skills",
      items: global.skillModelList!,
      onClear: () {
        for (int i = 0; i < global.skillModelList!.length; i++) {
          if (global.skillModelList![i].isCheck == true) {
            global.skillModelList![i].isCheck = false;
          }
        }
        controller.cPrimarySkill.text = "";
        Get.back();
        controller.update();
      },
      onDone: () {
        global.user.primarySkillId = [];
        controller.cPrimarySkill.text = "";
        for (int i = 0; i < global.skillModelList!.length; i++) {
          if (global.skillModelList![i].isCheck == true) {
            controller.cPrimarySkill.text +=
                "${global.skillModelList![i].name},";
          }
          if (i == global.skillModelList!.length - 1) {
            controller.cPrimarySkill.text = controller.cPrimarySkill.text
                .substring(0, controller.cPrimarySkill.text.length - 1);
          }
          controller.primaryId = global.skillModelList!
              .where((element) => element.isCheck == true)
              .toList();
        }
        for (int j = 0; j < controller.primaryId.length; j++) {
          global.user.primarySkillId!
              .add(PrimarySkillModel(id: controller.primaryId[j].id!));
        }
        Get.back();
        controller.update();
      },
    ),
  );
}

void showAllSkillsDialog(EditProfileController controller) {
  Get.dialog(
    _buildSelectionDialog(
      title: "All Skills",
      items: global.allSkillModelList!,
      onClear: () {
        for (int i = 0; i < global.allSkillModelList!.length; i++) {
          if (global.allSkillModelList![i].isCheck == true) {
            global.allSkillModelList![i].isCheck = false;
          }
        }
        controller.cAllSkill.text = "";
        Get.back();
        controller.update();
      },
      onDone: () {
        global.user.allSkillId = [];
        controller.cAllSkill.text = "";
        for (int i = 0; i < global.allSkillModelList!.length; i++) {
          if (global.allSkillModelList![i].isCheck == true) {
            controller.cAllSkill.text +=
                "${global.allSkillModelList![i].name},";
          }
          if (i == global.allSkillModelList!.length - 1) {
            controller.cAllSkill.text = controller.cAllSkill.text
                .substring(0, controller.cAllSkill.text.length - 1);
          }
          controller.allId = global.allSkillModelList!
              .where((element) => element.isCheck == true)
              .toList();
        }
        for (int j = 0; j < controller.allId.length; j++) {
          global.user.allSkillId!
              .add(AllSkillModel(id: controller.allId[j].id!));
        }
        Get.back();
        controller.update();
      },
    ),
  );
}

void showLanguagesDialog(EditProfileController controller) {
  Get.dialog(
    _buildSelectionDialog(
      title: "All Language",
      items: global.languageModelList!,
      onClear: () {
        for (int i = 0; i < global.languageModelList!.length; i++) {
          if (global.languageModelList![i].isCheck == true) {
            global.languageModelList![i].isCheck = false;
          }
        }
        controller.cLanguage.text = "";
        Get.back();
        controller.update();
      },
      onDone: () {
        global.user.languageId = [];
        controller.cLanguage.text = "";
        for (int i = 0; i < global.languageModelList!.length; i++) {
          if (global.languageModelList![i].isCheck == true) {
            controller.cLanguage.text +=
                "${global.languageModelList![i].name},";
          }
          if (i == global.languageModelList!.length - 1) {
            controller.cLanguage.text = controller.cLanguage.text
                .substring(0, controller.cLanguage.text.length - 1);
          }
          controller.lId = global.languageModelList!
              .where((element) => element.isCheck == true)
              .toList();
        }
        for (int j = 0; j < controller.lId.length; j++) {
          global.user.languageId!.add(LanguageModel(id: controller.lId[j].id!));
        }
        Get.back();
        controller.update();
      },
    ),
  );
}

Widget _buildSelectionDialog({
  required String title,
  required List<dynamic> items,
  required VoidCallback onClear,
  required VoidCallback onDone,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: COLORS().primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.checklist,
                  color: COLORS().primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search Bar (optional - you can add this later)
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 12),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[50],
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(color: Colors.grey[300]!),
          //   ),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search...",
          //       border: InputBorder.none,
          //       icon: Icon(Icons.search, color: Colors.grey[500]),
          //     ),
          //   ),
          // ),

          // SizedBox(height: 12),

          // Items List
          Container(
            height: Get.height * 1 / 3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[100]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: CheckboxListTile(
                    tristate: false,
                    value: item.isCheck ?? false,
                    onChanged: (value) {
                      item.isCheck = value;
                      Get.find<EditProfileController>().update();
                    },
                    title: Text(
                      item.name ?? "No Name",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    activeColor: COLORS().primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: COLORS().primaryColor,
                    side: BorderSide(color: COLORS().primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: onClear,
                  child: const Text("Clear"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: COLORS().primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: onDone,
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildSocialMediaCard(
  String platform,
  TextEditingController controller,
  IconData icon,
  Color color,
  String prefix,
) {
  return GestureDetector(
    onTap: () {
      _showSocialMediaDialog(platform, controller, prefix);
    },
    child: Container(
      width: 140,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              icon,
              size: 40,
              color: color.withOpacity(0.1),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        platform,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    controller.text.isEmpty
                        ? "Add $platform"
                        : controller.text.length > 15
                            ? "${controller.text.substring(0, 15)}..."
                            : controller.text,
                    style: TextStyle(
                      fontSize: 10,
                      color: controller.text.isEmpty
                          ? Colors.grey[500]
                          : Colors.grey[800],
                      fontWeight: controller.text.isEmpty
                          ? FontWeight.w400
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          // Edit Icon
          if (controller.text.isNotEmpty)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

void _showSocialMediaDialog(
  String platform,
  TextEditingController controller,
  String prefix,
) {
  final TextEditingController dialogController =
      TextEditingController(text: controller.text);

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPlatformColor(platform).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getPlatformIcon(platform),
                    color: _getPlatformColor(platform),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Edit $platform Profile",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Input Field
            Text(
              "$platform URL",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: dialogController,
                decoration: InputDecoration(
                  hintText: "$prefix username",
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  prefixIcon: Icon(
                    Icons.link,
                    color: Colors.grey[500],
                    size: 18,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getPlatformColor(platform),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      controller.text = dialogController.text;
                      Get.back();
                      Get.find<EditProfileController>().update();
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Color _getPlatformColor(String platform) {
  switch (platform) {
    case "Instagram":
      return const Color(0xFFE4405F);
    case "Facebook":
      return const Color(0xFF1877F2);
    case "LinkedIn":
      return const Color(0xFF0A66C2);
    case "YouTube":
      return const Color(0xFFFF0000);
    case "Website":
      return const Color(0xFF34A853);
    default:
      return COLORS().primaryColor;
  }
}

IconData _getPlatformIcon(String platform) {
  switch (platform) {
    case "Instagram":
      return Icons.camera_alt_rounded;
    case "Facebook":
      return Icons.facebook_rounded;
    case "LinkedIn":
      return Icons.linked_camera_rounded;
    case "YouTube":
      return Icons.videocam_rounded;
    case "Website":
      return Icons.language_rounded;
    default:
      return Icons.share_rounded;
  }
}

Widget buildRadioOption({
  required int value,
  required int? groupValue,
  required String label,
  required Function(int?) onChanged,
}) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                groupValue == value ? COLORS().primaryColor : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: Radio(
          value: value,
          groupValue: groupValue,
          activeColor: COLORS().primaryColor,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget buildModernRadioOption({
  required int value,
  required int? groupValue,
  required String label,
  required IconData icon,
  required Color activeColor,
  required Function(int?) onChanged,
}) {
  bool isSelected = groupValue == value;

  return GestureDetector(
    onTap: () => onChanged(value),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: activeColor, width: 1.5) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? activeColor : Colors.grey[500],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? activeColor : Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildEarningField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required Color color,
  required String currency,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              currency,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextFormField(
                controller: controller,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: "0",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

String getEarningRangeText(String min, String max, String currency) {
  if (min.isEmpty && max.isEmpty) {
    return "Set your earning expectations";
  } else if (min.isEmpty) {
    return "Up to $currency$max per month";
  } else if (max.isEmpty) {
    return "From $currency$min per month";
  } else {
    return "$currency$min - $currency$max per month";
  }
}

String formatDocumentName(String key) {
  // Convert snake_case to Title Case with spaces
  return key.split('_').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}
