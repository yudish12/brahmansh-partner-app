// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:brahmanshtalk/models/wait_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../controllers/HomeController/live_astrologer_controller.dart';
import '../../../controllers/networkController.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

class WaitlistTab extends StatefulWidget {
  const WaitlistTab({super.key});

  @override
  _WaitlistTabState createState() => _WaitlistTabState();
}

class _WaitlistTabState extends State<WaitlistTab>
    with AutomaticKeepAliveClientMixin {
  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final networkController = Get.find<NetworkController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadWaitlist());
  }

  Future<void> _loadWaitlist() async {
    final channel =
        'chat_${global.user.id ?? global.currentUserId}';
    await liveAstrologerController.getWaitList(channel);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Waitlist",
          style: TextStyle(color: COLORS().textColor),
        ).tr(),
      ),
      body: GetBuilder<LiveAstrologerController>(
        builder: (controller) {
          return controller.waitList.isEmpty
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
                        ),
                        onPressed: () async {
                          final status =
                              networkController.connectionStatus.value;
                          if (status <= 0) {
                            global.showToast(message: 'No internet');
                            return;
                          }
                          await _loadWaitlist();
                          controller.update();
                        },
                        child: Icon(
                          Icons.refresh_outlined,
                          color: COLORS().textColor,
                        ),
                      ),
                    ),
                    Center(
                      child: const Text(
                        'You don\'t have anyone in waitlist yet!',
                      ).tr(),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await _loadWaitlist();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.waitList.length,
                    physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.waitList[index];
                      return _WaitlistCard(item: item);
                    },
                  ),
                );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _WaitlistCard extends StatelessWidget {
  final WaitList item;

  const _WaitlistCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.userProfile.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: global.buildImageUrl(item.userProfile),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                "assets/images/no_customer_image.png",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/images/no_customer_image.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        item.requestType == "Video"
                            ? Icons.video_call
                            : item.requestType == "Audio"
                                ? Icons.call
                                : Icons.person,
                        color: COLORS().primaryColor,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: COLORS().primaryColor,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            item.userName.isNotEmpty ? item.userName : "User",
                            style: Get.theme.primaryTextTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Icon(
                            item.requestType == "Video"
                                ? Icons.video_call
                                : Icons.call,
                            color: COLORS().primaryColor,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              item.requestType.isNotEmpty
                                  ? item.requestType
                                  : "Request",
                              style: Get.theme.primaryTextTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: item.isOnline
                                  ? Colors.green
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            item.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: item.isOnline
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          if (item.time.isNotEmpty) ...[
                            SizedBox(width: 2.w),
                            Text(
                              '${item.time} sec',
                              style: Get.theme.primaryTextTheme.titleSmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (item.status.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.status == "Pending"
                                ? Colors.orange.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: item.status == "Pending"
                                  ? Colors.orange.shade800
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
