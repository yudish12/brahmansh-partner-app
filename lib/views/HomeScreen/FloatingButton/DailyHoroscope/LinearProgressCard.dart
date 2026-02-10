import 'package:brahmanshtalk/controllers/dailyHoroscopeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'customtag.dart';

class LinearProgressCard extends StatelessWidget {
  final DailyHoroscopeController dailyHoroscopeController;
  final String horoscopetype;

  const LinearProgressCard({
    super.key,
    required this.dailyHoroscopeController,
    required this.horoscopetype,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyHoroscopeController>(
        builder: (dailyHoroscopeController) {
      return Container(
        padding: EdgeInsets.only(top: 5.w, left: 1, right: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomTag(
                    icon: Icons.sports_gymnastics,
                    label: 'Physique',
                    isSelected: dailyHoroscopeController.selectedIndex == 0,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'physique',
                        remarkkey: "",
                        index: 0),
                  ),
                  CustomTag(
                    icon: Icons.monetization_on_outlined,
                    label: 'Finances',
                    isSelected: dailyHoroscopeController.selectedIndex == 1,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'finances',
                        remarkkey: 'finances_remark',
                        index: 1),
                  ),
                  CustomTag(
                    icon: Icons.handshake_outlined,
                    label: 'Relationship',
                    isSelected: dailyHoroscopeController.selectedIndex == 2,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'relationship',
                        remarkkey: 'relationship_remark',
                        index: 2),
                  ),
                  CustomTag(
                      icon: Icons.book_outlined,
                      label: 'Career',
                      isSelected: dailyHoroscopeController.selectedIndex == 3,
                      onTap: () => dailyHoroscopeController.getProgressValue(
                          type: horoscopetype,
                          key: 'career',
                          remarkkey: ' career_remark',
                          index: 3)),
                  CustomTag(
                    icon: Icons.travel_explore,
                    label: 'Travel',
                    isSelected: dailyHoroscopeController.selectedIndex == 4,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'travel',
                        remarkkey: 'travel_remark',
                        index: 4),
                  ),
                  CustomTag(
                    icon: Icons.people_alt_outlined,
                    label: 'Family',
                    isSelected: dailyHoroscopeController.selectedIndex == 5,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'family',
                        remarkkey: 'family_remark',
                        index: 5),
                  ),
                  CustomTag(
                    icon: Icons.people_alt_outlined,
                    label: 'Friends',
                    isSelected: dailyHoroscopeController.selectedIndex == 6,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'friends',
                        remarkkey: 'friends_remark',
                        index: 6),
                  ),
                  CustomTag(
                    icon: Icons.health_and_safety_outlined,
                    label: 'Health',
                    isSelected: dailyHoroscopeController.selectedIndex == 7,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                      index: 7,
                      type: horoscopetype,
                      key: 'health',
                      remarkkey: 'health_remark',
                    ),
                  ),
                  CustomTag(
                    icon: Icons.photo_size_select_actual_sharp,
                    label: 'Status',
                    isSelected: dailyHoroscopeController.selectedIndex == 8,
                    onTap: () => dailyHoroscopeController.getProgressValue(
                        type: horoscopetype,
                        key: 'status',
                        index: 8,
                        remarkkey: 'status_remark'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressBar(
                value: dailyHoroscopeController.linearprogressvalue,
              ),
            ),
            const SizedBox(height: 15),
            // Percentage value
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                  children: [
                    const TextSpan(
                      text: "PERCENTAGE VALUE OF ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: dailyHoroscopeController.labelText.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: " ${dailyHoroscopeController.linearprogressvalue}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            // Remark value
            dailyHoroscopeController.remarkvalue != ""
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      dailyHoroscopeController.remarkvalue,
                      textAlign: TextAlign.justify,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }
}
