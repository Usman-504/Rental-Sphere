import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/view/admin/add_service_view.dart';
import 'package:rental_sphere/view/admin/nav_bar_view.dart';
import 'package:rental_sphere/view/booking_details_view.dart';
import 'package:rental_sphere/view/booking_view.dart';
import 'package:rental_sphere/view/bottom_nav_view.dart';
import 'package:rental_sphere/view/forgot_pass_view.dart';
import 'package:rental_sphere/view/home_view.dart';
import 'package:rental_sphere/view/login_view.dart';
import 'package:rental_sphere/view/service_detail_view.dart';
import 'package:rental_sphere/view/services_view.dart';
import 'package:rental_sphere/view/signup_view.dart';
import 'package:rental_sphere/view/sub_services_view.dart';

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
      case RoutesName.forgotPass:
        return MaterialPageRoute(builder: (_)=>const ForgotPassView());
      case RoutesName.navBar:
        return MaterialPageRoute(builder: (_)=>const BottomNavBarView());
      case RoutesName.adminNavBar:
        return MaterialPageRoute(builder: (_)=>const NavBarView());
      case RoutesName.home:
        return MaterialPageRoute(builder: (_)=>const HomeView());
      case RoutesName.services:
        return MaterialPageRoute(builder: (_)=>const ServicesView());
      case RoutesName.addService:
        return MaterialPageRoute(builder: (_)=>const AddServiceView());
      case RoutesName.subServices:
        final args = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> SubServicesView(args: args,));
      case RoutesName.detailedServices:
        final args = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> ServiceDetailView(args: args,));
      case RoutesName.booking:
        final args = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> BookingView(args: args,));
      case RoutesName.bookingDetail:
        final args = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> BookingDetailView(args: args,));
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