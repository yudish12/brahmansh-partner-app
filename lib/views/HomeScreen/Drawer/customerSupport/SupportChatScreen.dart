import 'package:brahmanshtalk/controllers/customerSupportController/customerSupportController.dart';
import 'package:brahmanshtalk/models/chat_message_model.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportChatScreen extends StatefulWidget {
  final int flagId;
  final String ticketNo;
  final String fireBasechatId;
  final int ticketId;
  final String ticketStatus;
  const SupportChatScreen(
      {super.key,
      required this.flagId,
      required this.ticketNo,
      required this.fireBasechatId,
      required this.ticketId,
      required this.ticketStatus});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController msgController = TextEditingController();
  final supportController = Get.find<AstrologerSupportController>();

  @override
  void dispose() {
    subjectController.dispose();
    descriptionController.dispose();
    msgController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (msgController.text.trim().isEmpty) return;
    supportController.sendMessage(
        msgController.text.trim(), widget.fireBasechatId, widget.ticketId);
    msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(title: Text("Ticket ${widget.ticketNo}")),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: supportController.getChatMessages(
                        widget.fireBasechatId, global.astrologerId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState.name == "waiting") {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.hasError) {
                          return Text('snapShotError :- ${snapshot.error}');
                        } else {
                          List<ChatMessageModel> messageList = [];
                          for (var res in snapshot.data!.docs) {
                            messageList
                                .add(ChatMessageModel.fromJson(res.data()));
                          }
                          messageList = messageList.reversed.toList();

                          return ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: messageList.length,
                            itemBuilder: (context, index) {
                              ChatMessageModel message = messageList[index];
                              supportController.isMe =
                                  message.userId1 == '${global.astrologerId}';
                              return Align(
                                alignment: supportController.isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: supportController.isMe
                                        ? Get.theme.primaryColor
                                        : Colors.grey.shade300,
                                    gradient: LinearGradient(
                                      colors: supportController.isMe
                                          ? [
                                              const Color(0xFFE3F2FD),
                                              const Color(0xFFFFF3E0)
                                            ]
                                          : [
                                              Colors.grey.shade300,
                                              Colors.grey.shade300
                                            ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                      bottomLeft: supportController.isMe
                                          ? const Radius.circular(12)
                                          : Radius.zero,
                                      bottomRight: supportController.isMe
                                          ? Radius.zero
                                          : const Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    messageList[index].message!,
                                    style: TextStyle(
                                      color: supportController.isMe
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    }),
              ),
            ],
          ),
          bottomSheet: widget.ticketStatus == "CLOSED"
              ? null
              : widget.ticketStatus == "OPEN"
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: msgController,
                              decoration: InputDecoration(
                                hintText: "Type your message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              backgroundColor: Get.theme.primaryColor,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        "Please wait until your ticket is opened.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    )),
    );
  }
}
