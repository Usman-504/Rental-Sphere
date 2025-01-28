import 'package:flutter/material.dart';

import '../res/colors.dart';

var primaryTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  color: AppColors.blackColor,
  fontSize:  22,
  fontWeight: FontWeight.w600,
  letterSpacing: 22 * 0.06,
);

var secondaryTextStyle =  const TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.blackColor,
    fontSize:  20,
    letterSpacing: 20 * 0.06,
    fontWeight: FontWeight.w600);


var mediumTextStyle =   const TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.blackColor,
    fontSize:  19,
    letterSpacing: 19 * 0.06,
    fontWeight: FontWeight.w500);

var smallTextStyle =  const TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.blackColor,
    fontSize:  14,
    letterSpacing: 14 * 0.06,
    fontWeight: FontWeight.w400);

var miniTextStyle =   const TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.blackColor,
    fontSize:  8,
    letterSpacing: 8 * 0.06,
    fontWeight: FontWeight.w300);



var homeBoxShadow = [const BoxShadow(
    color: AppColors.blackColor,
    blurRadius:4,
    spreadRadius: 0,
    blurStyle: BlurStyle.outer,
    offset: Offset(0, 1)
)];

var normalBoxShadow = [const BoxShadow(
    color: AppColors.blackColor,
    blurRadius:1,
    spreadRadius: 0,
    blurStyle: BlurStyle.outer,
    offset: Offset(0, 1)
)];


var cellBoxShadow = [const BoxShadow(
  color: AppColors.primaryColor,
  blurRadius:2,
  spreadRadius: 1,
  offset: Offset(0, -3),

  blurStyle: BlurStyle.solid,
)];