import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';

import '../utils/styles.dart';

class FullImageView extends StatelessWidget {
  final Map args;
  const FullImageView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back,
              size: 30, color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
        title: Text(
         'Full Image',
          style: secondaryTextStyle.copyWith(
              color: AppColors.whiteColor),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
              args['image'],
          fit: BoxFit.contain,
          ),
         
        ),
      ),
    );
  }
}
