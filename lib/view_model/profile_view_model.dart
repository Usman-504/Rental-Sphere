import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/components/alert_dialog.dart';

class ProfileViewModel with ChangeNotifier{
  late String _image = '';
  String get image => _image;

  late String _role = '';
  String get role => _role;

  late String _name = '';
  String get name => _name;

  late String _email = '';
  String get email => _email;


  void fetchUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    _image = sp.getString('profile_url') ?? '';
    _email = sp.getString('email') ?? '';
    _name = sp.getString('name') ?? '';
    _role = sp.getString('role') ?? '';
    notifyListeners();
  }

  final List<Map<String, dynamic>> info = [
    {
      'title': 'Change Password',
      'description': 'Update your password',
      'icon': Icons.password,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'About Us',
      'description': 'Learn about u',
      'icon': Icons.info_outlined,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Privacy',
      'description': 'Your data protection',
      'icon': Icons.privacy_tip,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Become a Provider',
      'description': '',
      'icon': Icons.person,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Delete Account',
      'description': 'Remove your account',
      'icon': Icons.auto_delete_outlined,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Logout',
      'description': 'Sign out safely',
      'icon': Icons.logout,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
  ];
  final List<Map<String, dynamic>> adminInfo = [
    {
      'title': 'Change Password',
      'description': 'Update your password',
      'icon': Icons.password,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'About Us',
      'description': 'Learn about u',
      'icon': Icons.info_outlined,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Privacy',
      'description': 'Your data protection',
      'icon': Icons.privacy_tip,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    // {
    //   'title': 'Create Account',
    //   'description': 'Your data protection',
    //   'icon': Icons.account_circle,
    //   'staticIcon': Icons.arrow_forward_ios_rounded,
    // },
    {
      'title': 'Become a Seeker',
      'description': '',
      'icon': Icons.person,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Delete Account',
      'description': 'Remove your account',
      'icon': Icons.auto_delete_outlined,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
    {
      'title': 'Logout',
      'description': 'Sign out safely',
      'icon': Icons.logout,
      'staticIcon': Icons.arrow_forward_ios_rounded,
    },
  ];

  List<String> listTileScreens = [
    RoutesName.changePass,
    RoutesName.aboutUs,

  ];

  List<String> adminListTileScreens = [
   RoutesName.changePass,
   RoutesName.aboutUs,
  ];

  Future<void> _launchURL() async {
    const url = 'https://usman-504.github.io/Rental-Sphere-Policy/privacy-policy.html';
    final Uri url0 = Uri.parse(url);
    if (await canLaunchUrl(url0)) {
      await launchUrl(url0);
    } else {
      throw 'Could not launch $url';
    }
  }

  dynamic launchBrowser() async {
    try
    {
      Uri link = Uri(
          scheme: 'https',
          path: "usman-504.github.io/Rental-Sphere-Policy/privacy-policy.html"
      );
      await launchUrl(link);
    }
    catch(e) {
      debugPrint(e.toString());
    }
  }



  void navigateToScreen(BuildContext context, int index) async{
    if(_role == 'client'){
      if(index ==2){
       launchBrowser();
      }
      else  if(index ==3) {
        User? user = FirebaseAuth.instance.currentUser;
        SharedPreferences sp = await SharedPreferences.getInstance();
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'role': 'admin',
          }).then((value){
            sp.setString('role', 'admin');
            NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.splash, clearStack: true);

          });
        }
        // NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.signUp, arguments:
        //   true);

      }
     else  if(index ==4){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return  ShowAlertDialog(message: 'Are you sure you want to delete your account?', onPress: () {  deleteUser(context,); },);
            });
      }
      else if(index == 5)
      {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return  ShowAlertDialog(message: 'Are you sure you want to logout your account?', onPress: () async{
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                    'status': 'Offline',
                    'lastSeen': FieldValue.serverTimestamp(),
                  });
                }
               await FirebaseAuth.instance.signOut().then((_){
           NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, clearStack: true
                  );
                });
              },);
            });
      }
      else{
        NavigationHelper.navigateWithSlideTransition(context: context, routeName: listTileScreens[index]);
      }
    }
    if(role == 'admin'){
      if(index ==2){
        _launchURL();
      }
     else  if(index ==3) {
        User? user = FirebaseAuth.instance.currentUser;
        SharedPreferences sp = await SharedPreferences.getInstance();
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'role': 'client',
          }).then((value){
            sp.setString('role', 'client');
            NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.splash, clearStack: true);

          });
        }
       // NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.signUp, arguments:
       //   true);

      }
      else if(index ==4){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return  ShowAlertDialog(message: 'Are you sure you want to delete your account?', onPress: () {  deleteUser(context); },);
            });
      }
      else if(index == 5)
      {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return  ShowAlertDialog(message: 'Are you sure you want to logout your account?', onPress: () async{
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                    'status': 'Offline',
                    'lastSeen': FieldValue.serverTimestamp(),
                  });
                }
              await  FirebaseAuth.instance.signOut().then((_){
NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, clearStack: true
                    // (Route<dynamic> route) => false,
                  );
                });
              },);
            });

      }
      else{
        NavigationHelper.navigateWithSlideTransition(context: context, routeName: adminListTileScreens[index]);
      }
    }

  }

  Future<void> deleteUser (BuildContext context) async{
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    String imagePath = userDoc.get('image_path');
    if(imagePath.isNotEmpty && imagePath != 'profile/userImg.png'){
      await FirebaseStorage.instance.ref(imagePath).delete();
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    await user.delete();
    NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.signUp, clearStack: true, arguments: false);
    Utils.flushBarMessage('Account Deleted Successfully', context, false);
  }


}