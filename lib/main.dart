import 'package:device_run_test/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';

import 'SettingMainPage.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // themeMode: ThemeMode.system,
      title: 'WashCubes App',
      theme: CAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(), // Set the initial page to the LoginPage
    );
  }
}
