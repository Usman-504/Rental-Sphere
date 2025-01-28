import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/routes/routes_name.dart';

class SplashServices {


  void checkAuthentication(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? role = sp.getString('role') ?? '';

    await Future.delayed(const Duration(seconds: 3));
    if (role == '') {
      NavigationHelper.navigateWithSlideTransition(
          context: context, routeName: RoutesName.signUp, replace: true);
    }
    else if (role != '') {
      NavigationHelper.navigateWithSlideTransition(
          context: context, routeName: RoutesName.home, replace: true)
          .onError((error, stackTrace) {
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }
  }
}