// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAJ8sU5CP4qK4gusPlHSLqRMifto4S7Sag',
    appId: '1:301564901227:web:7c62021c9b28f14cccfe2e',
    messagingSenderId: '301564901227',
    projectId: 'fuwa-nail-cafe',
    authDomain: 'fuwa-nail-cafe.firebaseapp.com',
    storageBucket: 'fuwa-nail-cafe.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnaNZhd2YZZKX8ZSORsz2OFnw78nk75lA',
    appId: '1:301564901227:android:1822af8983b44bbcccfe2e',
    messagingSenderId: '301564901227',
    projectId: 'fuwa-nail-cafe',
    storageBucket: 'fuwa-nail-cafe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwfpwP4duaNyds_X7fwbilTysxrC3zDRY',
    appId: '1:301564901227:ios:56e7b9cdf520794accfe2e',
    messagingSenderId: '301564901227',
    projectId: 'fuwa-nail-cafe',
    storageBucket: 'fuwa-nail-cafe.appspot.com',
    iosBundleId: 'com.example.fuwaCafe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwfpwP4duaNyds_X7fwbilTysxrC3zDRY',
    appId: '1:301564901227:ios:43892df4ae401285ccfe2e',
    messagingSenderId: '301564901227',
    projectId: 'fuwa-nail-cafe',
    storageBucket: 'fuwa-nail-cafe.appspot.com',
    iosBundleId: 'com.example.fuwaCafe.RunnerTests',
  );
}