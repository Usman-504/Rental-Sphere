import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/view/home_view.dart';
import 'package:rental_sphere/view/login_view.dart';
import 'package:rental_sphere/view/signup_view.dart';

import '../../view/splash_view.dart';

class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.splash:
        return MaterialPageRoute(builder: (_)=>const SplashView());
      case RoutesName.signUp:
        return MaterialPageRoute(builder: (_)=>const SignUpView());
      case RoutesName.login:
        return MaterialPageRoute(builder: (_)=>const LoginView());
      case RoutesName.home:
        return MaterialPageRoute(builder: (_)=>const HomeView());
      default:
        return MaterialPageRoute(builder: (_){
          return const  Scaffold(
            body: Center(
              child: Text('No Route Defined'),
            ),
          );
        });
    }
  }
}