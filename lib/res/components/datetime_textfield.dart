import 'package:flutter/material.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../colors.dart';

class DateTimeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onPress;
 final bool date;
  const DateTimeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onPress,
    required this.date,
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
              hintText: hintText,
              suffixIcon:  InkWell(
                  onTap: onPress,
                  child:
                  Icon(date ? Icons.calendar_today_outlined : Icons.access_time_rounded, size:24, color: AppColors.blackColor,)
              ),
              hintStyle: mediumTextStyle.copyWith(fontSize: 14, color: AppColors.hintTextColor),
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
          style: mediumTextStyle.copyWith(
              fontSize: 14,
              color: AppColors.blackColor),
        ),
      ),
    );
  }
}