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
    apiKey: 'AIzaSyCK5rLMeFyxdcMPDgm2mXGwjMs-lKBiZNs',
    appId: '1:1033310671849:web:35839cb51f103f0afaf178',
    messagingSenderId: '1033310671849',
    projectId: 'conference-management-sy-1c91e',
    authDomain: 'conference-management-sy-1c91e.firebaseapp.com',
    storageBucket: 'conference-management-sy-1c91e.firebasestorage.app',
    measurementId: 'G-7C8HJRLTDJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJiNyAJPaPgawdUEpAICjbWT6ZtAJTkvo',
    appId: '1:1033310671849:android:7973e4bd50f3edd0faf178',
    messagingSenderId: '1033310671849',
    projectId: 'conference-management-sy-1c91e',
    storageBucket: 'conference-management-sy-1c91e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBI1j_3ACfHbCjtgiTXMzDgYlq8HBLUY_g',
    appId: '1:1033310671849:ios:f9d8bfd4e2c312e0faf178',
    messagingSenderId: '1033310671849',
    projectId: 'conference-management-sy-1c91e',
    storageBucket: 'conference-management-sy-1c91e.firebasestorage.app',
    iosBundleId: 'com.example.conferenceManagementSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBI1j_3ACfHbCjtgiTXMzDgYlq8HBLUY_g',
    appId: '1:1033310671849:ios:f9d8bfd4e2c312e0faf178',
    messagingSenderId: '1033310671849',
    projectId: 'conference-management-sy-1c91e',
    storageBucket: 'conference-management-sy-1c91e.firebasestorage.app',
    iosBundleId: 'com.example.conferenceManagementSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCK5rLMeFyxdcMPDgm2mXGwjMs-lKBiZNs',
    appId: '1:1033310671849:web:49813519aa09ff80faf178',
    messagingSenderId: '1033310671849',
    projectId: 'conference-management-sy-1c91e',
    authDomain: 'conference-management-sy-1c91e.firebaseapp.com',
    storageBucket: 'conference-management-sy-1c91e.firebasestorage.app',
    measurementId: 'G-WJXB1713PC',
  );

}