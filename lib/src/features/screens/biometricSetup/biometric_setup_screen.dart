import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/screens/onboarding/onboarding_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/elevatedbutton_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';

class BiometricSetupPage extends StatelessWidget {
  const BiometricSetupPage({super.key});

  // Function to show biometric prompt
  Future<void> showBiometricPrompt(BuildContext context) async {
    final localAuth = LocalAuthentication();
    var prefs = await SharedPreferences.getInstance();

    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometric access',
      );
      if (isAuthenticated) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
          (Route<dynamic> route) => false);
        prefs.setString('isBiometricsEnabled', 'true');
        prefs.setString('isAuthenticated', 'true');
      } else {
        print('Biometric authentication failed');
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Biometric Log In',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
        actions: [
          //End Button
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnboardingScreen()),
                );
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.cGreyColor3,
                ),
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60.0),
            Text(
              'Enabling Touch ID or Face ID will give you a secure access.',
              style: CTextTheme.blackTextTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60.0,
            ),
            //Biometric Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(cFingerprintImage, height: size.height * 0.15),
                Image.asset(cFacialScanImage, height: size.height * 0.15),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            //Enable Button
            ElevatedButton(
              onPressed: () {
                showBiometricPrompt(context);
              },
              style: CElevatedButtonTheme.lightElevatedButtonTheme.style,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.checkmark_alt,
                    color: AppColors.cBlackColor,
                  ),
                  Text(
                    'Enable',
                    style: CTextTheme.blackTextTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            Text(
              'You can turn this feature on or off at any time under Settings.',
              style: CTextTheme.greyTextTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
