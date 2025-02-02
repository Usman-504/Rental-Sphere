import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';

import '../utils/assets.dart';
import '../utils/utils.dart';

class SignupViewModel with ChangeNotifier{

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  String _imageUrl = '';
  String get imageUrl => _imageUrl;

  String _imagePath = '';
  String get imagePath => _imagePath;

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
      await uploadAssetImage(Assets.profile);
      if(_imageUrl.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'name': nameController.text.trim(),
          'email': FirebaseAuth.instance.currentUser!.email,
          'role': 'client',
          'user_id': FirebaseAuth.instance.currentUser!.uid,
          'image_url': _imageUrl,
          'image_path': _imagePath,
        });
        setLoading(false);
        NavigationHelper.navigateWithSlideTransition(
            context: context, routeName: RoutesName.login, replace: true);
        Utils.flushBarMessage('Account Created Successfully', context, false);
        clearFields();
        notifyListeners();
        return;
      } } on FirebaseException catch (e) {
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



  Future<void> uploadAssetImage(String assetPath) async {
    try {
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageData = byteData.buffer.asUint8List();

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('profile');
      Reference imageToUpload = referenceDirImages.child(uniqueFileName);

      setLoading(true);
      await imageToUpload.putData(imageData);


      _imageUrl = await imageToUpload.getDownloadURL();
      _imagePath = imageToUpload.fullPath;

      print('Image uploaded successfully, URL: $_imageUrl');
      notifyListeners();
    } catch (e) {
      setLoading(false);
      print('Failed to upload asset image: $e');
    }
  }

}