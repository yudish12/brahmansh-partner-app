import 'package:brahmanshtalk/controllers/customerSupportController/customerSupportController.dart';
import 'package:brahmanshtalk/views/HomeScreen/Drawer/customerSupport/SupportChatScreen.dart';
import 'package:brahmanshtalk/widgets/commonDialogWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/colorConst.dart';
import '../../../../widgets/app_bar_widget.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final supportController = Get.find<AstrologerSupportController>();

  void _showRaiseTicketSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GetBuilder<AstrologerSupportController>(
            builder: (supportController) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  "Raise a Support Ticket",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: supportController.subjectController,
                  decoration: InputDecoration(
                    labelText: "Subject",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: supportController.descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (supportController.subjectController.text.isNotEmpty &&
                          supportController
                              .descriptionController.text.isNotEmpty) {
                        supportController.update();
                        supportController.raiseTicket();
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Ticket raised successfully ✅"),
                          ),
                        );
                        supportController.subjectController.clear();
                        supportController.descriptionController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Submit Ticket"),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await supportController.getAstrologerTickets();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: MyCustomAppBar(
            backgroundColor: COLORS().primaryColor,
              iconData:  IconThemeData(color: COLORS().textColor),
              title:  Text("Support Tickets",
          style: TextStyle(
            color: COLORS().textColor
          ),)),
          body: RefreshIndicator(
            onRefresh: () async {
              await supportController.getAstrologerTickets();
              supportController.update();
            },
            child: GetBuilder<AstrologerSupportController>(
              builder: (supportController) {
                if (supportController.ticketList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No tickets found",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "You haven’t raised any support tickets yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 5, bottom: 100),
                    itemCount: supportController.ticketList.length,
                    itemBuilder: (context, index) {
                      final ticket = supportController.ticketList[index];
                      return InkWell(
                          onTap: () {
                            Get.to(() => SupportChatScreen(
                                  flagId: 1,
                                  ticketNo: ticket.ticketNumber!,
                                  fireBasechatId: ticket.chatId!,
                                  ticketId: ticket.id!,
                                  ticketStatus: ticket.ticketStatus!,
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Circle with first letter
                                    CircleAvatar(
                                      backgroundColor:
                                          Colors.redAccent.shade100,
                                      child: Text(
                                        (ticket.subject?.isNotEmpty == true
                                            ? ticket.subject![0].toUpperCase()
                                            : "N"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ticket.subject ?? "No Subject",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            ticket.description ??
                                                "No Description",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Status text
                                    Text(
                                      ticket.ticketStatus ?? "Unknown",
                                      style: TextStyle(
                                        color: ticket.ticketStatus == "OPEN"
                                            ? Colors.green
                                            : ticket.ticketStatus == "WAITING"
                                                ? Colors.blue
                                                : ticket.ticketStatus ==
                                                        "CLOSED"
                                                    ? Colors.red
                                                    : Colors.purpleAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    ticket.createdAt != null
                                        ? "Created at: ${DateFormat('yyyy-MM-dd HH:mm').format(ticket.createdAt!)}"
                                        : "",
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                }
              },
            ),
          ),
          bottomSheet: GetBuilder<AstrologerSupportController>(
              builder: (supportController) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await supportController.getClosedTicketStatus();
                    if (!supportController.isOpenTicket) {
                      _showRaiseTicketSheet();
                    } else {
                      showCommonDialog(
                        title: "Alert!",
                        subtitle:
                            "You can not raise multiple tickets. Please resolve your open ticket before creating a new one.",
                        primaryButtonText: 'Okay',
                        onPrimaryPressed: () {
                          Get.back();
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Get.theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text("Raise Ticket",
                  style: TextStyle(
                    color: COLORS().textColor
                  ),),
                ),
              ),
            );
          })),
    );
  }
}
