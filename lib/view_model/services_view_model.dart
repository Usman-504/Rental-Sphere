import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesViewModel with ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  String? _image = '';
  String? get image => _image;

  void fetchUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    _image = sp.getString('profile_url');
  }

}