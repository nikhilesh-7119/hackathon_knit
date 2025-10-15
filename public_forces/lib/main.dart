import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_forces/config/themes.dart';
import 'package:public_forces/firebase_options.dart';
import 'package:public_forces/pages/feedback_page.dart';
import 'package:public_forces/pages/web_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Public Forces',
      theme: darkTheme,
      home: WebHomePage(),
    );
  }
}
