import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/utils/assets.dart';
import 'package:rental_sphere/utils/size_config.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {

  List imageList = [
    Image.asset(Assets.car1, fit: BoxFit.cover),
    Image.asset(Assets.home, fit: BoxFit.cover),
    Image.asset(Assets.camera, fit: BoxFit.cover),
  ];

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ListView(shrinkWrap: true,
        padding: EdgeInsets.zero,
        reverse: true,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(300),
            width: double.infinity,
            child: AnotherCarousel(
              dotColor: AppColors.blackColor,
              dotIncreasedColor: AppColors.whiteColor,
              dotIncreaseSize: 1.5,
              dotSpacing: 15,
              images:  imageList,
            ),
          ),
        ],),
    );

  }
}