import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/components/navigation_helper.dart';
import '../../utils/routes/routes_name.dart';

class AdminHomeViewModel with ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('role', '');
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login);
    });
  }
}