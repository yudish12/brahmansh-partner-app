import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class OtherDetailScreen extends StatelessWidget {
  const OtherDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: MyCustomAppBar(
          iconData:  IconThemeData(color: COLORS().textColor),
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title:  Text(
            "Other Details",
            style: TextStyle(
              color: COLORS().textColor,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Why onboard you card
                _buildInfoCard(
                  context,
                  title: "Why do you think we should onboard you?",
                  content: global.user.onboardYou != null &&
                          global.user.onboardYou != ''
                      ? '${global.user.onboardYou}'
                      : tr("Because I am Professional"),
                  icon: Icons.work_outline,
                  color: Colors.blue,
                ),

                const SizedBox(height: 12),

                // Interview time card
                _buildSimpleInfoCard(
                  context,
                  title: "Suitable time for interview",
                  value: global.user.suitableInterviewTime != null &&
                          global.user.suitableInterviewTime != ''
                      ? '${global.user.suitableInterviewTime}'
                      : "Not specified",
                  icon: Icons.access_time,
                  color: Colors.orange,
                ),

                if (global.user.currentCity != null &&
                    global.user.currentCity != '') ...[
                  const SizedBox(height: 12),
                  _buildSimpleInfoCard(
                    context,
                    title: "Currently Live City",
                    value: '${global.user.currentCity}',
                    icon: Icons.location_city,
                    color: Colors.purple,
                  ),
                ],

                const SizedBox(height: 12),
                _buildSimpleInfoCard(
                  context,
                  title: "Main source of business",
                  value: global.user.mainSourceOfBusiness != null &&
                          global.user.mainSourceOfBusiness != ''
                      ? '${global.user.mainSourceOfBusiness}'
                      : "Not specified",
                  icon: Icons.business_center,
                  color: Colors.green,
                ),

                const SizedBox(height: 12),
                _buildSimpleInfoCard(
                  context,
                  title: "Highest Qualification",
                  value: global.user.highestQualification != null &&
                          global.user.highestQualification != ''
                      ? '${global.user.highestQualification}'
                      : "Not specified",
                  icon: Icons.school,
                  color: Colors.red,
                ),

                const SizedBox(height: 12),
                _buildSimpleInfoCard(
                  context,
                  title: "Degree/Diploma",
                  value: global.user.degreeDiploma != null &&
                          global.user.degreeDiploma != ''
                      ? '${global.user.degreeDiploma}'
                      : "Not specified",
                  icon: Icons.card_membership,
                  color: Colors.teal,
                ),

                if (global.user.collegeSchoolUniversity != null &&
                    global.user.collegeSchoolUniversity != '') ...[
                  const SizedBox(height: 12),
                  _buildSimpleInfoCard(
                    context,
                    title: "College/School/University",
                    value: '${global.user.collegeSchoolUniversity}',
                    icon: Icons.account_balance,
                    color: Colors.indigo,
                  ),
                ],

                if (global.user.learnAstrology != null &&
                    global.user.learnAstrology != '') ...[
                  const SizedBox(height: 12),
                  _buildSimpleInfoCard(
                    context,
                    title: "Your learning platform",
                    value: '${global.user.learnAstrology}',
                    icon: Icons.psychology,
                    color: Colors.deepOrange,
                  ),
                ],

                // Social Media Links Section
                if (_hasSocialMediaLinks()) ...[
                  const SizedBox(height: 16),
                  _buildSocialMediaSection(context),
                ],

                if (global.user.referedPersonName != null &&
                    global.user.referedPersonName != '') ...[
                  const SizedBox(height: 12),
                  _buildSimpleInfoCard(
                    context,
                    title: "References Name",
                    value: '${global.user.referedPersonName}',
                    icon: Icons.contacts,
                    color: Colors.brown,
                  ),
                ],

                const SizedBox(height: 12),
                _buildSimpleInfoCard(
                  context,
                  title: "Expected Minimum Earning",
                  value: global.user.expectedMinimumEarning != null
                      ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${global.user.expectedMinimumEarning}'
                      : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),

                const SizedBox(height: 12),
                _buildSimpleInfoCard(
                  context,
                  title: "Expected Maximum Earning",
                  value: global.user.expectedMaximumEarning != null
                      ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${global.user.expectedMaximumEarning}'
                      : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
                  icon: Icons.money_off_csred,
                  color: Colors.red,
                ),

                const SizedBox(height: 12),
                _buildInfoCard(
                  context,
                  title: "Long Bio",
                  content: global.user.longBio != null &&
                          global.user.longBio != ''
                      ? '${global.user.longBio}'
                      : "My Name is developer And I am working as astrologer in this company",
                  icon: Icons.description,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasSocialMediaLinks() {
    return (global.user.instagramProfileLink != null &&
            global.user.instagramProfileLink != '') ||
        (global.user.facebookProfileLink != null &&
            global.user.facebookProfileLink != '') ||
        (global.user.linkedInProfileLink != null &&
            global.user.linkedInProfileLink != '') ||
        (global.user.youtubeProfileLink != null &&
            global.user.youtubeProfileLink != '') ||
        (global.user.webSiteProfileLink != null &&
            global.user.webSiteProfileLink != '');
  }

  Widget _buildSocialMediaSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[50]!, Colors.blue[50]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share, color: Colors.purple),
            ),
            title: Text(
              "Social Media & Links",
              style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[800],
                  ),
            ).tr(),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (global.user.instagramProfileLink != null &&
                        global.user.instagramProfileLink != '')
                      _buildSocialMediaItem(
                        context,
                        "Instagram",
                        '${global.user.instagramProfileLink}',
                        Icons.camera_alt,
                        Colors.pink,
                      ),
                    if (global.user.facebookProfileLink != null &&
                        global.user.facebookProfileLink != '')
                      _buildSocialMediaItem(
                        context,
                        "Facebook",
                        '${global.user.facebookProfileLink}',
                        Icons.facebook,
                        Colors.blue[800]!,
                      ),
                    if (global.user.linkedInProfileLink != null &&
                        global.user.linkedInProfileLink != '')
                      _buildSocialMediaItem(
                        context,
                        "LinkedIn",
                        '${global.user.linkedInProfileLink}',
                        Icons.business,
                        Colors.blue[700]!,
                      ),
                    if (global.user.youtubeProfileLink != null &&
                        global.user.youtubeProfileLink != '')
                      _buildSocialMediaItem(
                        context,
                        "YouTube",
                        '${global.user.youtubeProfileLink}',
                        Icons.video_library,
                        Colors.red,
                      ),
                    if (global.user.webSiteProfileLink != null &&
                        global.user.webSiteProfileLink != '')
                      _buildSocialMediaItem(
                        context,
                        "Website",
                        '${global.user.webSiteProfileLink}',
                        Icons.language,
                        Colors.green,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaItem(BuildContext context, String platform,
      String link, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  link.length > 30 ? '${link.substring(0, 30)}...' : link,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ).tr(),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.1)),
                  ),
                  child: Text(
                    content,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            title,
            style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ).tr(),
          trailing: Container(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              value,
              style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
