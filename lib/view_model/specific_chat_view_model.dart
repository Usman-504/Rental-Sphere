import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/utils.dart';

class SpecificChatViewModel with ChangeNotifier {
  TextEditingController chatController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  int maxLines = 1;
  String chatId = "";
  int? showDeleteButtonIndex;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextPainter _textPainter = TextPainter(textDirection: TextDirection.ltr);

  SpecificChatViewModel() {
    chatController.addListener(_updateMaxLines);
  }

  void _updateMaxLines() {
    _textPainter.text = TextSpan(text: chatController.text, style: TextStyle(fontSize: 16.0));
    _textPainter.layout(maxWidth: SizeConfig.screenWidth * 0.47);
    int lines = (_textPainter.height / _textPainter.preferredLineHeight).ceil();

    int newMaxLines = lines.clamp(1, 5);
    if (newMaxLines != maxLines) {
      maxLines = newMaxLines;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getSpecificChat(String chatId) {
   return FirebaseFirestore.instance
       .collection('chats')
       .doc(chatId)
       .collection('messages')
       .orderBy('timestamp', descending: false)
       .snapshots();
  }

  Future<void> sendMessage(String senderId, String receiverId, BuildContext context) async {
    if (chatController.text.trim().isEmpty) {
      Utils.flushBarMessage('Please Type Message First', context, true);
      return;
    }

    String messageText = chatController.text.trim();
    chatController.clear();

    chatId = senderId.hashCode <= receiverId.hashCode
        ? "${senderId}_$receiverId"
        : "${receiverId}_$senderId";

    await _firestore.collection("chats").doc(chatId).collection("messages").add({
      "text": messageText,
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": FieldValue.serverTimestamp(),
    });

    await _firestore.collection("chats").doc(chatId).set({
      "users": [senderId, receiverId],
      "lastMessage": messageText,
      "lastMessageTime": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    _scrollToBottom();
    notifyListeners();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void showDeleteButton(int index) {
    showDeleteButtonIndex = index;
    notifyListeners();
  }

  void hideDeleteButton() {
    showDeleteButtonIndex = null;
    notifyListeners();
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
      hideDeleteButton();
    } catch (e) {
      print("Error deleting message: $e");
    }
  }



  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }



  @override
  void dispose() {
    chatController.removeListener(_updateMaxLines);
    chatController.dispose();
    chatFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
