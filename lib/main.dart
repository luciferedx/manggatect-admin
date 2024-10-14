import 'package:adminmangga/firebase_options.dart';
import 'package:adminmangga/pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/alltreelocationpage.dart';
import 'pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/homepage': (context) => const Homepage(),
        '/tree-map': (context) => AllTreeLocationPage(),
        '/': (context) => Dashboard(),
      },
    );
  }
}
