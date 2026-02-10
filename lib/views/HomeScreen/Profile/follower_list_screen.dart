// ignore_for_file: must_be_immutable

import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/following_controller.dart';
import 'package:brahmanshtalk/models/following_model.dart';
import 'package:brahmanshtalk/widgets/app_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/imageConst.dart';

class FollowerListScreen extends StatelessWidget {
  FollowingModel? following;
  FollowerListScreen({super.key, this.following});
  final followingController = Get.find<FollowingController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
            height: 80,
            backgroundColor: COLORS().primaryColor,
            iconData:  IconThemeData(color: COLORS().textColor),
            title:
                 Text("myFollowers", style: TextStyle(color: COLORS().textColor))
                    .tr()),
        body: GetBuilder<FollowingController>(
          builder: (followingController) {
            return followingController.followerList.isEmpty
                ? Center(
                    child: const Text("You don't have followers yet!").tr(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        followingController.followerList.clear();
                        followingController.update();
                        await followingController.followingList(false);
                      },
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Divider(
                              height: 3.w,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                        itemCount: followingController.followerList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                decoration: BoxDecoration(
                                  color: COLORS().greyBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: followingController
                                                  .followerList[index]
                                                  .profile !=
                                              null &&
                                          followingController
                                                  .followerList[index]
                                                  .profile !=
                                              ""
                                      ? Container(
                                          height: 7.h,
                                          width: 7.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: COLORS().primaryColor,
                                            image: DecorationImage(
                                              scale: 8,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                "${followingController.followerList[index].profile}",
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 7.h,
                                          width: 7.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            border: Border.all(
                                                color: Colors.green, width: 2),
                                            color: COLORS().whiteColor,
                                            image: const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                IMAGECONST.noCustomerImage,
                                              ),
                                            ),
                                          ),
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        followingController.followerList[index]
                                                .name!.isNotEmpty
                                            ? followingController
                                                .followerList[index].name!
                                            : 'User $index',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .displayMedium!
                                            .copyWith(
                                              color: COLORS().blackColor,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "User ID : ",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 14.sp),
                                          ).tr(),
                                          Text(
                                            followingController
                                                        .followerList[index]
                                                        .id !=
                                                    null
                                                ? followingController
                                                    .followerList[index].id
                                                    .toString()
                                                : 'N/A',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 14.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              followingController.isMoreDataAvailable == true &&
                                      !followingController.isAllDataLoaded &&
                                      followingController.followerList.length -
                                              1 ==
                                          index
                                  ? const CircularProgressIndicator()
                                  : const SizedBox(),
                              index ==
                                      followingController.followerList.length -
                                          1
                                  ? const SizedBox(
                                      height: 50,
                                    )
                                  : const SizedBox()
                            ],
                          );
                        },
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
