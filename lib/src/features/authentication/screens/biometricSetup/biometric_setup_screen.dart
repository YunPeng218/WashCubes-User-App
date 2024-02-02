import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/elevatedbutton_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';

class BiometricSetupPage extends StatelessWidget {
  const BiometricSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Biometric Log In',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
        actions: [
          //End Button
          TextButton(onPressed: (){Navigator.push(
          context, MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );},
          child: Text('Skip', style: TextStyle(decoration: TextDecoration.underline, color: AppColors.cGreyColor3,),)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60.0),
            Text(
              'Enabling Touch ID or Face ID will give you faster access.', 
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.0,),
            //Biometric Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(cFingerprintImage, height: size.height * 0.15),
                Image.asset(cFacialScanImage, height: size.height * 0.15),
              ],
            ),
            SizedBox(height: 50.0,),
            //Enable Button
            ElevatedButton(
              onPressed: (){}, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.checkmark_alt, color: AppColors.cBlackColor,),
                  Text('Enable', style: Theme.of(context).textTheme.headlineSmall,)
                ],
              ),
              style: CElevatedButtonTheme.lightElevatedButtonTheme.style,
            ),
            Text(
              'You can turn this feature on or off at any time under Settings.', 
              style: TextStyle(color: AppColors.cGreyColor3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
