import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/components/navigation_helper.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

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

  void deleteService(String category, String docId, String path, List<dynamic> paths, BuildContext context) async {
    await FirebaseStorage.instance.ref(path).delete();
    for (String imagePath in paths) {
      await FirebaseStorage.instance.ref(imagePath).delete();
    }
    await FirebaseFirestore.instance.collection(category).doc(docId).delete();
    var value = category == 'car' ? 'Car' : category == 'home' ? 'Home' : 'Camera';
    Utils.flushBarMessage('$value Service Deleted Successfully', context, false);
  }

}