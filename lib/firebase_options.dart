// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBKZ7EG8jrL4u1oXhAmC1Ihd5aEnnVFr9s',
    appId: '1:263698108060:web:313b71b0343f78930be759',
    messagingSenderId: '263698108060',
    projectId: 'password-manager-46797',
    authDomain: 'password-manager-46797.firebaseapp.com',
    storageBucket: 'password-manager-46797.appspot.com',
    measurementId: 'G-MR2XBLD12T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsuGhOffOuuKFLbTRk3dxAwllZcDFvatA',
    appId: '1:263698108060:android:8f20625f5da419230be759',
    messagingSenderId: '263698108060',
    projectId: 'password-manager-46797',
    storageBucket: 'password-manager-46797.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbiHxt7sXRU9_oQxbDXrKJgH9mh8aILwk',
    appId: '1:263698108060:ios:c86baa84bedfe4480be759',
    messagingSenderId: '263698108060',
    projectId: 'password-manager-46797',
    storageBucket: 'password-manager-46797.appspot.com',
    iosBundleId: 'com.example.rentalSphere',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbiHxt7sXRU9_oQxbDXrKJgH9mh8aILwk',
    appId: '1:263698108060:ios:c86baa84bedfe4480be759',
    messagingSenderId: '263698108060',
    projectId: 'password-manager-46797',
    storageBucket: 'password-manager-46797.appspot.com',
    iosBundleId: 'com.example.rentalSphere',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBKZ7EG8jrL4u1oXhAmC1Ihd5aEnnVFr9s',
    appId: '1:263698108060:web:0c0b7b4ce3f7c87b0be759',
    messagingSenderId: '263698108060',
    projectId: 'password-manager-46797',
    authDomain: 'password-manager-46797.firebaseapp.com',
    storageBucket: 'password-manager-46797.appspot.com',
    measurementId: 'G-DTHWG5F7ZL',
  );

}