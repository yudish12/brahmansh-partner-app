import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PinnedReviewsScreen extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {'orderId': '00000008159', 'name': 'bhawna', 'date': '29 Jan 2025'},
    {'orderId': '00000002799', 'name': 'Jaspreet', 'date': '14 Jan 2025'},
    {'orderId': '00000002295', 'name': 'Shaikh Rameez', 'date': '12 Jan 2025'},
    {'orderId': '00000000228', 'name': 'subhi bansal', 'date': '03 Jan 2025'},
  ];

  PinnedReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        iconTheme: IconThemeData(color: COLORS().whiteColor),
        title: Text(
          'Pinned Reviews',
          style: Get.theme.textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(4.w),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple[100],
                    child: Text(
                      review['name']![0].toUpperCase(),
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.black,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: ${review['orderId']}',
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Name: ${review['name']!}",
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Call Type: chat',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review['date']!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                'Reply to this Review',
                                style: Get.theme.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.primaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.reply,
                                color: Get.theme.primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.push_pin,
                          color: Get.theme.primaryColor,
                        ), // This adds an icon to the button
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'option1',
                            child: Text('Remove'),
                          ),
                        ],
                        onSelected: (String value) {
                          // Wirte your Un pin logic here
                        },
                      ),
                      const SizedBox(height: 10),
                      const Icon(Icons.flag, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
