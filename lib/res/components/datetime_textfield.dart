import 'package:flutter/material.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../colors.dart';

class DateTimeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final VoidCallback onPress;
 final bool date;
 final bool filled;
  const DateTimeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onPress,
    required this.date, this.hintStyle, this.textStyle, this.filled = false,
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding:   EdgeInsets.only(
        bottom:  SizeConfig.scaleHeight(15)),
      child: Center(
        child: TextFormField(
          readOnly: true,
          keyboardType:TextInputType.datetime,
          controller: controller,
          decoration: InputDecoration(
            filled:  filled ,
              fillColor: filled == true ? AppColors.whiteColor : Colors.transparent,
              hintText: hintText,
              suffixIcon:  InkWell(
                  onTap: onPress,
                  child:
                  Icon(date ? Icons.calendar_today_outlined : Icons.access_time_rounded, size:24, color: AppColors.blackColor,)
              ),
              hintStyle:  hintStyle ?? mediumTextStyle.copyWith(fontSize: 14, color: AppColors.hintTextColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:  BorderSide( color: AppColors.blackColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide( color: AppColors.blackColor),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              isDense: true
          ),
          style: textStyle ?? mediumTextStyle.copyWith(
              fontSize: 14,
              color: AppColors.blackColor),
        ),
      ),
    );
  }
}