import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:melodify/screens/splashscreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAGqiQJyubawbEW8wZqLWrwZWPqCZ8IEGI",
          appId: "1:904442534149:android:3cfe3190e2cc0537db7f6c",
          messagingSenderId: "904442534149",
          projectId: "melodify-dcb05"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const SplashScreen(),
      title: "Melodify",
    );
  }
}
