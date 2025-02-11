import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

class SplashServices {
  void checkUserRoleAndNavigate(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      String role = userDoc.get('role');

      if (role == 'admin') {
        NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.adminNavBar, replace: true);
        Utils.flushBarMessage('Account Login Successfully', context, false);
      }
      else if (role == 'client'){
        NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.navBar, replace:  true);
        Utils.flushBarMessage('Account Login Successfully', context, false);
      }
    } else {
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.signUp, replace: true, arguments: false);
    }
  }

  void checkUserRole(BuildContext context)async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? role = sp.getString('role');
    await Future.delayed(const Duration(seconds: 3));
    if (role == 'admin') {
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.adminNavBar, replace: true);
    }
    else if (role == 'client'){
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.navBar, replace: true);
    }
    else {
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.signUp, replace: true, arguments: false);
    }
  }

  // void checkAuthentication(BuildContext context) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   String? role = sp.getString('role') ?? '';
  //
  //   await Future.delayed(const Duration(seconds: 3));
  //   if (role == '') {
  //     NavigationHelper.navigateWithSlideTransition(
  //         context: context, routeName: RoutesName.signUp, replace: true);
  //   }
  //   else if (role != '') {
  //     NavigationHelper.navigateWithSlideTransition(
  //         context: context, routeName: RoutesName.navBar, replace: true)
  //         .onError((error, stackTrace) {
  //       if (kDebugMode) {
  //         print(error.toString());
  //       }
  //     });
  //   }
  // }
}