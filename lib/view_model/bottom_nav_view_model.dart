import 'package:flutter/material.dart';

class BottomNavViewModel with ChangeNotifier{
  int myIndex = 0;

  void changeIndex(index){
    myIndex = index;
    notifyListeners();
  }
}