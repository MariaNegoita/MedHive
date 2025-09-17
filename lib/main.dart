import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen_landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web requires explicit options. Mobile (Android/iOS) uses native files.
  // Desktop may not have options yet; if init fails, continue so UI can render.
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Log and continue; parts of the app that need Firebase will surface a message
    debugPrint('Firebase initialization skipped/failed: $e');
  }
  runApp(MedHiveApp());
}