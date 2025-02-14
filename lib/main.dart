import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:provider/provider.dart';
import 'package:rental_sphere/res/app_urls.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/status_manager.dart';
import 'package:rental_sphere/utils/routes/routes.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/view_model/admin/add_service_view_model.dart';
import 'package:rental_sphere/view_model/all_bookings_view_model.dart';
import 'package:rental_sphere/view_model/bottom_nav_view_model.dart';
import 'package:rental_sphere/view_model/profile_view_model.dart';
import 'package:rental_sphere/view_model/services_view_model.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = AppUrls.stripePublishableKey;
  await Stripe.instance.applySettings();
  StatusManager statusManager = StatusManager();
  statusManager.startTracking();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_)=>BottomNavViewModel()),
        ChangeNotifierProvider(create:(_)=>ServicesViewModel()),
        ChangeNotifierProvider(create:(_)=>AddServiceViewModel()),
        ChangeNotifierProvider(create:(_)=>ProfileViewModel()),
        ChangeNotifierProvider(create:(_)=>AllBookingViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blackColor),
          useMaterial3: true,
        ),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}

