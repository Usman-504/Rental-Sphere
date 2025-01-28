import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';

import '../../utils/routes/routes_name.dart';

class SplashServices {


  void checkAuthentication(BuildContext context) async{


        await Future.delayed(const Duration(seconds: 3));
       NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.signUp, replace: true).onError((error, stackTrace){
      if(kDebugMode){
        print(error.toString());
      }
    });
  }
}