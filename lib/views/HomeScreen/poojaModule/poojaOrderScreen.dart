// ignore_for_file: must_be_immutable, file_names

import 'dart:async';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class PoojaOrderScreen extends StatefulWidget {
  final bool showAppbar;
  const PoojaOrderScreen({super.key, required this.showAppbar});
  @override
  State<PoojaOrderScreen> createState() => _PoojaOrderScreen();
}

class _PoojaOrderScreen extends State<PoojaOrderScreen> {
  final signupController = Get.find<SignupController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getallpoojaorder());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar == true
          ? AppBar(
              iconTheme:  IconThemeData(color:  COLORS().textColor),
              backgroundColor: COLORS().primaryColor,
              title:  Text(
                'Puja Order History',
                style: TextStyle(color: COLORS().textColor),
              ).tr(),
            )
          : null,
      backgroundColor: Colors.grey.shade50,
      body: GetBuilder<SignupController>(
        builder: (signupController) {
          return signupController.astrologerList.isEmpty
              ? SizedBox(child: Center(child: const Text('Please wait..').tr()))
              : signupController.astrologerList.isEmpty &&
                      signupController.astrologerList[0]?.pujaOrder == null &&
                      signupController.astrologerList[0]!.pujaOrder!.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                            bottom: 200,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: COLORS().primaryColor,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            onPressed: () async {
                              signupController.astrologerList.clear();
                              await signupController
                                  .astrologerProfileById(false);
                              signupController.update();
                            },
                            child: const Icon(
                              Icons.refresh_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                            child: const Text('No Puja history is here').tr()),
                      ],
                    )
                  : GetBuilder<SignupController>(
                      builder: (signupController) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await signupController.astrologerProfileById(false);
                            signupController.update();
                          },
                          child: ListView.builder(
                            itemCount: signupController
                                .astrologerList[0]?.pujaOrder?.length,
                            controller:
                                signupController.poojaHistoryScrollController,
                            physics: const ClampingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemBuilder: (context, index) {
                              List<String>? pujaImages = (signupController
                                      .astrologerList[0]!
                                      .pujaOrder?[index]
                                      .pujaImages as List<dynamic>?)
                                  ?.map((e) => e.toString())
                                  .toList();

                              return _buildPoojaOrderCard(index, pujaImages);
                            },
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }

  Widget _buildPoojaOrderCard(int index, List<String>? pujaImages) {
    final pujaOrder = signupController.astrologerList[0]!.pujaOrder?[index];
    final isCompleted = pujaOrder?.pujaLink.toString() == "Completed";
    final isStartingSoon =
        pujaOrder?.pujaLink.toString() == "Link will be available soon";
    final isIncompletePuja =
        pujaOrder?.pujaLink.toString() == "Incomplete Puja";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Image Slider Section
            _buildImageSlider(pujaImages),

            // Content Section
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Puja Name and Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pujaOrder?.pujaName ?? 'N/A',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildInfoButton(pujaOrder),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Price and Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!global.isCoinWallet())
                            Text(
                              '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                              style: TextStyle(
                                color: COLORS().primaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: CachedNetworkImage(
                                imageUrl: global.getSystemFlagValue(
                                    global.systemFlagNameList.coinIcon),
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Text(
                            pujaOrder?.orderTotalPrice?.toStringAsFixed(2) ??
                                '0.00',
                            style: TextStyle(
                              color: COLORS().primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatDate(pujaOrder?.pujaStartDatetime),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Status and Action Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green.withOpacity(0.1)
                              : isIncompletePuja
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCompleted
                                ? Colors.green
                                : isIncompletePuja
                                    ? Colors.red
                                    : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          isCompleted
                              ? "Completed"
                              : isIncompletePuja
                                  ? "Incomplete"
                                  : "In Progress",
                          style: TextStyle(
                            color: isCompleted
                                ? Colors.green
                                : isIncompletePuja
                                    ? Colors.red
                                    : Colors.orange,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Action Button - Only show if not completed and not incomplete
                      if (!isCompleted && !isIncompletePuja)
                        _buildActionButton(pujaOrder, isStartingSoon),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String>? pujaImages) {
    print("puja images-> ${pujaImages}");
    if (pujaImages == null || pujaImages.isEmpty) {
      return Container(
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.photo_library_outlined,
            size: 40.sp,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return PujaImagesSlider(
      index: 0,
      imageUrls: pujaImages,
    );
  }

  Widget _buildInfoButton(pujaOrder) {
    return GestureDetector(
      onTap: () => _showPoojaDetailsDialog(pujaOrder),
      child: Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.info_outline,
          color: Colors.blue.shade700,
          size: 18.sp,
        ),
      ),
    );
  }

  Widget _buildActionButton(pujaOrder, bool isStartingSoon) {
    final pujaLink = pujaOrder?.pujaLink?.toString() ?? '';

    // Determine button text based on conditions
    String buttonText = "Start Puja";
    Color buttonColor = COLORS().primaryColor;
    bool isEnabled = true;

    if (pujaLink == "Link will be available soon") {
      buttonText = "Starting Soon";
      buttonColor = Colors.grey;
      isEnabled = false;
    } else if (pujaLink == "Incomplete Puja") {
      buttonText = "Incomplete Puja";
      buttonColor = Colors.grey;
      isEnabled = false;
    }

    return ElevatedButton(
      onPressed: isEnabled
          ? () {
              if (pujaLink == "Link will be available soon") {
                Get.snackbar(
                  "Note:-",
                  "Puja will start soon",
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                  backgroundColor: Theme.of(Get.context!).primaryColor,
                  colorText: Colors.white,
                );
              } else {
                launchUrl(Uri.parse(pujaLink));
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: COLORS().primaryColor,
        foregroundColor: COLORS().textColor,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(dynamic dateTime) {
    if (dateTime == null) return "N/A";
    try {
      final date = DateTime.parse(dateTime.toString());
      return DateFormat('dd-MM-yyyy hh:mm a').format(date);
    } catch (e) {
      return "N/A";
    }
  }

  void _showPoojaDetailsDialog(pujaOrder) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 80.h,
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pujaOrder?.pujaName ?? 'Puja Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20.sp),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelValue(
                            'Package', pujaOrder?.packageName ?? 'N/A'),
                        _buildLabelValue(
                          'Status',
                          pujaOrder?.pujaOrderStatus ?? 'N/A',
                          valueColor: (pujaOrder?.pujaOrderStatus
                                          ?.toLowerCase() ==
                                      'completed' ||
                                  pujaOrder?.pujaOrderStatus?.toLowerCase() ==
                                      'placed')
                              ? Colors.green
                              : pujaOrder?.pujaLink?.toString() ==
                                      "Incomplete Puja"
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                        _buildLabelValue('Start Date',
                            _formatDate(pujaOrder?.pujaStartDatetime)),
                        _buildLabelValue('End Date',
                            _formatDate(pujaOrder?.pujaEndDatetime)),
                        _buildLabelValue(
                          'Location',
                          '${pujaOrder?.addressCity ?? 'N/A'}, ${pujaOrder?.addressState ?? ''}',
                        ),
                        if (pujaOrder?.pujaLink?.toString() ==
                            "Incomplete Puja")
                          _buildLabelValue('Puja Status', 'Incomplete Puja',
                              valueColor: Colors.red),
                        if (pujaOrder?.pujaLink?.toString() ==
                            "Link will be available soon")
                          _buildLabelValue('Puja Status', 'Starting Soon',
                              valueColor: Colors.orange),
                        _buildLabelValue(
                          'Description',
                          (pujaOrder?.package?.description ?? 'N/A')
                              .replaceAll('[', '')
                              .replaceAll(']', ''),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: COLORS().primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Custom helper to show label above value
  Widget _buildLabelValue(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void getallpoojaorder() async {
    signupController.astrologerList.clear();
    await signupController.astrologerProfileById(false);
    signupController.update();
  }
}

// Keep your existing PujaImagesSlider class as it is
class PujaImagesSlider extends StatefulWidget {
  final List<String> imageUrls;
  final int index;

  const PujaImagesSlider({
    super.key,
    required this.imageUrls,
    required this.index,
  });

  @override
  State<PujaImagesSlider> createState() => _PujaImagesSliderState();
}

class _PujaImagesSliderState extends State<PujaImagesSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentIndex + 1) % widget.imageUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.where((url) => url.isNotEmpty).toList();

    if (images.isEmpty) {
      return Center(
        child: Image.asset("assets/images/pujaicon.png", fit: BoxFit.cover),
      );
    }

    return Column(
      children: [
        GetBuilder<SignupController>(
          builder: (signupController) => SizedBox(
            height: 25.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, imgIndex) {
                final imageUrl = images[imgIndex];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        images.length > 1
            ? SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: WormEffect(
                  activeDotColor: Colors.green,
                  dotColor: Colors.green.shade500,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
