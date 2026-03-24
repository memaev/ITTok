import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/app.dart';
import 'package:tiktok_for_it/firebase_options.dart';

// TODO: Add google-services.json (Android) to android/app/
// TODO: Add GoogleService-Info.plist (iOS) to ios/Runner/
// Then run: flutterfire configure  (installs FlutterFire CLI if needed: dart pub global activate flutterfire_cli)
// This will auto-generate lib/firebase_options.dart with your real credentials.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase is not yet configured. Add your Firebase config files and
    // run `flutterfire configure` to enable authentication and database features.
    debugPrint('[Firebase] Initialization skipped: $e');
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111111),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
