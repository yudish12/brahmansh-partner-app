// ignore_for_file: unused_local_variable, must_be_immutable, use_build_context_synchronously, unnecessary_null_comparison, unrelated_type_equality_checks
import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:brahmanshtalk/controllers/callAvailability_controller.dart';
import 'package:brahmanshtalk/controllers/chatAvailability_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/LiveScheduleScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/OfferDiscountsScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/widgetui.dart';
import 'package:brahmanshtalk/controllers/following_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/FreeKundli/Tabs/reportTabs/chatAvailabilityScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/ProfileDetailScreen/assignment_detail_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/ProfileDetailScreen/availabity_Detail_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/ProfileDetailScreen/other_detail_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/ProfileDetailScreen/skill_detail_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/follower_list_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/mediapickerDialog.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/stories_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/call/agora/callAvailabilityScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/viewStories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../constants/imageConst.dart';
import '../../../controllers/storiescontroller.dart';
import 'testscreen.dart';
enum StatusOption { image, video, text }
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final signupController = Get.find<SignupController>();
  final followingController = Get.find<FollowingController>();
  final chatAvailabilityController = Get.find<ChatAvailabilityController>();
  final callAvailabilityController = Get.find<CallAvailabilityController>();
  final storycontroller = Get.find<StoriesController>();

  @override
  void initState() {
    super.initState();
    loadstory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SignupController>(
        builder: (signupController) {
          return RefreshIndicator(
              onRefresh: () async {
                followingController.followerList.clear();
                followingController.followingList(false);
                followingController.update();
                await signupController.astrologerProfileById(false);
                signupController.update();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildtopprofilewidget(context),
                    SizedBox(height: 4.h),

                    // Center in remaining space
                    Align(
                      alignment: Alignment.center,
                      child: buildGridView(context),
                    ),

                    SizedBox(height: 12.h),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget buildGridView(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(7),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        shrinkWrap: true,
        itemCount:signupController. optionsList.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildoptionlistwidget(
          context,
          signupController.optionsList[index],
          signupController.optionsIconList[index],
          signupController.colorsList[index],
          index,
          (indexx) async {
            if (indexx == 0) {
              // Step 1: Pick video from gallery
              final ImagePicker picker = ImagePicker();
              XFile? pickedVideo =
                  await picker.pickVideo(source: ImageSource.gallery);
              if (pickedVideo != null) {
                File file = File(pickedVideo.path);
                // Get file size in bytes
                int fileSize = await file.length();
                // Convert to MB
                double sizeInMb = fileSize / (1024 * 1024);
                log("Picked video size: ${sizeInMb.toStringAsFixed(2)} MB");
                if (sizeInMb > 50) {
                  global.showToast(
                      message: "Video size should not exceed 50 MB");
                  return;
                }
                log("Picked video path: ${file.path}");
                global.showOnlyLoaderDialog();
                await storycontroller.uploadAstroVideo(file);
                global.hideLoader();
              } else {
                log("No video selected");
              }
            }
            if (indexx == 1) {
              Get.to(() => const LiveScheduleScreen());
            }
            if (indexx == 2) {
              await signupController.astrologerProfileById(false);
              signupController.update();
              Get.to(() => const CommissionScreen());
            }
            if (indexx == 3) {
              Get.to(() => SkillDetailScreen());
            }
            if (indexx == 4) {
              Get.to(() => const OtherDetailScreen());
            }
            if (indexx == 5) {
              Get.to(() => const AssignmentDetailScreen());

            
            }
            if (indexx == 6) {
                await signupController.astrologerProfileById(false);
              signupController.update();
              Get.to(() => AvailabiltyScreen());
            }
          },
        ),
      ),
    );
  }

  Container _buildtopprofilewidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Get.theme.primaryColor,
            Get.theme.primaryColor.withOpacity(0.8)
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image Section
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    GetBuilder<StoriesController>(
                      builder: (storycontroller) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  storycontroller.viewSingleStory.isNotEmpty ==
                                          false
                                      ? Colors.white
                                      : Colors.green,
                              width: 3,
                            ),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[200]!],
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              storycontroller
                                  .getAstroStory(
                                signupController.astrologerList[0]!.id
                                    .toString(),
                              )
                                  .then((value) {
                                log("My Image url${signupController.astrologerList[0]!.imagePath}");
                                value.isEmpty
                                    ? global.showToast(
                                        message: 'No Story Uploaded')
                                    : Get.to(
                                        () => ViewStoriesScreen(
                                          profile:
                                              "${signupController.astrologerList[0]!.imagePath}",
                                          name: signupController
                                              .astrologerList[0]!.name
                                              .toString(),
                                          isprofile: false,
                                          astroId: int.parse(signupController
                                              .astrologerList[0]!.id
                                              .toString()),
                                        ),
                                      );
                              });
                            },
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.white,
                              child: signupController
                                          .astrologerList.isNotEmpty &&
                                      global.user.imagePath != null &&
                                      global.user.imagePath!.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                           global.buildImageUrl("${signupController.astrologerList[0]!.imagePath}"),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          backgroundColor:
                                              Get.theme.primaryColor,
                                          child: const Icon(Icons.person,
                                              color: Colors.white, size: 30),
                                        ),
                                      ),
                                    )
                                  : Container(
                                    height: 80,
                                    width: 80,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                       ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 45,
                                      backgroundImage: AssetImage(
                                        IMAGECONST.noCustomerImage,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // User Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      global.user.name != null && global.user.name != ''
                          ? global.user.name![0].toUpperCase() +
                              global.user.name!.substring(1).toLowerCase()
                          : tr("Astrologer Name"),
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: COLORS().textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                         Icon(Icons.phone,
                            size: 14, color: COLORS().textColor.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        Text(
                          global.user.contactNo != null &&
                                  global.user.contactNo != ''
                              ? global.user.contactNo!
                              : "",
                          style:  TextStyle(
                            fontSize: 13,
                            color:COLORS().textColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                         Icon(Icons.email,
                            size: 14, color: COLORS().textColor.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            global.user.email != null && global.user.email != ''
                                ? (global.user.email!.length > 20
                                    ? '${global.user.email!.substring(0, 20)}...'
                                    : global.user.email!)
                                : "",
                            style:  TextStyle(
                              fontSize: 13,
                              color: COLORS().textColor.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Badges Section
              SizedBox(
                width: 60,
                child: signupController.astrologerList.isEmpty
                    ? const SizedBox()
                    : GetBuilder<SignupController>(
                        builder:
                            (signupController) =>
                                signupController.astrologerList == null &&
                                        signupController.astrologerList == "" &&
                                        signupController.astrologerList.isEmpty
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          signupController.astrologerList[0]!
                                                      .courseBadges?.isEmpty ==
                                                  true
                                              ? global.showToast(
                                                  message: 'No Badges')
                                              : showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      insetPadding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Container(
                                                        width: double.infinity,
                                                        constraints:
                                                            BoxConstraints(
                                                          maxHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.7,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color(
                                                                  0xFF1a237e),
                                                              Color(
                                                                  0xFF311b92),
                                                              Color(
                                                                  0xFF4a148c),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .purple
                                                                  .shade900
                                                                  .withOpacity(
                                                                      0.5),
                                                              blurRadius: 25,
                                                              offset:
                                                                  const Offset(
                                                                      0, 10),
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.1),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            // Cosmic Header
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    const Color(
                                                                            0xFF3949ab)
                                                                        .withOpacity(
                                                                            0.9),
                                                                    const Color(
                                                                        0xFF283593),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .shade900
                                                                        .withOpacity(
                                                                            0.3),
                                                                    blurRadius:
                                                                        10,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            3),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  // Cosmic background elements
                                                                  Positioned(
                                                                    top: 10,
                                                                    right: 50,
                                                                    child: Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .yellow
                                                                          .shade200
                                                                          .withOpacity(
                                                                              0.4),
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 25,
                                                                    left: 40,
                                                                    child: Icon(
                                                                      Icons
                                                                          .auto_awesome,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.3),
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 15,
                                                                    right: 30,
                                                                    child: Icon(
                                                                      Icons
                                                                          .psychology,
                                                                      color: Colors
                                                                          .cyan
                                                                          .shade200
                                                                          .withOpacity(
                                                                              0.3),
                                                                      size: 16,
                                                                    ),
                                                                  ),

                                                                  Row(
                                                                    children: [
                                                                      // Astrology icon container
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            12),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              const LinearGradient(
                                                                            colors: [
                                                                              Color(0xFF5c6bc0),
                                                                              Color(0xFF3949ab),
                                                                            ],
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.blue.shade900.withOpacity(0.4),
                                                                              blurRadius: 8,
                                                                              offset: const Offset(0, 3),
                                                                            ),
                                                                          ],
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.white.withOpacity(0.2),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .auto_awesome_rounded,
                                                                          color: Colors
                                                                              .yellow
                                                                              .shade200,
                                                                          size:
                                                                              28,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              16),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Your Achievements',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                letterSpacing: 0.5,
                                                                                shadows: [
                                                                                  Shadow(
                                                                                    blurRadius: 6,
                                                                                    color: Colors.black.withOpacity(0.4),
                                                                                    offset: const Offset(1, 1),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 4),
                                                                            Text(
                                                                              '${signupController.astrologerList[0]!.courseBadges?.length ?? 0} celestial badges earned',
                                                                              style: TextStyle(
                                                                                color: Colors.white.withOpacity(0.9),
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                          onTap: () =>
                                                                              Navigator.of(context).pop(),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white.withOpacity(0.15),
                                                                              borderRadius: BorderRadius.circular(50),
                                                                              border: Border.all(
                                                                                color: Colors.white.withOpacity(0.3),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.close_rounded,
                                                                              color: Colors.white,
                                                                              size: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Content Area
                                                            Flexible(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      Colors
                                                                          .white,
                                                                      Color(
                                                                          0xFFf3e5f5),
                                                                    ],
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .purple
                                                                          .shade300
                                                                          .withOpacity(
                                                                              0.2),
                                                                      blurRadius:
                                                                          15,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              5),
                                                                    ),
                                                                  ],
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .purple
                                                                        .shade100
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    // Cosmic divider
                                                                    Container(
                                                                      height: 2,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              16),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Colors.transparent,
                                                                            const Color(0xFF7986cb).withOpacity(0.6),
                                                                            Colors.transparent,
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    // Badges grid
                                                                    Expanded(
                                                                      child:
                                                                          buildBadgesList(),
                                                                    ),

                                                                    // Cosmic footer
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              16),
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          12),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          colors: [
                                                                            Color(0xFFe8eaf6),
                                                                            Color(0xFFc5cae9),
                                                                          ],
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFF9fa8da).withOpacity(0.3),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          const Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.auto_awesome_rounded,
                                                                            color:
                                                                                Color(0xFF5c6bc0),
                                                                            size:
                                                                                16,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 8),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              'Continue your journey to unlock more achievements',
                                                                              style: TextStyle(
                                                                                color: Color(0xFF3949ab),
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ],
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
                                                  },
                                                );
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.green
                                                      .withOpacity(0.6),
                                                ),
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                  Icons.emoji_events,
                                                  color: Colors.white,
                                                  size: 24),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${signupController.astrologerList[0]!.courseBadges?.length ?? 0}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                      ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom Action Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Followers Count
              GetBuilder<FollowingController>(
                builder: (followingController) {
                  return followingController.followerList.isEmpty
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            followingController.followerList.clear();
                            followingController.update();
                            followingController.followingList(false);
                            Get.to(() => FollowerListScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.people,
                                    size: 16, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  '${followingController.followerList.length} followers',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).tr(),
                              ],
                            ),
                          ),
                        );
                },
              ),

              // Upload Story Button
              GetBuilder<StoriesController>(
                builder: (storycontroller) => PopupMenuButton<int>(
                  onSelected: (value) async {
                    if (value == 1) {
                      Get.to(() => const TextScreen());
                    } else if (value == 2) {
                      log('pick image clicked');
                      await storycontroller.pickMedia(
                          context, MediaTypes.image);
                    } else if (value == 3) {
                      storycontroller.pickMedia(context, MediaTypes.video);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(Icons.text_fields, color: Colors.black),
                          const SizedBox(width: 10),
                          Text("Text", style: Get.theme.textTheme.bodySmall)
                              .tr(),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(Icons.image, color: Colors.black),
                          const SizedBox(width: 10),
                          Text("Image", style: Get.theme.textTheme.bodySmall)
                              .tr(),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          const Icon(Icons.videocam, color: Colors.black),
                          const SizedBox(width: 10),
                          Text("Video", style: Get.theme.textTheme.bodySmall)
                              .tr(),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add,
                            size: 16, color: Get.theme.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          "Upload Story",
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildoptionlistwidget(
    BuildContext context,
    String title,
    String imgpath,
    Color color,
    int indx,
    Function(int indexx) ongridTap,
  ) {
    return InkWell(
      onTap: () {
        ongridTap(indx);
      },
      onTapDown: (_) {
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image(
                image: AssetImage(imgpath),
                height: 24,
                width: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }

  void showStatusOptionsDialog(BuildContext context) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () async {
                    log('pick image clicked');
                    await storycontroller.pickMedia(context, MediaTypes.image);
                    Get.back();
                    Get.to(() => const StoriesScreen());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image,
                          color: Theme.of(context).primaryColor, size: 16),
                      const SizedBox(width: 8),
                      const Text('Image',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const Divider(height: 0.3, color: Colors.black),
                CupertinoButton(
                  onPressed: () {
                    storycontroller.pickMedia(context, MediaTypes.video);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam,
                          color: Theme.of(context).primaryColor, size: 16),
                      const SizedBox(width: 8),
                      const Text('Video',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const Divider(height: 0.3, color: Colors.black),
                CupertinoButton(
                  onPressed: () {
                    Get.to(() => const TextScreen())!.then((value) {
                      Get.back();
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.text_increase,
                          color: Theme.of(context).primaryColor, size: 16),
                      const SizedBox(width: 8),
                      const Text('Text', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void loadstory() async {
    log('load stories init');
    await storycontroller.getAstroStory(
      signupController.astrologerList[0]!.id.toString(),
    );
    storycontroller.update();
  }
}
