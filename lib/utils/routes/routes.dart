import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/view/about_us_view.dart';
import 'package:rental_sphere/view/admin/add_service_view.dart';
import 'package:rental_sphere/view/admin/nav_bar_view.dart';
import 'package:rental_sphere/view/admin/update_service_view.dart';
import 'package:rental_sphere/view/booking_details_view.dart';
import 'package:rental_sphere/view/booking_view.dart';
import 'package:rental_sphere/view/bottom_nav_view.dart';
import 'package:rental_sphere/view/change_password_view.dart';
import 'package:rental_sphere/view/forgot_pass_view.dart';
import 'package:rental_sphere/view/home_view.dart';
import 'package:rental_sphere/view/login_view.dart';
import 'package:rental_sphere/view/service_detail_view.dart';
import 'package:rental_sphere/view/services_view.dart';
import 'package:rental_sphere/view/signup_view.dart';
import 'package:rental_sphere/view/sub_services_view.dart';
import 'package:rental_sphere/view/update_profile_view.dart';

import '../../view/splash_view.dart';

class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.splash:
        return MaterialPageRoute(builder: (_)=>const SplashView());
      case RoutesName.signUp:
        final isRole = settings.arguments as bool;
        return MaterialPageRoute(builder: (_)=>SignUpView(isRole: isRole));
      case RoutesName.login:
        return MaterialPageRoute(builder: (_)=>const LoginView());
      case RoutesName.forgotPass:
        return MaterialPageRoute(builder: (_)=>const ForgotPassView());
      case RoutesName.changePass:
        return MaterialPageRoute(builder: (_)=>const ChangePasswordView());
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
      case RoutesName.updateService:
        final args = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> UpdateServiceView(args: args));
      case RoutesName.updateProfile:
        final args = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> UpdateProfileView(args: args));
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
      case RoutesName.aboutUs:
        return MaterialPageRoute(builder: (_)=>const AboutUsView());
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