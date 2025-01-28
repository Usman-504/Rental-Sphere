import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';

import '../utils/utils.dart';

class SignupViewModel with ChangeNotifier{

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);


  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String? validateFields() {
    if (nameController.text.isEmpty) {
      return 'Please Enter Your Email';
    }
   else  if (emailController.text.isEmpty) {
      return 'Please Enter Your Email';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(emailController.text)) {
      return 'Please Enter a Valid Email Address';
    } else if (passwordController.text.isEmpty) {
      return 'Please Enter Your Password';
    } else if (passwordController.text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void clearFields(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<void> signUp(BuildContext context) async {

    String? validation = validateFields();
    if (validation != null) {
      Utils.flushBarMessage(validation, context, true);
      return;
    }
    try {
      setLoading(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': nameController.text.trim(),
        'email': FirebaseAuth.instance.currentUser!.email,
        'role': 'client',
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'image_url' : '',
        'image_path' : '',
      });
      setLoading(false);
      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, replace: true);
      Utils.flushBarMessage('Account Created Successfully', context, false);
      clearFields();
      notifyListeners();
      return;
    } on FirebaseException catch (e) {
      setLoading(false);
      if (e.code == 'invalid-email') {
        Utils.flushBarMessage('The Email Format is Invalid.', context, true);
        return ;
      } else if (e.code == 'email-already-in-use') {
        Utils.flushBarMessage('This Email Is Already Registered.', context, true);
        return ;
      } else if (e.code == 'weak-password') {
        Utils.flushBarMessage('Password Must Be At Least 6 Characters', context, true);
        return ;
      }else if (e.code == 'network-request-failed') {
        Utils.flushBarMessage('Check Your Internet Connection.', context, true);
        return ;
      }
      else {
        Utils.flushBarMessage('An error occurred', context, true);
        return ;
      }
    }
  }
}