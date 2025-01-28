import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../colors.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueNotifier<bool> obscurePassword;
  final bool isPassword;
  final IconData prefixIcon;
  final String labelText;
  final String hintText;
  final FocusNode current;
  final FocusNode? next;
  const CustomTextField({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.keyboardType,
    required this.obscurePassword,
    required this.prefixIcon,
    this.isPassword = false,
    required this.labelText,
    required this.hintText,
    required this.current,
    required this.next,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (value) {
        Utils.fieldFocusChange(context, current, next);
      },
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? obscurePassword.value : false,
      obscuringCharacter: '*',
      decoration: InputDecoration(
          labelText: isPassword ? 'Password' : labelText,
          hintText: isPassword ? 'Enter Password' : hintText,
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.blueColor,
          ),
          suffixIcon: isPassword
              ? InkWell(
                  onTap: () {
                    obscurePassword.value = !obscurePassword.value;
                  },
                  child: Icon(
                    obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                    color: AppColors.blueColor,
                  ))
              : null,
          hintStyle: const TextStyle(color: AppColors.greyColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: AppColors.blueColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: AppColors.blueColor),
          )),
    );
  }
}
