import 'package:flutter/material.dart';
import 'package:legit/screens/on_boarding_screen.dart';
import 'package:legit/screens/scanner_screen.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legit',
      debugShowCheckedModeBanner: false,
      home: SplashScreenWrapper(),
      routes: {
        '/onBoarding': (context) => const OnBoardingScreen(),
        '/scanner': (context) => const ScannerScreen(),
      },
    );
  }
}
