import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/services/notification_service.dart';
import 'data/local/hive_setup.dart';
import 'shared/providers/connectivity_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: "AIzaSyDHGvSnw1oBsUMtKYe5i5kKL_a5l8suYXQ",
      appId: "1:138401337934:android:7fd6169c31cf8c9ea6691f",
      messagingSenderId: "138401337934",
      projectId: "cams-e0aad",
    ),
  );

  // Initialize Hive (Local Database)
  await Hive.initFlutter();
  await HiveSetup.initialize();

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}