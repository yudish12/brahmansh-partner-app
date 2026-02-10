// ignore_for_file: camel_case_types
import 'dart:developer';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/custompujaController.dart';
import 'package:brahmanshtalk/views/HomeScreen/poojaModule/AddPujaForm.dart';
import 'package:brahmanshtalk/views/HomeScreen/poojaModule/AssignPujaScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/custompujaModel.dart';

class MyCustomPujaListScreen extends StatefulWidget {
  const MyCustomPujaListScreen({super.key});

  @override
  State<MyCustomPujaListScreen> createState() => _MyCustomPujaListScreenState();
}

class _MyCustomPujaListScreenState extends State<MyCustomPujaListScreen> {
  final poojacontroller = Get.find<Productcontroller>();
  final custompujacontroller = Get.put(CustomPujaController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      poojacontroller.getCustomPujaList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: COLORS().textColor),
        title: Text(
          "My Custom Puja",
          style: TextStyle(
              color: COLORS().textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500),
        ).tr(),
        //add icon on right
        actions: [
          IconButton(
            onPressed: () {
              log('clicked on add');
              Get.to(() => AddPujaForm(puja: CustomPujaModel()));
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, color: Colors.black, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Add Puja',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ).tr(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: GetBuilder<Productcontroller>(
        builder: (poojacontroller) => poojacontroller.custompoojalist == null 
            ? const fakeCustompujaList()
            : (poojacontroller.custompoojalist!.length==0?Center(
          child: Text("No Custom Puja"),
        ):ListView.builder(
                itemCount: poojacontroller.custompoojalist!.length,
                itemBuilder: (context, index) {
                  final puja = poojacontroller.custompoojalist![index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              Flexible(
                                flex: 2,
                                child: Text(
                                  (puja.pujaTitle ?? "")
                                      .split(' ')
                                      .map((e) => e.capitalized)
                                      .join(' '),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  puja.pujaStartDatetime!
                                                  .isAfter(DateTime.now()) ==
                                              true &&
                                          puja.isAdminApproved == 'Pending'
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: 18.sp,
                                          ),
                                          onPressed: () {
                                            //edit the puja
                                            Get.to(
                                              () => AddPujaForm(
                                                isEdit: true,
                                                puja: puja,
                                              ),
                                            );
                                          })
                                      : const SizedBox(),
                                  puja.pujaImages![0].toString()==""||puja.pujaImages![0].toString()=="null"?SizedBox(): ClipRRect(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    child: Image.network("${puja.pujaImages![0]}",
                                    height: 10.h,
                                    width: 35.w,),
                                  ),
                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.delete,
                                  //       color: Get.theme.primaryColor,
                                  //       size: 18.sp,
                                  //     ),
                                  //     onPressed: () {
                                  //       log('clicked on delete');
                                  //       //delete the puja
                                  //       poojacontroller
                                  //           .deleteCustomPuja(puja.id!);
                                  //     }),
                                ],
                              )
                            ],
                          ),

                          /// Description
                          Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  puja.longDescription ?? '',
                                  // 'hey buddy hereo i am here to work with you continiouslly please tell me everything is going well that side or not pls respond as sooon as possibel ok ji',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: 'Poppins-Regular',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start: ${DateFormat('dd/MM/yy HH:mm').format(puja.pujaStartDatetime!)}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'Duration: ${puja.pujaDuration} min',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 1),

                          /// Info Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price: ₹${puja.pujaPrice!.length > 12 ? '${puja.pujaPrice!.substring(0, 12)}..' : puja.pujaPrice ?? ''}",
                                style: const TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                              Text(
                                "Place: ${puja.pujaPlace!.length > 12 ? '${puja.pujaPlace!.substring(0, 12)}..' : puja.pujaPlace ?? ''}",
                                style: const TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                            ],
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
                                  color: puja.isAdminApproved == 'Pending' ||
                                          puja.isAdminApproved == 'Rejected'
                                      ? Colors.orange
                                      : Colors.green,
                                  fontSize: 12.sp),
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                },
              )),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String get capitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
