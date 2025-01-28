import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar_route.dart';

import '../res/colors.dart';
class Utils {

  static doubleRating(List<int> rating){
    var avgRating = 0;
    for(int i = 0; i< rating.length; i++){
      avgRating = avgRating + rating[i];
    }
    return double.parse((avgRating/rating.length).toStringAsFixed(1));
  }

  static toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context){
    showFlushbar(context: context,
        flushbar: Flushbar(
         positionOffset: 20,
          icon: const Icon(Icons.error, color: Colors.white, size: 25,),
          backgroundColor: Colors.blue,
          messageColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeInOut,
          duration: const Duration(seconds: 3),
          message: message,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
        )..show(context)
    );
  }

  static snackBar(String message, BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Center(child: Text(message, style: const  TextStyle(color: AppColors.whiteColor),), ),
        backgroundColor: AppColors.blueColor,
        ));
  }

  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode? next){
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
}