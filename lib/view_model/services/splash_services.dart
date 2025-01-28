import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/routes_name.dart';

class SplashServices {


  void checkAuthentication(BuildContext context) async{


        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.home).onError((error, stackTrace){
      if(kDebugMode){
        print(error.toString());
      }
    });
  }
}