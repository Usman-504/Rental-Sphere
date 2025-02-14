import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatViewModel with ChangeNotifier {
  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String formatTime(Timestamp? timestamp) {
    DateTime dateTime = timestamp != null ? timestamp.toDate() : DateTime.now();
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return DateFormat.jm().format(dateTime);
    } else if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  Stream<QuerySnapshot> getAllChats() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: getCurrentUserId())
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Future<void> markMessagesAsRead(String chatId,) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: getCurrentUserId())
          .where('isRead', isEqualTo: false)
          .get();

      for (var msg in snapshot.docs) {
        await msg.reference.update({'isRead': true});
      }
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }
  Future<void> updateUnreadMessages() async {
    notifyListeners();
  }

  Future<void> deleteChat(String chatId) async {
    var chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    var messages = await chatDocRef.collection('messages').get();

    for (var message in messages.docs) {
      var imagePath = message['image_path'];

      if (imagePath != null) {
        try {
          await FirebaseStorage.instance.ref(imagePath).delete();
        } catch (e) {
          print("Error deleting image: $e");
        }
      }

      await message.reference.delete();
    }

    await chatDocRef.delete();
  }
}
