import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHGvSnw1oBsUMtKYe5i5kKL_a5l8suYXQ',
    appId: '1:138401337934:android:7fd6169c31cf8c9ea6691f',
    messagingSenderId: '138401337934',
    projectId: 'cams-e0aad',
    storageBucket: 'cams-e0aad.firebasestorage.app',
  );
}