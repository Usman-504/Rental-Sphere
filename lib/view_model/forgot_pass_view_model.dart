import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../res/components/navigation_helper.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class ForgotPassViewModel with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();



  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String? validateFields() {
    if (emailController.text.isEmpty) {
      return 'Please Enter Your Email';
    } else
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(
        emailController.text)) {
      return 'Please Enter a Valid Email Address';
    }
    return null;
  }


  Future<void> forgotPassword(BuildContext context) async {
    String? validation = validateFields();
    if (validation != null) {
      Utils.flushBarMessage(validation, context, true);
      return;
    }

    try {
      setLoading(true);
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text.toLowerCase().trim())
          .get();

      if (result.docs.isEmpty) {
        setLoading(false);
        Utils.flushBarMessage('No User found For That Email.', context, true);
        return;
      }


      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim()).then((value) {
            setLoading(false);
            kIsWeb ? NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, replace: true) :
            Navigator.of(context).maybePop();
            clearFields();
        Utils.flushBarMessage(
            'Email Reset Link Sent Successfully', context, false);

      });
    }
    on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == 'invalid-email') {
        Utils.flushBarMessage('The Email Format Is Invalid.', context, true);
      }
      else if (e.code == 'network-request-failed') {
        Utils.flushBarMessage('Check Your Internet Connection.', context, true);
      }
      return;
    }
    notifyListeners();
  }


  void clearFields() {
    emailController.clear();
  }
}
