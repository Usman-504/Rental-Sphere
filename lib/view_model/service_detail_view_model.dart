import 'package:flutter/material.dart';

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
}