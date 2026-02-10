import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/Authentication/signup_controller.dart';
import '../../../models/ScheduleLiveModel.dart';

class LiveScheduleScreen extends StatefulWidget {
  const LiveScheduleScreen({super.key});

  @override
  State<LiveScheduleScreen> createState() => _LiveScheduleScreenState();
}

class _LiveScheduleScreenState extends State<LiveScheduleScreen> {
  final signupcontroller = Get.find<SignupController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchscheduleLive());
  }

  _fetchscheduleLive() async {
    await signupcontroller.fetchScheduleList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        signupcontroller.scheduleList.clear();
        signupcontroller.update();
        await signupcontroller.fetchScheduleList();
      },
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
            "Live Schedule",
            style: TextStyle(fontWeight: FontWeight.bold,
            color: COLORS().textColor),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: COLORS().primaryColor,
        ),
        body: GetBuilder<SignupController>(
          builder: (signupcontroller) {
            if (signupcontroller.scheduleList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No schedules available",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: signupcontroller.scheduleList.length,
              itemBuilder: (context, index) {
                final item = signupcontroller.scheduleList[index];
                return _buildScheduleCard(item, signupcontroller);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleLive item, SignupController controller) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
         
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: ClipOval(
                child: item.profileImage != null &&
                        item.profileImage!.isNotEmpty
                    ? Image.network(
                        "${item.profileImage}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.person, color: Colors.grey[500]),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[500]),
                      ),
              ),
            ),

            const SizedBox(width: 16),

            // Schedule Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment
                    .center, 
                children: [
                  Text(
                    item.astrologerName ?? "Unknown Astrologer",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.deepPurple[300]),
                      const SizedBox(width: 4),
                      Text(
                        item.scheduleLiveDate != null
                            ? (() {
                                final date =
                                    DateTime.tryParse(item.scheduleLiveDate);
                                return date != null
                                    ? "${date.day}/${date.month}/${date.year}"
                                    : "Invalid date";
                              })()
                            : "Date not set",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.deepPurple[300]),
                      const SizedBox(width: 4),
                      Text(
                        item.scheduleLiveTime ?? "Time not set",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  if (item.isActive != null && item.isActive!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item.isActive!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.isActive!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Delete Button - Centered vertically
            IconButton(
              onPressed: () {
                controller.deleteLiveSchedule(item.id!);
              },
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'live':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.deepPurple;
    }
  }
}
