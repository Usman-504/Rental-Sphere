
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';

import '../../utils/styles.dart';

class ShowAlertDialog extends StatelessWidget {
  final String message;
  final VoidCallback onPress;
  const  ShowAlertDialog({
    required this.message,
    required this.onPress,
    super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteColor,

      title: Text('Warning', style: mediumTextStyle.copyWith(color: Colors.red),
      ),
      content: Text(message, style: smallTextStyle.copyWith(fontWeight: FontWeight.normal),),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('No', style: smallTextStyle,)),
        TextButton(onPressed: onPress, child: Text('Yes', style: smallTextStyle,)),
      ],
    );
  }
}

