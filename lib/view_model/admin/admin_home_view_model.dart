import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/components/navigation_helper.dart';
import '../../utils/routes/routes_name.dart';

class AdminHomeViewModel with ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot> getCarServices() {
    String searchQuery = searchController.text.trim().toLowerCase();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('car').where('userId', isEqualTo: userId).snapshots();
    }
    else {
      return FirebaseFirestore.instance
          .collection('car')
          .where('userId', isEqualTo: userId)
          .where('car_model', isGreaterThanOrEqualTo: searchQuery)
          .where('car_model', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
  }
  Stream<QuerySnapshot> getHomeServices() {
    String searchQuery = searchController.text.trim().toLowerCase();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('home').where('userId', isEqualTo: userId).snapshots();
    }
    else {
      return FirebaseFirestore.instance
          .collection('home')
          .where('userId', isEqualTo: userId)
          .where('home_type', isGreaterThanOrEqualTo: searchQuery)
          .where('home_type', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
  }
  Stream<QuerySnapshot> getCameraServices() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String searchQuery = searchController.text.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('camera').where('userId', isEqualTo: userId).snapshots();
    }
    else {
      return FirebaseFirestore.instance
          .collection('camera')
          .where('camera_brand', isGreaterThanOrEqualTo: searchQuery)
          .where('camera_brand', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .where('userId', isEqualTo: userId)
          .snapshots();
    }
  }

  void onChanged(value){
    searchController.text = value.trim();
    notifyListeners();
  }

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('role', '');
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login);
    });
  }
}