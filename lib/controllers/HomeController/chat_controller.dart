// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, body_might_complete_normally_catch_error

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:brahmanshtalk/models/chat_model.dart';
import 'package:brahmanshtalk/services/apiHelper.dart';
import 'package:brahmanshtalk/views/HomeScreen/chat/ChatSession.dart';
import 'package:brahmanshtalk/views/HomeScreen/chat/chat_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/chat_message_model.dart';
import '../../models/message_model.dart';
import '../../views/HomeScreen/home_screen.dart';
import '../Chattimercontroller.dart';

class ChatController extends GetxController {
  String screen = 'chat_controller.dart';
  String? enteredMessage = '';
  APIHelper apiHelper = APIHelper();
  List<ChatRequest> chatList = [];
  // customer agorachat userId
  String agorapeerUserId = "";
  // astrologer agorachat userId
  String agoraUserId = "";
  // chatId from database
  int? chatId;
  
  // Track accepted chat IDs to prevent duplicate notifications
  Set<int> acceptedChatIds = <int>{};
  String chatusersId = "";
  String? firebaseChatId;
  ChatMessageModel? replymessage = ChatMessageModel();
  final List<String> myblockedList = [];
  List<Keyword> blockedKeywordList = [];
  Set<String> tempBlockedKeywords = {};
  final activeSessions = <String, ChatSession>{}.obs;
  int? userId;
  final userChatCollectionRef = FirebaseFirestore.instance.collection("chats");
  final userpujaChatCollectionRef =
      FirebaseFirestore.instance.collection("pujachats");
  final userChatCollectionRefRTM =
      FirebaseFirestore.instance.collection("LiveChats");
  int chatDurationis = 0;
  final scrollController = ScrollController();
  int fetchRecord = 5;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  bool isInChatScreen = false;
  bool isReading = true;
  bool chatLeft = false;
  /// Set to true by the EndChatFromCustomer FCM handler. chat_screen.dart
  /// uses an ever() Worker on this so backpress() fires immediately without
  /// waiting for the Firebase isInChat stream debounce.
  RxBool customerEndedChatFCM = false.obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  CollectionReference userisTypingChatCollectionRef =
      FirebaseFirestore.instance.collection("chatTyping");
  void addSession(ChatSession session) {
    activeSessions[session.sessionId] = session;
    debugPrint('active session is ${activeSessions[session.fireBasechatId]}');
    debugPrint(
        'lastSaved inside addSession ${activeSessions[session.sessionId]!.lastSaved}');
    saveChatSession(session);
    update();
  }

  void removeSession(String sessionId, {String? firebasechatId}) async {
    global.chatStartedAt = null;
    activeSessions.remove(sessionId);
    global.getStorage.remove("activeChatSession");

    final sp = await SharedPreferences.getInstance();
    await sp.remove("activeChatSession");
    global.isCallOrChat = 0;
    setOnlineStatus(
        false, firebasechatId.toString(), '${global.currentUserId}');
    update();
  }

  Future<void> markMessagesAsRead(String? fireBasechatId, int customerId) async {
    try {
      final firebaseChatId = fireBasechatId;
      print(
          'Marking messages as read in chat: $firebaseChatId and customerid is $customerId');
      final unreadMessages = await FirebaseFirestore.instance
          .collection('chats/$firebaseChatId/userschat')
          .doc(customerId.toString()) 
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .get();
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      log("✅ Marked ${unreadMessages.docs.length} messages as read.");
    } catch (e) {
      debugPrint('❌ Error marking messages as read: $e');
    }
  }

  void saveChatSession(ChatSession session) async {
    try {
      final sessionData = {
        "sessionId": session.sessionId,
        "customerId": session.customerId,
        "astrologerId": session.astrologerId,
        "fireBasechatId": session.fireBasechatId,
        "customerName": session.customerName,
        "customerProfile": session.customerProfile,
        "chatduration": session.chatduration,
        "astrouserID": session.astrouserID,
        "subscriptionId": session.subscriptionId,
        "lastSaved": global.getStorage.read('chatStartedAt'),
        "userFcm": session.userFcm,
        "chatEndedAt": session.chatEndedAt,
      };
      global.getStorage.write("activeChatSession", sessionData);
      final data = global.getStorage.read("activeChatSession");
      debugPrint("✅ Chat session saved successfully $data");
      debugPrint("✅ session medata add karo ${session.chatduration}");

      final sessionDataJson = jsonEncode(sessionData);
      final sp = await SharedPreferences.getInstance();
      await sp.setString("activeChatSession", sessionDataJson);

      final value = sp.getString("activeChatSession");
      if (value != null) {
        final Map<String, dynamic> sessionDataMap = jsonDecode(value);
        print("Session Data Map: $sessionDataMap");
      }
    } catch (e, stacktrace) {
      debugPrint("❌ Failed to save chat session: $e");
      debugPrint("$stacktrace");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserOnlineStatus({
    required String userID,
    String? firebasid,
  }) {
    final String? chatId = firebaseChatId ?? firebasid;
    log('getUserOnlineStatus id is $chatId and userID $userID');

    if (chatId == null) {
      throw Exception('No valid Firebase Chat ID provided');
    }

    return FirebaseFirestore.instance
        .collection('chats/$chatId/userschat')
        .doc(userID)
        .collection('status')
        .doc('chatStatus')
        .snapshots();
  }

  Future<void> setOnlineStatus(
      bool isOnline, String firebaseChatId, String currentUserId,
      {String? extiform}) async {
    print(
        'set online/ofline form $extiform OnlineStatus = $isOnline CurrentUser= $currentUserId FirebaseChatId= $firebaseChatId');
    try {
      await FirebaseFirestore.instance
          .collection('chats/$firebaseChatId/userschat')
          .doc(currentUserId)
          .collection('status')
          .doc('chatStatus')
          .set({'isInChat': isOnline}, SetOptions(merge: true));
    } catch (err) {
      debugPrint("Exception - setOnlineOfflineStatus: ${err.toString()}");
    }
  }

  String addBlockKeywordInList(String text) {
    if (blockedKeywordList[0].type == "offensive-word") {
      List<String> keywords = blockedKeywordList
          .where((keyword) => keyword.pattern != null)
          .expand((keyword) {
            return keyword.pattern!.contains('[')
                ? keyword.pattern!.replaceAll(RegExp(r'[\[\]"]'), '').split(',')
                : [keyword.pattern!];
          })
          .map((word) => word.trim())
          .toList();

      final pattern = RegExp(
          r'\b(' + keywords.map(RegExp.escape).join('|') + r')\b',
          caseSensitive: false);
      text = text.replaceAllMapped(pattern, (match) {
        String keywordMatch = match.group(0)!;
        tempBlockedKeywords.add(keywordMatch);
        return keywordMatch;
      });
    } else {
      debugPrint('no patter available');
    }

    if (blockedKeywordList[1].type == "phone" &&
        blockedKeywordList[1].pattern == "true") {
      final phonePattern =
          RegExp(r'\b(?:\+?\d{1,4})?[\s-]?\d{10}\b'); // Match phone numbers
      text = text.replaceAllMapped(phonePattern, (match) {
        String phoneMatch = match.group(0)!;
        tempBlockedKeywords.add(phoneMatch);
        debugPrint(
            'added temp keyword is $phoneMatch  in list is $tempBlockedKeywords');

        if (phoneMatch.length > 4) {
          String firstTwo = phoneMatch.substring(0, 2);
          String lastTwo = phoneMatch.substring(phoneMatch.length - 2);
          String maskedMiddle = '*' * (phoneMatch.length - 4);
          return firstTwo + maskedMiddle + lastTwo;
        } else {
          return phoneMatch;
        }
      });
    } else {
      debugPrint('phone no is not true');
    }

    // Process email addresses
    if (blockedKeywordList[2].type == "email" &&
        blockedKeywordList[2].pattern == "true") {
      final emailPattern = RegExp(
          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'); // Match emails
      text = text.replaceAllMapped(emailPattern, (match) {
        String emailMatch = match.group(0)!;
        tempBlockedKeywords.add(emailMatch);
        int atIndex = emailMatch.indexOf('@');
        if (atIndex > 1) {
          return emailMatch[0] +
              '*' * (atIndex - 1) +
              emailMatch.substring(atIndex);
        } else {
          return '*' * atIndex + emailMatch.substring(atIndex);
        }
      });
    } else {
      debugPrint('email no is not true');
    }

    log('Blocked keywords used are $tempBlockedKeywords');

    return text;
  }

  String filterBlockedWordsForSending(String text) {
    List<String> keywords = blockedKeywordList
        .where((keyword) => keyword.pattern != null)
        .expand((keyword) {
          return keyword.pattern!.contains('[')
              ? keyword.pattern!.replaceAll(RegExp(r'[\[\]"]'), '').split(',')
              : [keyword.pattern!];
        })
        .map((word) => word.trim())
        .toList();

    final pattern = RegExp(
        r'\b(' + keywords.map(RegExp.escape).join('|') + r')\b',
        caseSensitive: false);

    text = text.replaceAllMapped(pattern, (match) {
      String matchedWord = match.group(0)!;
      debugPrint('Matched Word: $matchedWord');

      if (matchedWord.length > 2) {
        String firstChar = matchedWord[0];
        String lastChar = matchedWord[matchedWord.length - 1];
        String maskedMiddle = '*' * (matchedWord.length - 2); // Mask the middle
        return firstChar + maskedMiddle + lastChar;
      } else {
        return '*' * matchedWord.length;
      }
    });

    if (blockedKeywordList[1].type == "phone" &&
        blockedKeywordList[1].pattern == "true") {
      final phonePattern = RegExp(r'\b(?:\+?\d{1,4})?[\s-]?\d{10}\b');
      text = text.replaceAllMapped(phonePattern, (match) {
        String phoneMatch = match.group(0)!;
        if (phoneMatch.length > 4) {
          String firstTwo = phoneMatch.substring(0, 2);
          String lastTwo = phoneMatch.substring(phoneMatch.length - 2);
          String maskedMiddle = '*' * (phoneMatch.length - 4);
          return firstTwo + maskedMiddle + lastTwo;
        } else {
          return phoneMatch;
        }
      });
    }
    final emailPattern =
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    if (blockedKeywordList[2].type == "email" &&
        blockedKeywordList[2].pattern == "true") {
      text = text.replaceAllMapped(emailPattern, (match) {
        String emailMatch = match.group(0)!;
        int atIndex = emailMatch.indexOf('@');
        if (atIndex > 1) {
          return emailMatch[0] +
              '*' * (atIndex - 1) +
              emailMatch.substring(atIndex);
        } else {
          return '*' * atIndex + emailMatch.substring(atIndex);
        }
      });
    }
    return text;
  }

  setchatduration(int value) {
    chatDurationis = value;
    update();
  }

  updateChatScreen(bool value) {
    isInChatScreen = value;
    log('chat change isInChatScreen is $isInChatScreen');
    update();
  }

  Future<void> updateTypingStatus(
      String idUser, String partnerId, bool isTyping) async {
    log('Updating typing status to Firebase for partnerId: $partnerId');
    try {
      // Update typing status in the partner's document
      await userisTypingChatCollectionRef
          .doc(partnerId) // Partner User
          .set({'ispartnertyping': isTyping}, SetOptions(merge: true));

      log('Typing status updated successfully');
    } catch (e) {
      log('Exception in updateTypingStatus: ${e.toString()}');
    }
  }

  Stream<DocumentSnapshot>? getTypingStatusStream(String customerid) {
    log('firebase  channelID $customerid');
    try {
      return userisTypingChatCollectionRef.doc(customerid).snapshots();
    } catch (err) {
      debugPrint("Exception - chatcontroller.dart - firebase" + err.toString());
      return null;
    }
  }

  //Get a chat list
  getChatList(bool isLazyLoading, {int? isLoading = 1}) async {
    try {
      startIndex = 0;
      if (chatList.isNotEmpty) {
        startIndex = 0;
        fetchRecord = fetchRecord + 10;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            isLoading == 0 ? '' : global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper
                .getchatRequest(id, startIndex, fetchRecord)
                .then((result) {
              isLoading == 0 ? '' : global.hideLoader();

              update();
              log('result is $result');

              List<ChatRequest> chatRequestList = result["chatRequestList"];
              List<Keyword> keywordList = result["keywordList"];
              blockedKeywordList.clear();
              chatList.clear();

              blockedKeywordList.addAll(keywordList);
              chatList.addAll(chatRequestList);
              update();

              for (var keyword in blockedKeywordList) {
                if (keyword.pattern != null) {
                  myblockedList.add(keyword.pattern!);
                }
              }
              update();
            });
          }
        },
      );
      update();
    } catch (e) {
      debugPrint('Exception: $screen - getChatList():- ' + e.toString());
    }
  }

  storeChatId(int partnerId, int chatId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper
                .addChatId(global.currentUserId!, partnerId, chatId)
                .then(
              (result) {
                if (result.status == "200") {
                  firebaseChatId = result.recordList['recordList'];
                  update();
                  debugPrint('chat id genrated:- $firebaseChatId');
                } else {
                  global.showToast(message: tr("there are some problem"));
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      debugPrint('Exception: $screen - storeChatId(): ' + e.toString());
    }
  }

  storedefaultmessage(String msg, int? astrouserid, int? customerid) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper
                .storedefaultmessageApi(msg, customerid, astrouserid)
                .then(
              (result) {
                if (result.status == "200") {
                  update();
                } else {
                  global.showToast(message: tr("there are some problem"));
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      debugPrint('Exception: $screen - storeChatId(): ' + e.toString());
    }
  }

//Reject a chat by id
  Future<bool> rejectChatRequest(int chatId, {bool showLoader = true, bool showToast = true}) async {
    try {
      bool success = false;
      await global.checkBody().then((result) async {
        if (result) {
          if (showLoader) {
            global.showOnlyLoaderDialog();
          }
          await apiHelper.chatReject(chatId).then((result) async {
            if (showLoader) {
              global.hideLoader();
            }
            if (result.status == "200") {
              success = true;
              // Remove from accepted set if it was there
              acceptedChatIds.remove(chatId);
              if (showToast) {
                global.showToast(
                    message: tr("Reject a chat request sucessfully"));
              }
              chatList.clear();
              isAllDataLoaded = false;
              update();
              await getChatList(false);
            } else {
              if (showToast) {
                global.showToast(message: result.message.toString());
              }
            }
          });
        }
      });
      update();
      return success;
    } catch (e) {
      debugPrint("Exception: $screen - rejectChatRequest():" + e.toString());
      if (showLoader) {
        global.hideLoader();
      }
      return false;
    }
  }

  //accept chat request
  Future<bool> acceptChatRequest(
    dynamic subscriptionId,
    int chatId,
    int? astrouserID,
    String customerName,
    String customerProfile,
    int customerId,
    String fcmToken,
    String chatduration,
    String fromwhichMethod,

    ///for testing
    {
    bool appKilled = false,
    bool showLoader = true,
  }) async {
    try {
      final chattimercontroller = Get.find<ChattimerController>();
      debugPrint("fromwhichMethod:- $fromwhichMethod");
      final bodyResult = await global.checkBody();
      if (!bodyResult) {
        return false;
      }
      
      if (subscriptionId == '') {
        log('onesignal subscription id is null');
      }
      
      if (showLoader) {
        global.showOnlyLoaderDialog();
      }
      
      final result = await apiHelper.acceptChatRequest(chatId);
      
      if (showLoader) {
        global.hideLoader();
      }
      
      if (result.status == "200") {
        // Mark this chat as accepted to prevent duplicate notifications
        acceptedChatIds.add(chatId);
        log('Chat $chatId marked as accepted. Accepted chats: $acceptedChatIds');
        
        global.showToast(message: tr("This chat is accepted"));
        updateChatScreen(true);
        final trimmed = chatduration.toString().trim();
        int duration = int.tryParse(trimmed) ?? 0;
        if (duration <= 0) duration = 300;
        log('acceptChatRequest duration (seconds): $duration from "$trimmed"');
        log('sending id is $chatId');
        log('sending id firebase ${global.currentUserId}_$customerId');
        chattimercontroller.newIsStartTimer = false;
        customerEndedChatFCM.value = false;
        chatLeft = false;
        print(
            "chattimercontroller.newIsStartTimer:- ${chattimercontroller.newIsStartTimer}");
        global.chatStartedAt = null;
        global.getStorage.write('chatStartedAt', 0);
        global.getStorage.remove('chatEndedAt');
        // Reset timer before opening new chat to ensure clean state
        chattimercontroller.resetTimer();
        await global.getStorage.save();
        print("exit time:- ${global.getStorage.read('chatStartedAt')}");
        print("chatDuration:- $duration");
        
        // Navigate to chat screen
        Get.to(() => ChatScreen(
              subscriptionId: subscriptionId,
              flagId: 1,
              astrologerId: global.currentUserId,
              customerName: customerName,
              customerProfile: customerProfile,
              customerId: customerId,
              fcmToken: fcmToken,
              chatduration: duration,
              astrouserID: astrouserID,
              fireBasechatId: '${global.currentUserId}_$customerId',
            ))!
            .then((e) {
          if (appKilled) {
            Get.to(HomeScreen());
          }
        });
        
        chatList.clear();
        isAllDataLoaded = false;
        update();
        // Don't show loader when refreshing after navigation
        await getChatList(false, isLoading: 0);
        return true;
      } else {
        global.showToast(message: tr("User Cancelled the Request"));
        chatList.clear();
        update();
        return false;
      }
    } catch (e) {
      debugPrint("Exception: $screen - acceptChatRequest():" + e.toString());
      return false;
    }
  }

  bool isMe = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(
      String? firebaseChatId1, int? currentUserId) {
    log('getChatMessages chat id is $firebaseChatId1 and currentuserid is $currentUserId');
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
          .instance
          .collection('chats/$firebaseChatId1/userschat')
          .doc('$currentUserId')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      debugPrint(
          "Exception - apiHelper.dart - getChatMessages()" + err.toString());
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getpujaChatMessages(
      String firebaseChatId, int? currentUserId) {
    log('puja chat id is $firebaseChatId and currentuserid is $currentUserId');
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
          .instance
          .collection('pujachats/$firebaseChatId/userschat')
          .doc('${global.currentUserId}')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      debugPrint("Exception - apiHelper.dart - getpujaChatMessages()" +
          err.toString());
      return null;
    }
  }

  Future<void> sendPujaReplyMessage(
      String message, int partnerId, bool isEndMessage, String replymsg) async {
    // log('chatID $chatId partnerId $partnerId');
    log('message $message replymsg $replymsg');
    String filtertext = filterBlockedWordsForSending(replymsg);
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: false,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: filtertext,
        );
        update();
        await uploadPujaMessage(firebaseChatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      debugPrint('Exception in sendMessage ${e.toString()}');
    }
  }

  Future<void> sendReplyMessage(
      String message, int partnerId, bool isEndMessage, String replymsg) async {
    // log('chatID $chatId partnerId $partnerId');
    log('message $message replymsg $replymsg partner id $partnerId and firebaseid is $firebaseChatId');
    String filtertext = filterBlockedWordsForSending(replymsg);
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: false,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: filtertext,
        );
        update();
        await uploadMessage(firebaseChatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      debugPrint('Exception in sendMessage ${e.toString()}');
    }
  }

  Future<String?> pickFiles() async {
    // Define the allowed file extensions
    List<String> allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

    // Prompt the user to pick files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    try {
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        log('file is ${files[0].path}');
        return files[0].path;
      } else {
        log('selecting file error');
        return '';
      }
    } on Exception catch (e) {
      log('file error $e');
      return '';
    }
  }

//uploadPujaMessage
  Future<void> sendpujaMessage(String message, int customerID,
      bool isEndMessage, mfirebasechatid) async {
    log('customerID id is $customerID');
    try {
      if (message.trim() != '') {
        ChatMessageModel chaMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: false,
          userId1: '${global.currentUserId}',
          userId2: '$customerID',
          isEndMessage: isEndMessage,
          replymsg: '',
        );
        await uploadPujaMessage(mfirebasechatid, '$customerID', chaMessage);
      } else {}
    } catch (e) {
      debugPrint('Exception in sendMessage ${e.toString()}');
    }
  }

  Future<void> sendMessage(String message, int partnerId, bool isEndMessage,
      String fromWhere) async {
    log('custoer id is $partnerId');
    log('fromWhere:-  $fromWhere');
    // if (chatId != null) {
    try {
      if (message.trim() != '') {
        ChatMessageModel chaMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: false,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: '',
        );
        update();
        await uploadMessage(firebaseChatId, '$partnerId', chaMessage);
      } else {}
    } catch (e) {
      debugPrint('Exception in sendMessage ${e.toString()}');
    }
  }

  Future uploadMessage(String? firebaseuserid, String partnerId,
      ChatMessageModel anonymous) async {
    dynamic firebaseid = firebaseuserid == null || firebaseuserid == ''
        ? (global.firebaseChatId ?? firebaseChatId)
        : firebaseuserid;
    try {
      final String globalId = global.currentUserId.toString();
      final refMessages = userChatCollectionRef //SEND BY CURRENT USER
          .doc(firebaseid)
          .collection('userschat')
          .doc(globalId)
          .collection('messages');
      final refMessages1 = userChatCollectionRef //SEND BY PRTNER USER
          .doc(firebaseid)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages');
      final newMessage1 = anonymous;

      final newMessage2 = anonymous;
      newMessage2.messageId = refMessages1.id;

      var messageResult = await refMessages.add(newMessage1.toJson());
      newMessage1.messageId = messageResult.id;
      final pathCurrentUser = 'chats/$firebaseid/userschat/$globalId/messages/${newMessage1.messageId}';
      final pathPartner = 'chats/$firebaseid/userschat/$partnerId/messages/${newMessage1.messageId}';
      debugPrint('Message Firestore path (current user): $pathCurrentUser');
      debugPrint('Message Firestore path (partner): $pathPartner');
      await userChatCollectionRef //ADD USER AND PARTNER IN THIS
          .doc(firebaseid)
          .collection('userschat')
          .doc(globalId)
          .collection('messages')
          .doc(newMessage1.messageId)
          .update({"messageId": newMessage1.messageId});

      newMessage2.isRead = false;
      var message1Result = await refMessages1.add(newMessage2.toJson());
      newMessage2.messageId = message1Result.id;
      await userChatCollectionRef
          .doc(firebaseid)
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
      debugPrint('uploadMessage err $err');
    }
  }

  Future<Map<String, String>?> uploadPujaMessage(
    String? firebasechatid,
    String partnerId,
    ChatMessageModel anonymous,
  ) async {
    try {
      dynamic firebaseid = firebasechatid == null || firebasechatid == ''
          ? global.firebaseChatId
          : firebasechatid;
      // Firestore references
      final refMessages = userpujaChatCollectionRef
          .doc(firebaseid)
          .collection('userschat')
          .doc(global.currentUserId.toString())
          .collection('messages');

      final refMessages1 = userpujaChatCollectionRef
          .doc(firebaseid)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages');

      // Clone message for each user
      final newMessage1 = anonymous;
      final newMessage2 = anonymous;

      // Send message for current user
      final messageResult = await refMessages.add(newMessage1.toJson());
      newMessage1.messageId = messageResult.id;

      // Update messageId in sender's message
      await refMessages.doc(newMessage1.messageId).update({
        "messageId": newMessage1.messageId,
      });

      // Prepare receiver's message
      newMessage2.isRead = false;
      newMessage2.messageId = null; // Let Firestore auto-generate

      // Send message for partner
      final message1Result = await refMessages1.add(newMessage2.toJson());
      newMessage2.messageId = message1Result.id;

      // Update messageId in partner's message
      await refMessages1.doc(newMessage2.messageId).update({
        "messageId": newMessage2.messageId,
      });

      return {
        'user1': newMessage1.messageId!,
        'user2': newMessage2.messageId!,
      };
    } catch (err) {
      debugPrint('uploadMessage error: $err');
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMessageRTMWeb(
      String channelID) {
    log('firebase  channelID $channelID');
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data =
          userChatCollectionRefRTM
              .doc(channelID)
              .collection('messages')
              .where('isFromWeb', isEqualTo: true)
              .orderBy('createdAt')
              .snapshots();

      return data;
    } catch (err) {
      debugPrint("Exception - chatcontroller.dart - firebase" + err.toString());
      return null;
    }
  }

  Future uploadMessageRTM(
      String idUser, MessageModel anonymous, bool isdeleted) async {
    debugPrint('saving to $idUser firebase');
    log('messga sending ${anonymous.toJson()}');
    try {
      final refMessages = userChatCollectionRefRTM //SEND BY CURRENT USER
          .doc(idUser)
          .collection('messages');

      final newMessage1 = anonymous;

      final refMessages1 = userChatCollectionRefRTM //SEND BY CURRENT USER
          .doc(idUser)
          .collection('isDeleted');

      var alreadyisSnapshot = await refMessages1.get();
      if (alreadyisSnapshot.docs.isEmpty) {
        debugPrint('no field found added');
        await refMessages1.add({'isdeleted': isdeleted});
      } else {
        log('field isdelete already found not adding in firbase');
      }

      var messageResult = await refMessages.add(newMessage1.toJson());
      return {
        'user1': messageResult.id,
      };
    } catch (err) {
      log('uploadMessage err $err');
    }
  }

  Future<void> deleteBatches(String docid, bool isdeleted) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection =
        instance.collection('LiveChats').doc(docid).collection('messages');
    var snapshots = await collection.get();

    if (snapshots.docs.isNotEmpty) {
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      var collection =
          instance.collection('LiveChats').doc(docid).collection('isDeleted');
      var updatesnapshot = await collection.get();

      if (updatesnapshot.docs.isNotEmpty) {
        // Iterate through the documents and update the isdeleted field
        for (var doc in updatesnapshot.docs) {
          await collection.doc(doc.id).update({'isdeleted': isdeleted});
        }
      } else {
        log('No documents found in the isDeleted collection.');
      }
    } else {
      log('No documents to delete in the subcollection');
    }
  }

  /// Upload voice recording to Firebase Storage and send as chat message (WhatsApp-style).
  Future<void> sendVoiceMessageToFirebase(
    String? chatId,
    int partnerId,
    File audioFile,
  ) async {
    try {
      final firebaseId = chatId ?? firebaseChatId ?? global.firebaseChatId;
      if (firebaseId == null || firebaseId.isEmpty) {
        debugPrint('sendVoiceMessageToFirebase: no chat id');
        return;
      }
      final storagePath = '$firebaseId/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final storageReference = FirebaseStorage.instance.ref().child(storagePath);
      debugPrint('Voice audio Storage path: $storagePath');
      debugPrint('Voice audio full path: ${storageReference.fullPath}');
      final metadata = SettableMetadata(contentType: 'audio/mp4');
      final uploadTask = await storageReference.putFile(audioFile, metadata);
      if (uploadTask.state == TaskState.success) {
        debugPrint('Voice message uploaded');
      }
      final String downloadURL = await storageReference.getDownloadURL();
      debugPrint('Voice message URL: $downloadURL');
      final ChatMessageModel chatMessageModel = ChatMessageModel(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDelete: false,
        isRead: true,
        userId1: '${global.currentUserId}',
        userId2: '$partnerId',
        message: 'Voice message',
        attachementPath: downloadURL,
        isEndMessage: false,
      );
      await uploadMessage(firebaseId, '$partnerId', chatMessageModel);
    } catch (e) {
      log('Upload voice exception: $e');
      global.showToast(
        message: 'Failed to send voice message',
        bgcolors: Colors.red,
      );
    }
  }

//UPload Files to firebase
  Future<void> sendFiletoFirebase(
    // String message,
    String? chatId,
    int partnerId,
    File? file,
    BuildContext context,
  ) async {
    try {
      log('sending room_chatid $chatId customerid $partnerId');
      if (file != null) {
        // global.showOnlyLoaderDialog();
        uploadImage(file, partnerId.toString(), chatId);
      } else {
        debugPrint('no file to upload on firebase');
      }
    } catch (e) {
      debugPrint('Exception in sendMessage ${e.toString()}');
    }
  }

  Future<void> uploadImage(
      File imageFile, String partnerId, String? chatId) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(
        '$chatId/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');

    final uploadTask = await storageReference.putFile(imageFile);

    if (uploadTask.state == TaskState.success) {
      debugPrint('image uploaded');
    }
    String downloadURL = await storageReference.getDownloadURL();
    debugPrint('File Uploaded: $downloadURL');

    updateProfileImage(partnerId, chatId, downloadURL);
  }

  // Update Profile Image on Firebase
  Future<void> updateProfileImage(
      String partnerId, String? chatId, String imageUrl) async {
    ChatMessageModel chatMessageModel = ChatMessageModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDelete: false,
      isRead: false,
      userId1: '${global.currentUserId}',
      userId2: partnerId,
      attachementPath: imageUrl,
      isEndMessage: false,
    );
    // global.hideLoader();

    // Upload the message to Firestore
    await uploadMessage(chatId, partnerId, chatMessageModel);
  }
}
