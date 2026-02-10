// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:brahmanshtalk/models/astrologerTicketsModel.dart';
import 'package:brahmanshtalk/models/chat_message_model.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AstrologerSupportController extends GetxController {
  APIHelper apiHelper = APIHelper();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var ticketList = <AstrologerTickets>[];
  bool isMe = true;
  CollectionReference userChatCollectionRef =
      FirebaseFirestore.instance.collection("supportChat");

  Future uploadMessage(
      String idUser, String partnerId, ChatMessageModel anonymous) async {
    try {
      final String globalId = global.astrologerId.toString();
      final refMessages = userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages');
      final refMessages1 = userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages');
      final newMessage1 = anonymous;

      final newMessage2 = anonymous;
      newMessage2.messageId = refMessages1.id;

      var messageResult =
          await refMessages.add(newMessage1.toJson()).catchError((e) {
        print('send mess exception $e');
        return e;
      });
      newMessage1.messageId = messageResult.id;
      await userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages')
          .doc(newMessage1.messageId)
          .update({"messageId": newMessage1.messageId});

      newMessage2.isRead = false;
      var message1Result =
          await refMessages1.add(newMessage2.toJson()).catchError((e) {
        print('send mess exception $e');
        return e;
      });
      await userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages')
          .doc(newMessage1.messageId)
          .update({"messageId": newMessage1.messageId});
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      print('uploadMessage err $err');
    }
  }

  raiseTicket() async {
    try {
      var bodydata = {
        "subject": subjectController.text.trim(),
        "description": descriptionController.text.trim(),
        "userId": global.astrologerId,
        "sender_type": "Astrologer"
      };
      log("my ticket Body Data $bodydata");
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.creaeteTicket(bodydata).then((result) {
            if (result != null) {
              update();
              getAstrologerTickets();
              debugPrint(
                  "description firebase ${result.recordList["description"]}");
              debugPrint("chatid firebase ${result.recordList["chatId"]}");
              debugPrint("firebase id ${result.recordList["id"]}");
              sendMessage('${result.recordList["description"]}',
                  result.recordList["chatId"], result.recordList["id"]);
            } else {}
            update();
          });
        }
      });
    } catch (e) {
      debugPrint('Exception in getBasicDetail(): $e');
    }
  }

  getAstrologerTickets() async {
    try {
      var data = {"userId": global.astrologerId, "sender_type": "Astrologer"};
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getTickets(data).then((result) {
            if (result.status == "200") {
              ticketList = result.recordList;
              update();
              log("Myy All Tickets $ticketList");
            } else {
              log("Failed to Get Tickets");
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getCustomerTickets(): $e');
    }
  }

  Future<void> sendMessage(String message, String chatId, int partnerId) async {
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.astrologerId}',
          userId2: '$partnerId',
        );
        update();
        await uploadMessage(chatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(
      String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
          .instance
          .collection('supportChat/$firebaseChatId/userschat')
          .doc('$currentUserId')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots();
      return data;
    } catch (err) {
      print("Exception in- getChatMessages() $err");
      return null;
    }
  }

  bool isOpenTicket = false;
  getClosedTicketStatus() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getTicketStatus().then((result) async {
            if (result.status == "200") {
              isOpenTicket = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Get ticket status failed',
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getClosedTicketStatus(): $e');
    }
  }
}
