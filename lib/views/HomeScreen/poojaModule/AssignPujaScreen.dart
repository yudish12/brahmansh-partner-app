// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controllers/HomeController/productController.dart';

class AssignPujaScreen extends StatefulWidget {
  int? userid;
  AssignPujaScreen({super.key, this.userid});

  @override
  State<AssignPujaScreen> createState() => _MyAssignPujaScreenState();
}

class _MyAssignPujaScreenState extends State<AssignPujaScreen> {
  final poojacontroller = Get.find<Productcontroller>();
  final currentTime = DateTime.now();
  bool isLoading = true;
  bool noDataFound = false;
  @override
  void initState() {
    super.initState();
    _checkForData();
    loadpuja();
    log('user id is ${widget.userid}');
  }

  void loadpuja() async {
    await Get.find<Productcontroller>().getCustomPujaList();
  }

  void _checkForData() async {
    // Simulate a delay (5 seconds) to check for data
    await Future.delayed(const Duration(seconds: 2));
    if (poojacontroller.custompoojalist == null ||
        poojacontroller.custompoojalist!.isEmpty) {
      setState(() {
        isLoading = false;
        noDataFound = true; // Set noDataFound to true after the delay
      });
    } else {
      setState(() {
        isLoading = false;
        noDataFound = false; // Data is found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Productcontroller>(
        builder: (poojacontroller) => isLoading
            ? const fakeCustompujaList() // Show loading indicator while data is loading
            : noDataFound
                ? const Center(
                    child: Text(
                      "No data found",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    itemCount: poojacontroller.custompoojalist!.length,
                    itemBuilder: (context, index) {

                      final puja = poojacontroller.custompoojalist![index];
                      print("puja image;- ${puja.pujaImages?[0]}");

                      final upcomingPujaList = poojacontroller
                          .custompoojalist![index].pujaStartDatetime!
                          .isBefore(currentTime);

                      return InkWell(
                        onTap: () {
                          poojacontroller.suggestPuja(index);
                        },
                        child: Card(
                          color: poojacontroller.suggestpuja == index
                              ? Get.theme.primaryColorLight
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 60.w,
                                            child: Text(
                                              puja.pujaTitle!.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Date: ${DateFormat('dd/MM/y').format(puja.pujaStartDatetime!)}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                          Text(
                                            "Duration: ${puja.pujaDuration} min",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            puja.longDescription ??
                                                'No Description',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: 30.w,
                                            child: Text(
                                              "Price: ₹${puja.pujaPrice ?? 'N/A'}",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-Regular',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    puja.pujaImages != null &&
                                            puja.pujaImages!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2.w),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${puja.pujaImages?[0]}",
                                              width: 20.w,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),

                                SizedBox(
                                  width: 60.w,
                                  child: Text(
                                    "Place:  ${puja.pujaPlace ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                /// Status
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: puja.isAdminApproved == 'Pending' ||
                                            puja.isAdminApproved == 'Rejected'
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    puja.isAdminApproved == 'Pending' ||
                                            puja.isAdminApproved == 'Rejected'
                                        ? "Status: ${puja.isAdminApproved}"
                                        : "Status: ${puja.isAdminApproved}",
                                    style: TextStyle(
                                        color:
                                            puja.isAdminApproved == 'Pending' ||
                                                    puja.isAdminApproved ==
                                                        'Rejected'
                                                ? Colors.orange
                                                : Colors.green,
                                        fontSize: 12.sp),
                                  ),
                                ),

                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

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
                                color: Colors.red,
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
            }));
  }
}
