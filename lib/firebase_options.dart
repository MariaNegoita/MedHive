import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// This file contains the Firebase configuration for the supported platforms.
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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCv1S4q8u86IoWqxFZ8OickkKJDrX1KZ3k',
    appId: '1:457478913026:web:e6e373baf3aca3d570fb1b',
    messagingSenderId: '457478913026',
    projectId: 'medhive-12',
    authDomain: 'medhive-12.firebaseapp.com',
    storageBucket: 'medhive-12.firebasestorage.app',
  );

  // Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCv1S4q8u86IoWqxFZ8OickkKJDrX1KZ3k',
    appId: '1:457478913026:android:ad0ab5a503fddec60d09c9',
    messagingSenderId: '457478913026',
    projectId: 'medhive-12',
    storageBucket: 'medhive-12.firebasestorage.app',
  );

  // iOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCv1S4q8u86IoWqxFZ8OickkKJDrX1KZ3k',
    appId: '1:457478913026:ios:ad0ab5a503fddec60d09c9',
    messagingSenderId: '457478913026',
    projectId: 'medhive-12',
    storageBucket: 'medhive-12.firebasestorage.app',
    iosBundleId: 'com.example.medhiveProj',
  );

  // macOS configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCv1S4q8u86IoWqxFZ8OickkKJDrX1KZ3k',
    appId: '1:457478913026:macos:ad0ab5a503fddec60d09c9',
    messagingSenderId: '457478913026',
    projectId: 'medhive-12',
    storageBucket: 'medhive-12.firebasestorage.app',
    iosBundleId: 'com.example.medhiveProj',
  );

  // Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCv1S4q8u86IoWqxFZ8OickkKJDrX1KZ3k',
    appId: '1:457478913026:web:ad0ab5a503fddec60d09c9',
    messagingSenderId: '457478913026',
    projectId: 'medhive-12',
    authDomain: 'medhive-12.firebaseapp.com',
    storageBucket: 'medhive-12.firebasestorage.app',
  );

  // Linux configuration
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyCv1S4q8u86IoWqxFZ8OickkKJDrX1KZ3k',
    appId: '1:457478913026:web:ad0ab5a503fddec60d09c9',
    messagingSenderId: '457478913026',
    projectId: 'medhive-12',
    authDomain: 'medhive-12.firebaseapp.com',
    storageBucket: 'medhive-12.firebasestorage.app',
  );
}

