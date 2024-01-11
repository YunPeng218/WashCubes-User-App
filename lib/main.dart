import 'package:device_run_test/LoginPage.dart';
import 'package:device_run_test/SignUpPage.dart';
import 'package:device_run_test/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';
import 'src/features/authentication/screens/onboarding/onboarding_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WashCubes App',
      theme: CAppTheme.lightTheme,
      home: const OnboardingScreen(), // Set the initial page to the LoginPage
    );
  }
}
