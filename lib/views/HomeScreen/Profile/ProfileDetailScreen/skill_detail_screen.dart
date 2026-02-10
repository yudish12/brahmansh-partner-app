import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get/get.dart';

class SkillDetailScreen extends StatelessWidget {
  SkillDetailScreen({super.key});
  final SignupController signupController = Get.find<SignupController>();

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    IconData? icon,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: icon != null
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color?.withOpacity(0.1) ??
                      COLORS().primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(icon, color: color ?? COLORS().primaryColor, size: 20),
              )
            : null,
        title: Text(
          title,
          style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
        ).tr(),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value.isNotEmpty ? value : "Not specified",
            style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: value.isNotEmpty
            ? Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20)
            : null,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Avatar with modern design
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle with gradient border
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      COLORS().primaryColor,
                      Colors.blueAccent.shade700,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _buildProfileImage(),
                    ),
                  ),
                ),
              ),

              // Verification badge
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Name and Title
          Column(
            children: [
              Text(
                global.user.name ?? "Astrologer Name",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "Professional Astrologer",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.3,
                ),
              ).tr(),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  value: global.user.expirenceInYear?.toString() ?? "0",
                  label: "Years Exp",
                  icon: Icons.work_outline,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade200,
                ),
                _buildStatItem(
                  value: global.user.primarySkillId?.length.toString() ?? "0",
                  label: "Skills",
                  icon: Icons.star_outline,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade200,
                ),
                _buildStatItem(
                  value: global.user.languageId?.length.toString() ?? "0",
                  label: "Languages",
                  icon: Icons.language_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (global.user.imagePath != null && global.user.imagePath!.isNotEmpty) {
      if (signupController.astrologerList.isNotEmpty &&
          signupController.astrologerList[0]!.imagePath!.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: "${signupController.astrologerList[0]!.imagePath}",
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => _buildPlaceholderAvatar(),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: "${global.user.imagePath}",
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => _buildPlaceholderAvatar(),
        );
      }
    } else {
      return _buildPlaceholderAvatar();
    }
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildStatItem(
      {required String value, required String label, required IconData icon}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: COLORS().primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: MyCustomAppBar(
        iconData:  IconThemeData(color: COLORS().textColor),
        height: 80,
        backgroundColor: COLORS().primaryColor,
        title:
             Text("Skill Details", style: TextStyle(color:  COLORS().textColor))
                .tr(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(),

            // Personal Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: Text(
                      "Personal Information",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                    ).tr(),
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Gender",
                    value:
                        global.user.gender != null && global.user.gender != ''
                            ? '${global.user.gender}'
                            : "",
                    icon: Icons.person_outline,
                    color: Colors.blue,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Date of Birth",
                    value: global.user.birthDate != null
                        ? DateFormat('dd-MM-yyyy').format(
                            DateTime.parse(global.user.birthDate.toString()))
                        : "",
                    icon: Icons.cake_outlined,
                    color: Colors.pink,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Experience In Years",
                    value: global.user.expirenceInYear != null &&
                            global.user.expirenceInYear != 0
                        ? '${global.user.expirenceInYear}'
                        : "0",
                    icon: Icons.work_outline,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Professional Skills Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: Text(
                      "Professional Skills",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                    ).tr(),
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Astrologer category",
                    value: global.user.astrologerCategoryId!.isNotEmpty
                        ? global.user.astrologerCategoryId!
                            .map((e) => e.name)
                            .toList()
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                        : "",
                    icon: Icons.category_outlined,
                    color: Colors.purple,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Primary Skills",
                    value: global.user.primarySkillId!.isNotEmpty
                        ? global.user.primarySkillId!
                            .map((e) => e.name)
                            .toList()
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                        : "",
                    icon: Icons.star_outline,
                    color: Colors.amber,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "All Skills",
                    value: global.user.allSkillId!.isNotEmpty
                        ? global.user.allSkillId!
                            .map((e) => e.name)
                            .toList()
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                        : "",
                    icon: Icons.psychology_outlined,
                    color: Colors.green,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Language",
                    value: global.user.languageId!.isNotEmpty
                        ? global.user.languageId!
                            .map((e) => e.name)
                            .toList()
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                        : "",
                    icon: Icons.language_outlined,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pricing Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: Text(
                      "Pricing Information",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                    ).tr(),
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Your charges (per minute)",
                    value: global.user.charges != null &&
                            global.user.charges != 0
                        ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${global.user.charges}'
                        : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
                    icon: Icons.attach_money_outlined,
                    color: Colors.green,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Video charges",
                    value: global.user.videoCallRate != null &&
                            global.user.videoCallRate != 0
                        ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${global.user.videoCallRate}'
                        : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
                    icon: Icons.videocam_outlined,
                    color: Colors.red,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Report charges",
                    value: global.user.reportRate != null &&
                            global.user.reportRate != 0
                        ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${global.user.reportRate}'
                        : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
                    icon: Icons.description_outlined,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Additional Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: Text(
                      "Additional Information",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                    ).tr(),
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "Daily Contribution Hours",
                    value: global.user.dailyContributionHours != null &&
                            global.user.dailyContributionHours != 0
                        ? '${global.user.dailyContributionHours}'
                        : "0",
                    icon: Icons.access_time_outlined,
                    color: Colors.teal,
                  ),
                  _buildInfoCard(
                    context: context,
                    title: "How did you hear about us?",
                    value: global.user.hearAboutAstroGuru != null &&
                            global.user.hearAboutAstroGuru != ''
                        ? '${global.user.hearAboutAstroGuru}'
                        : "Youtube",
                    icon: Icons.help_outline,
                    color: Colors.indigo,
                  ),
                  if (global.user.otherPlatformName != null &&
                      global.user.otherPlatformName != '')
                    _buildInfoCard(
                      context: context,
                      title: "Other Platform Name",
                      value: global.user.otherPlatformName ?? "",
                      icon: Icons.other_houses,
                      color: Colors.deepOrange,
                    ),
                  if (global.user.otherPlatformMonthlyEarning != null &&
                      global.user.otherPlatformMonthlyEarning != '')
                    _buildInfoCard(
                      context: context,
                      title: "Monthly Earning From Other Platform",
                      value: global.user.otherPlatformMonthlyEarning ?? "",
                      icon: Icons.monetization_on_outlined,
                      color: Colors.green,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
