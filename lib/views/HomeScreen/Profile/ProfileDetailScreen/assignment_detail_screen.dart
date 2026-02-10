import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../constants/colorConst.dart';
import '../../../../widgets/app_bar_widget.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: MyCustomAppBar(
          iconData:  IconThemeData(color: COLORS().textColor),
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title:  Text("Assignment Details",
                  style: TextStyle(
                      color: COLORS().textColor, fontWeight: FontWeight.w600))
              .tr(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Foreign Country Card
                _buildInfoCard(
                  context,
                  title: "Number of Foreign Countries you Lived",
                  value: global.user.foreignCountryCount != null &&
                          global.user.foreignCountryCount != ''
                      ? '${global.user.foreignCountryCount}'
                      : "3-5",
                  icon: Icons.public,
                  color: Colors.blue,
                  isExpansion: false,
                ),

                const SizedBox(height: 16),

                // Currently Working Card
                _buildInfoCard(
                  context,
                  title: "Currently Working",
                  content: global.user.currentlyWorkingJob != null &&
                          global.user.currentlyWorkingJob != ''
                      ? '${global.user.currentlyWorkingJob}'
                      : tr("No, I am working as a part-timer or freelancer"),
                  icon: Icons.work,
                  color: Colors.green,
                  isExpansion: true,
                ),

                const SizedBox(height: 16),

                // Good Quality Card
                _buildInfoCard(
                  context,
                  title: "Good Quality",
                  content: global.user.goodQualityOfAstrologer != null &&
                          global.user.goodQualityOfAstrologer != ''
                      ? '${global.user.goodQualityOfAstrologer}'
                      : tr("Satisfied Customer with solution and remedies"),
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                  isExpansion: true,
                ),

                const SizedBox(height: 16),

                // Biggest Challenge Card
                _buildInfoCard(
                  context,
                  title: "Biggest Challenge You Faced",
                  content: global.user.biggestChallengeFaced != null &&
                          global.user.biggestChallengeFaced != ''
                      ? '${global.user.biggestChallengeFaced}'
                      : tr(
                          "One of the biggest challenge I've overcome happened at my work"),
                  icon: FontAwesomeIcons.chalkboard,
                  color: Colors.orange,
                  isExpansion: true,
                ),

                const SizedBox(height: 16),

                // Repeated Question Card
                _buildInfoCard(
                  context,
                  title: "Customer Asking Same Question Repeatedly",
                  subtitle: "What will you do?",
                  content: global.user.repeatedQuestion != null &&
                          global.user.repeatedQuestion != ''
                      ? '${global.user.repeatedQuestion}'
                      : tr(
                          "Give more information and more clarity to Customer."),
                  icon: Icons.help_center,
                  color: Colors.purple,
                  isExpansion: true,
                ),

                const SizedBox(height: 20),

                // Summary Card
                _buildSummaryCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? value,
    String? content,
    required IconData icon,
    required Color color,
    required bool isExpansion,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.05), color.withOpacity(0.02)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: isExpansion
            ? _buildExpansionTile(
                context, title, subtitle, content, icon, color)
            : _buildSimpleTile(context, title, value, icon, color),
      ),
    );
  }

  Widget _buildExpansionTile(BuildContext context, String title,
      String? subtitle, String? content, IconData icon, Color color) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
            ).tr(),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
              ).tr(),
            ],
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote, color: color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      content ?? "",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                            color: Colors.grey[700],
                            height: 1.5,
                            fontSize: 14,
                          ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(BuildContext context, String title, String? value,
      IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
      ).tr(),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          value ?? "",
          style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    int completedFields = 0;
    int totalFields = 5;

    if (global.user.foreignCountryCount != null &&
        global.user.foreignCountryCount != '') completedFields++;
    if (global.user.currentlyWorkingJob != null &&
        global.user.currentlyWorkingJob != '') completedFields++;
    if (global.user.goodQualityOfAstrologer != null &&
        global.user.goodQualityOfAstrologer != '') completedFields++;
    if (global.user.biggestChallengeFaced != null &&
        global.user.biggestChallengeFaced != '') completedFields++;
    if (global.user.repeatedQuestion != null &&
        global.user.repeatedQuestion != '') completedFields++;

    double progress = completedFields / totalFields;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[50]!, Colors.blue[50]!],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.assignment, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Assignment Progress",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .displaySmall
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.purple[800],
                        ),
                  ).tr(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: progress >= 0.8
                  ? Colors.green
                  : progress >= 0.5
                      ? Colors.orange
                      : Colors.red,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$completedFields/$totalFields completed",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${(progress * 100).round()}%",
                  style: TextStyle(
                    fontSize: 12,
                    color: progress >= 0.8
                        ? Colors.green
                        : progress >= 0.5
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getProgressMessage(progress),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getProgressMessage(double progress) {
    if (progress >= 0.8)
      return "Excellent! Your assignment details are almost complete.";
    if (progress >= 0.5)
      return "Good progress! Keep going to complete your assignment.";
    return "Let's complete your assignment details to get started.";
  }
}
