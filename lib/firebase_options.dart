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
    apiKey: 'AIzaSyCwh70x9IC1U2fGcVKwHBUBtEwknt_hNYg',
    appId: '1:847053113817:web:e9f3fe7525ccf7ed6531c8',
    messagingSenderId: '847053113817',
    projectId: 'task-manager-eeb37',
    authDomain: 'task-manager-eeb37.firebaseapp.com',
    storageBucket: 'task-manager-eeb37.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFvhv68YHb0jajqqWl0JttWzkOWF1uzsY',
    appId: '1:847053113817:android:85b9cf26e2dceb786531c8',
    messagingSenderId: '847053113817',
    projectId: 'task-manager-eeb37',
    storageBucket: 'task-manager-eeb37.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbFCeUKUF4xXom2mGU2J-nAyQNKOkQvkw',
    appId: '1:847053113817:ios:1d3819055530cf3e6531c8',
    messagingSenderId: '847053113817',
    projectId: 'task-manager-eeb37',
    storageBucket: 'task-manager-eeb37.appspot.com',
    iosClientId: '847053113817-hlp58bqfmgvugcfsumo09dn7u6afq493.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbFCeUKUF4xXom2mGU2J-nAyQNKOkQvkw',
    appId: '1:847053113817:ios:1d3819055530cf3e6531c8',
    messagingSenderId: '847053113817',
    projectId: 'task-manager-eeb37',
    storageBucket: 'task-manager-eeb37.appspot.com',
    iosClientId: '847053113817-hlp58bqfmgvugcfsumo09dn7u6afq493.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskManager',
  );
}
