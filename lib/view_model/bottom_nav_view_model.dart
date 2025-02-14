import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavViewModel with ChangeNotifier{
  int myIndex = 0;

  int unreadUserCount = 0;

  String getCurrentUserId() {
  return FirebaseAuth.instance.currentUser!.uid;
  }

  void listenForUnreadMessages() {
    String currentUserId = getCurrentUserId();

    FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: currentUserId)
        .snapshots()
        .listen((chatSnapshot) {
      Set<String> uniqueSenders = {};

      for (var chat in chatSnapshot.docs) {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chat.id)
            .collection('messages')
            .where('receiverId', isEqualTo: currentUserId)
            .where('isRead', isEqualTo: false)
            .snapshots()
            .listen((messageSnapshot) {
          for (var message in messageSnapshot.docs) {
            uniqueSenders.add(message['senderId']);
          }
          unreadUserCount = uniqueSenders.length;
          notifyListeners();
        });
      }
    });
  }






  void changeIndex(index){
    myIndex = index;
    listenForUnreadMessages();
    notifyListeners();
  }
}