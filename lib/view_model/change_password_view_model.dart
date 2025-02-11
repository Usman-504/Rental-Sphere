import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ChangePasswordViewModel with ChangeNotifier {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  final ValueNotifier<bool> obscureOldPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> obscureNewPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> obscureConfirmPassword = ValueNotifier<bool>(true);

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String? validateFields() {
    if (oldPasswordController.text.isEmpty) {
      return 'Please Enter Your Old Password';
    } else if (newPasswordController.text.isEmpty) {
      return  'Please Enter Your New Password';
    } else if (confirmPasswordController.text.isEmpty) {
      return 'Please Enter Your Confirm Password';
    } else if (oldPasswordController.text == newPasswordController.text) {
      return 'Old & New Password Cannot Be Same';
    } else if (newPasswordController.text != confirmPasswordController.text) {
      return 'New & Confirm Password Are Not Same';
    }
    return null;
  }

  Future<void> changePassword(BuildContext context) async {
    String? validation = validateFields();
    if (validation != null) {
      Utils.flushBarMessage(validation, context, true);
      return;
    }
    try {
      setLoading(true);
      User? user = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
          email: user!.email!, password: oldPasswordController.text.trim());
      await user.reauthenticateWithCredential(credential);
      if (oldPasswordController.text != newPasswordController.text &&
          newPasswordController.text == confirmPasswordController.text) {
        await user.updatePassword(newPasswordController.text.trim()).then((value){
          Navigator.pop(context);
          setLoading(false);
          Utils.flushBarMessage('Password Updated Successfully', context, false);
          clearFields();

        });


      }
    } on FirebaseException catch (e) {
      setLoading(false);
      if (e.code == 'invalid-credential') {
        Utils.flushBarMessage('Old Password Is Incorrect', context, true);
      } else if (e.code == 'too-many-requests') {
        Utils.flushBarMessage('Too Many Requests. Try Again Later', context, true);
      }

      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  void clearFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

}
