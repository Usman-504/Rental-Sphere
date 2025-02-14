import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final TextPainter _textPainter = TextPainter(textDirection: TextDirection.ltr);

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> pickImage(String senderId, String receiverId, BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    setLoading(true);
    await uploadImage(imageFile, senderId, receiverId, context);
    setLoading(false);
  }

  Future<void> uploadImage(File imageFile, String senderId, String receiverId, BuildContext context) async {
    String fileName = "chats/${DateTime.now().millisecondsSinceEpoch}.jpg";
    try {
      TaskSnapshot snapshot = await _storage.ref(fileName).putFile(imageFile);
      String imageUrl = await snapshot.ref.getDownloadURL();
      String imagePath = snapshot.ref.fullPath;

      await sendMessage(senderId, receiverId, context, imageUrl: imageUrl, imagePath: imagePath);
    } catch (e) {
      Utils.flushBarMessage('Error uploading image', context, true);
    }
  }

  SpecificChatViewModel() {
    chatController.addListener(_updateMaxLines);
  }

  Stream<DocumentSnapshot> getUserStatus(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    Duration difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) return "just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes} minutes ago";
    if (difference.inHours < 24) return "${difference.inHours} hours ago";
    return "${difference.inDays} days ago";
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

  Future<void> sendMessage(String senderId, String receiverId, BuildContext context, {String? imageUrl, String? imagePath}) async {
    if (chatController.text.trim().isEmpty && imageUrl!.isEmpty) {
      Utils.flushBarMessage('Please Type a Message or Select an Image', context, true);
      return;
    }

    String messageText = chatController.text.trim();
    chatController.clear();

    chatId = senderId.hashCode <= receiverId.hashCode
        ? "${senderId}_$receiverId"
        : "${receiverId}_$senderId";

    await _firestore.collection("chats").doc(chatId).collection("messages").add({
      "text": imageUrl == null ? messageText : null,
      'image_url': imageUrl,
      'image_path': imagePath,
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": FieldValue.serverTimestamp(),
      'isRead': false,
    });

    await _firestore.collection("chats").doc(chatId).set({
      "users": [senderId, receiverId],
      "lastMessage": imageUrl != null ? "📷 Image" : messageText,
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




  Future<void> deleteMessagesAndImages(String chatId) async {
    try {
      var messagesSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (var messageDoc in messagesSnapshot.docs) {
        String? imagePath = messageDoc['image_path'];

        if (imagePath != null && imagePath.isNotEmpty) {
          await FirebaseStorage.instance.ref(imagePath).delete();
        }


        await messageDoc.reference.delete();
      }

      hideDeleteButton();
    } catch (e) {
      print("Error deleting messages and images: $e");
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
