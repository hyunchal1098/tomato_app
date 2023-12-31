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
    apiKey: 'AIzaSyDnKiixTjx_ZX9Rn63Ci76bMnIdjw2OSPg',
    appId: '1:123268990821:web:8cf2076720715cf82d838c',
    messagingSenderId: '123268990821',
    projectId: 'tomatoapp-ce1a3',
    authDomain: 'tomatoapp-ce1a3.firebaseapp.com',
    storageBucket: 'tomatoapp-ce1a3.appspot.com',
    measurementId: 'G-2LWRMDVDCZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCX7fF_VSE6EY2hLUWBVkemYPWTZPHJRpM',
    appId: '1:123268990821:android:0e1067abaebf16592d838c',
    messagingSenderId: '123268990821',
    projectId: 'tomatoapp-ce1a3',
    storageBucket: 'tomatoapp-ce1a3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBX41eQHTazmw-MLmuoPMHsm2VM8BCkJO4',
    appId: '1:123268990821:ios:e3fe7f211e3358792d838c',
    messagingSenderId: '123268990821',
    projectId: 'tomatoapp-ce1a3',
    storageBucket: 'tomatoapp-ce1a3.appspot.com',
    iosBundleId: 'com.example.tomatoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBX41eQHTazmw-MLmuoPMHsm2VM8BCkJO4',
    appId: '1:123268990821:ios:6c42bc7313ec5cac2d838c',
    messagingSenderId: '123268990821',
    projectId: 'tomatoapp-ce1a3',
    storageBucket: 'tomatoapp-ce1a3.appspot.com',
    iosBundleId: 'com.example.tomatoApp.RunnerTests',
  );
}
