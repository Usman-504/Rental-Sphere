import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllBookingViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

String? _role ;
String? get role => _role;

void fetchRole()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  _role = sp.getString('role') ;
  notifyListeners();
}

  Stream<QuerySnapshot> getOwnerCarBookings() {
    User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('car_bookings')
          .where('owner_id', isEqualTo: user!.uid)
          .snapshots();
    }
  Stream<QuerySnapshot> getCarBookings() {
    User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('car_bookings')
          .where('user_id', isEqualTo: user!.uid)
          .snapshots();
    }

  Stream<QuerySnapshot> getOwnerHomeBookings() {
    User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('home_bookings')
          .where('owner_id', isEqualTo: user!.uid)
          .snapshots();
    }
  Stream<QuerySnapshot> getHomeBookings() {
    User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('home_bookings')
          .where('user_id', isEqualTo: user!.uid)
          .snapshots();
    }

  Stream<QuerySnapshot> getOwnerCameraBookings() {
    User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('camera_bookings')
          .where('owner_id', isEqualTo: user!.uid)
          .snapshots();
    }
  Stream<QuerySnapshot> getCameraBookings() {
    User? user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('camera_bookings')
          .where('user_id', isEqualTo: user!.uid)
          .snapshots();
    }


}
