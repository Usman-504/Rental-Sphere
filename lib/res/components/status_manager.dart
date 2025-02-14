import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusManager with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _updateStatus(String status) {
    if (_auth.currentUser != null) {
      _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status': status,
        'lastSeen': status == 'Online' ? null : FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateStatus("Online");
    } else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _updateStatus("Away");
    } else if (state == AppLifecycleState.detached) {
      _updateStatus("Offline");
    }
  }

  void startTracking() {
    WidgetsBinding.instance.addObserver(this);
    _updateStatus("Online");
  }

  void stopTracking() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
