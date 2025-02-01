import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';

class AllBookingView extends StatelessWidget {
  const AllBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Center(
        child: Text('All Booking'),
      ),
    );
  }
}
