import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Center(
        child: Text('Booking'),
      ),
    );
  }
}
