import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class fakeCustompujaList extends StatelessWidget {
  const fakeCustompujaList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Get.theme.primaryColor,
                              size: 18.sp,
                            ),
                            onPressed: () {
                              log('clicked on delete');
                              //delete the puja
                            })
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Description
                    Text(
                      '',
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 12),

                    /// Info Row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price:"),
                        Text("Place: '}"),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Status: Pending",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
