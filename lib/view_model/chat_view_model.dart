import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatViewModel with ChangeNotifier{

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime);
  }

  Stream<QuerySnapshot> getAllChats() {
   return FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: getCurrentUserId())
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
    }


  Future<void> deleteChat(String chatId) async {
    var chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    var messages = await chatDocRef.collection('messages').get();

    for (var message in messages.docs) {
      await message.reference.delete();
    }

    await chatDocRef.delete();
  }



}