import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

class UpdateProfileViewModel with ChangeNotifier {



  String _imageUrl = '';
  String get imageUrl => _imageUrl;



  String _imagePath = '';
  String get imagePath => _imagePath;

  XFile? _file;
  XFile? get file => _file;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


  void updateUserDetails(String name, String email,  String docId,
      String password, BuildContext context) async {

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (password.isEmpty) {
        Utils.flushBarMessage('Password Cannot Be Empty', context, true);
        return;
      }
setLoading(true);
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .get();
      String userName = userDoc.get('name');
      String userRole = userDoc.get('role');

      final userDocSnapshot = await FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userDocSnapshot.docs.isNotEmpty && userDocSnapshot.docs.first.id != user.uid) {
        Utils.flushBarMessage('Email is already in use. Please choose another.', context, true);
       setLoading(false);
        return;
      }

      if (email != user.email) {
        setLoading(true);
        await user.verifyBeforeUpdateEmail(email);
        await user.sendEmailVerification();

        await FirebaseAuth.instance.signOut();
        setLoading(false);
        NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, clearStack: true);
        Utils.flushBarMessage('Verify Your New Email & Login Again', context, false);
        return;
      }

      if (name != userName ) {
        setLoading(true);
        await FirebaseFirestore.instance.collection('users').doc(docId).update({
          'name': name,
          'email': email,
        });
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('name', name);
        sp.setString('email', email);
        String? role = sp.getString('role');
        if (userRole == 'admin') {
          await updateAdminOwnerName(user.uid, name);
        } else if (userRole == 'client') {
          await updateClientReviewName(user.uid, name);
        }

        setLoading(false);
        if(role == 'client'){
          NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.navBar, replace: true);
          Utils.flushBarMessage('Profile Name Updated.', context, false);

          return;
        }
        else {
          NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.adminNavBar, replace: true);
          Utils.flushBarMessage('Profile Name Updated.', context, false);
          return;
        }



      }

      await updateProfilePhoto(docId, context);



    } on FirebaseException catch (e) {
      if (e.code == 'invalid-credential') {
        Utils.flushBarMessage('Your Password Is Incorrect', context, true);
      } else if (e.code == 'too-many-requests') {
        Utils.flushBarMessage('Too Many Requests. Try Again Later', context, true);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProfilePhoto(String docId, BuildContext context) async {



    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get();

    String oldImagePath = document.get('image_path');
    String userRole = document.get('role');


    if (_file != null) {
      if(oldImagePath.isNotEmpty && oldImagePath != 'profile/userImg.png'){
        await FirebaseStorage.instance.ref(oldImagePath).delete();
      }
      print('Uploading image...');
      await uploadImage();

      if (_imageUrl.isNotEmpty) {
        setLoading(true);
        FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update({
          'image_url': _imageUrl,
          'image_path': _imagePath,
        });
        if (userRole == 'admin') {
          User? user = FirebaseAuth.instance.currentUser;
          await updateAdminOwnerImage(user!.uid);
        }
        else if (userRole == 'client') {
          User? user = FirebaseAuth.instance.currentUser;
          await updateClientReviewImage(user!.uid);
        }
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('profile_url', _imageUrl);
        String? role = sp.getString('role');
        setLoading(false);
        if(role == 'client'){
          NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.navBar, replace: true);
          Utils.flushBarMessage('Profile Photo Updated', context, false);
          return;
        }
        else {
          NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.adminNavBar, replace: true);
          Utils.flushBarMessage('Profile Photo Updated', context, false);
          return;
        }


      }
    }
  }
  Future<void> updateAdminOwnerName(String ownerId, String newName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<String> collections = ['car', 'home', 'camera'];

    for (String collection in collections) {
      QuerySnapshot querySnapshot = await firestore
          .collection(collection)
          .where('userId', isEqualTo: ownerId)
          .get();

      for (var doc in querySnapshot.docs) {
        await firestore.collection(collection).doc(doc.id).update({
          'ownerName': newName,
        });
      }
    }
  }

  Future<void> updateClientReviewName(String userId, String newName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<String> collections = ['car', 'home', 'camera'];

    for (String collection in collections) {
      QuerySnapshot querySnapshot = await firestore.collection(collection).get();

      for (var doc in querySnapshot.docs) {
        List<dynamic> reviews = doc.get('reviews');

        bool hasReview = reviews.any((review) => review['user_id'] == userId);

        if (hasReview) {
          List<dynamic> updatedReviews = reviews.map((review) {
            if (review['user_id'] == userId) {
              return {
                ...review,
                'name': newName,
              };
            }
            return review;
          }).toList();

          await firestore.collection(collection).doc(doc.id).update({
            'reviews': updatedReviews,
          });
        }
      }
    }
  }



  Future<void> updateAdminOwnerImage(String ownerId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> collections = ['car', 'home', 'camera'];

    for (String collection in collections) {
      QuerySnapshot querySnapshot = await firestore
          .collection(collection)
          .where('userId', isEqualTo: ownerId)
          .get();

      for (var doc in querySnapshot.docs) {
        await firestore.collection(collection).doc(doc.id).update({
          'ownerImage': _imageUrl,
        });
      }
    }
  }

  Future<void> updateClientReviewImage(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<String> collections = ['car', 'home', 'camera'];

    for (String collection in collections) {
      QuerySnapshot querySnapshot = await firestore.collection(collection).get();

      for (var doc in querySnapshot.docs) {
        List<dynamic> reviews = doc.get('reviews');

        bool hasReview = reviews.any((review) => review['user_id'] == userId);

        if (hasReview) {
          List<dynamic> updatedReviews = reviews.map((review) {
            if (review['user_id'] == userId) {
              return {
                ...review,
                'image': _imageUrl,
              };
            }
            return review;
          }).toList();

          await firestore.collection(collection).doc(doc.id).update({
            'reviews': updatedReviews,
          });
        }
      }
    }
  }



  void pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    _file = await imagePicker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  Future<void> uploadImage() async {
    if (_file != null) {
      setLoading(true);
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('profile');
      Reference imageToUpload = referenceDirImages.child(uniqueFileName);

      try {
        await imageToUpload.putFile(File(file!.path));
        _imageUrl = await imageToUpload.getDownloadURL();
        print('Image updated successfully, URL: $_imageUrl');
        print(imageToUpload.fullPath);
        _imagePath = imageToUpload.fullPath;
        notifyListeners();
      } catch (e) {
        setLoading(false);
        print('Failed to upload image: $e');
      }
    }
  }

  void clearFields() {
    _file = null;
    _imageUrl = '';
    notifyListeners();
  }

}
