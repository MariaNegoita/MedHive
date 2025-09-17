import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// This file contains the Firebase configuration for the supported platforms.
/// Generated manually from `firebase apps:sdkconfig` for the Web app:
///   projectId: medhive-af87a
///   appId: 1:43608517868:web:ad0ab5a503fddec60d09c9
/// If you later add more platforms, you can re-run `flutterfire configure` to
/// regenerate this file with additional entries.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are configured only for Web. '
      'Add other platforms via `flutterfire configure`.',
    );
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
}

