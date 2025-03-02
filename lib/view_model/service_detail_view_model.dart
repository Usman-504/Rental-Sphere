import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

class ServiceDetailViewModel  with ChangeNotifier{
  double _rating = 0.0;
  double get rating => _rating;
  final TextEditingController reviewController = TextEditingController();

  FocusNode reviewFocusNode = FocusNode();


  void updateRating(rating){
    _rating = rating;
    print(_rating);
    notifyListeners();
  }

  DateTime? availableStartDate;
  DateTime? availableEndDate;

  void setAvailableDates(DateTime startDate, DateTime endDate) {
    availableStartDate = startDate;
    availableEndDate = endDate;
    notifyListeners();
  }

  bool isDateAvailable(DateTime selectedDate) {
    if (availableStartDate == null || availableEndDate == null) {
      return true;
    }
    return (selectedDate.isAfter(availableStartDate!) || selectedDate.isAtSameMomentAs(availableStartDate!)) &&
        (selectedDate.isBefore(availableEndDate!) || selectedDate.isAtSameMomentAs(availableEndDate!));
  }

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void submitReview(String collection, String docId, BuildContext context) async {
    String? validation = validateFields();

    if (validation != null) {
      Utils.flushBarMessage(validation, context, true);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not logged in");
      return;
    }

    setLoading(true);

    final docSnapshot = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
    List<dynamic> reviews = docSnapshot.data()?['reviews'] ?? [];

    bool alreadyReviewed = reviews.any((review) => review['user_id'] == user.uid);

    if (alreadyReviewed) {
      setLoading(false);
      Utils.flushBarMessage("You have already submitted a review!", context, true);
      return;
    }

    SharedPreferences sp = await SharedPreferences.getInstance();
    final image = sp.getString('profile_url');
    final name = sp.getString('name');

    await FirebaseFirestore.instance.collection(collection).doc(docId).update({
      'reviews': FieldValue.arrayUnion([
        {
          'review': reviewController.text.trim(),
          'rating': rating,
          'user_id': user.uid,
          'name': name,
          'image': image,
          'date': DateFormat('MM/dd/yyyy').format(DateTime.now()),
        }
      ]),
    }).then((value) async {
      double averageRating = await getAverageRating(collection, docId);
      await FirebaseFirestore.instance.collection(collection).doc(docId).update({
        'averageRating': averageRating,
      });
    });

    setLoading(false);
    clearFields();
    Navigator.pop(context);
    Utils.flushBarMessage('Review Added Successfully', context, false);
  }


  Future<double> getAverageRating(String collection, String docId) async {
    final docSnapshot = await FirebaseFirestore.instance.collection(collection).doc(docId).get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      return 0.0;
    }

    List<dynamic> reviews = docSnapshot.data()!['reviews'] ?? [];


    double totalRating = 0;
    for (var review in reviews) {
      if (review['rating'] != null) {
        totalRating += (review['rating'] as num).toDouble();
      }
    }

    return totalRating / reviews.length;
  }


  String? validateFields(){
    if(_rating == 0){
      return 'Please Select Rating';
    }
    else if(reviewController.text.isEmpty){
      return 'Please Leave a Review';
    }
    return null;
  }

  void clearFields(){
    _rating = 0;
    reviewController.clear();
    notifyListeners();
  }


  String formatedDate(String dateString){
    DateFormat format = DateFormat('MM/dd/yyyy');
    DateTime date = format.parse(dateString);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);
    if (difference.inDays == 0) {
      return '0 days ago';
    }
    else if (difference.inDays == 1){
      return '1 day ago';
    }
    else {
      print(difference.inDays);
      return '${difference.inDays} days ago';
    }
  }

  String getFormattedName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts.first;
    return firstName.length > 8 ? firstName.substring(0, 8) : firstName;
  }


}