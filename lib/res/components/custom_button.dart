import 'package:flutter/material.dart';

import '../colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  const CustomButton(
      {required this.title,
      super.key,
       this.loading = false,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    final heightX = MediaQuery.of(context).size.height;
    final widthX = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onPress,
        child: Container(
      height: heightX * 0.09,
      width: widthX * 0.95,
     
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: loading ? const CircularProgressIndicator(color: Colors.white,) : Text(
          title,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }
}
