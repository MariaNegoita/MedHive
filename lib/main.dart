import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen_landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Starting app initialization...');
  
  // Web requires explicit options. Mobile (Android/iOS) uses native files.
  // Desktop may not have options yet; if init fails, continue so UI can render.
  try {
    if (kIsWeb) {
      print('Initializing Firebase for web...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully for web');
    } else {
      print('Initializing Firebase for mobile...');
      await Firebase.initializeApp();
      print('Firebase initialized successfully for mobile');
    }
  } catch (e) {
    // Log and continue; parts of the app that need Firebase will surface a message
    print('Firebase initialization failed: $e');
    debugPrint('Firebase initialization skipped/failed: $e');
  }
  
  print('Starting MedHive app...');
  runApp(MedHiveApp());
}