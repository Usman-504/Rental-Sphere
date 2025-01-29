import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel with ChangeNotifier{

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('role', '');
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login);
    });
  }

}