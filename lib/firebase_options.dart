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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBczJued_OTTa4vnePLROEIBnBQkLRldWQ',
    appId: '1:857332039763:web:47679a28e1cd0cd1a9c6a6',
    messagingSenderId: '857332039763',
    projectId: 'connectingfamilies-13936',
    authDomain: 'connectingfamilies-13936.firebaseapp.com',
    storageBucket: 'connectingfamilies-13936.appspot.com',
    measurementId: 'G-J2JF69ZGLJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbxvszFWhYZ2VdqKRaJpZ5ZRFU242eg4U',
    appId: '1:857332039763:android:559559c91ed381b9a9c6a6',
    messagingSenderId: '857332039763',
    projectId: 'connectingfamilies-13936',
    storageBucket: 'connectingfamilies-13936.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKFiOo-Uy0oXUcr1MRXfvujbWQRYM7R8o',
    appId: '1:857332039763:ios:7da6a71af1649b51a9c6a6',
    messagingSenderId: '857332039763',
    projectId: 'connectingfamilies-13936',
    storageBucket: 'connectingfamilies-13936.appspot.com',
    iosBundleId: 'com.example.connectingfamilies',
  );
}
