import 'package:flutter/material.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../colors.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueNotifier<bool>? obscurePassword;
  final bool isPassword;
  final IconData? prefixIcon;
  final String? labelText;
  final String hintText;
  final FocusNode current;
  final FocusNode? next;
  final Widget? suffixWidget;
  final Color? prefixIconColor;
  final bool readOnly;
  final double? left;
  final double? right;
  final double? bottom;
  final TextStyle? hintStyle;
  final Color? borderColor;
  const CustomTextField({
    super.key,
    required this.focusNode,
    this.hintStyle,
    this.borderColor,
    this.readOnly = false,
    required this.controller,
    required this.keyboardType,
    this.obscurePassword,
    this.prefixIcon,
    this.isPassword = false,
    this.labelText,
    required this.hintText,
    required this.current,
    required this.next,
    this.prefixIconColor,  this.suffixWidget, this.left, this.right, this.bottom,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.only(

          bottom: bottom != null ? SizeConfig.scaleHeight(bottom!) :  SizeConfig.scaleHeight(15)),
      child: TextFormField(
        onFieldSubmitted: (value) {
          Utils.fieldFocusChange(context, current, next);
        },
        focusNode: focusNode,
        readOnly: readOnly,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscurePassword!.value : false,
        obscuringCharacter: '*',
        cursorColor: AppColors.blackColor,
        decoration: InputDecoration(
          focusColor: AppColors.blackColor,
          labelText:  labelText,
          hintText: hintText,
          prefixIcon: prefixIcon!= null ? Icon(
            prefixIcon,
            color: prefixIconColor,
          ): null,
          suffixIcon: suffixWidget ?? (isPassword
              ? InkWell(
              onTap: () {
                obscurePassword!.value = !obscurePassword!.value;
              },
              child: Icon(
                obscurePassword!.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility,
                color: AppColors.greyColor,
              ))
              : null),
          hintStyle: hintStyle ?? mediumTextStyle.copyWith(fontSize: 16, color: AppColors.hintTextColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:  BorderSide( color: borderColor ?? AppColors.blackColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide( color:borderColor ?? AppColors.blackColor),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        ),
      ),
    );
  }
}