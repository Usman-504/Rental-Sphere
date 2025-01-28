import 'package:flutter/material.dart';

import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../colors.dart';

class CustomButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback onPress;
  final Color? color;
  const CustomButton({
    super.key, required this.text, required this.onPress, this.loading = false, this.color
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return InkWell(
      onTap: onPress,
      child: Container(
        height: SizeConfig.scaleHeight(60),
       // width: SizeConfig.scaleWidth(370),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
           color: AppColors.blackColor
        ),
        child: Center(child: loading ? const  Center(child:  CircularProgressIndicator(
          color: AppColors.whiteColor,
        )) : Text(text, style: mediumTextStyle.copyWith(color: AppColors.whiteColor),)),
      ),
    );
  }
}