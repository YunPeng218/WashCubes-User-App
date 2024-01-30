import 'package:device_run_test/src/constraints/sizes.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/authentication/screens/signup/SignUpPage.dart';
import 'package:device_run_test/src/features/authentication/screens/userverification/OTPVerifyPage.dart';
import 'package:device_run_test/src/features/authentication/screens/home/HomePage.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';
import 'package:device_run_test/src/constraints/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      theme: CAppTheme.lightTheme,
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logos/washcube_logo.png', height: size.height * 0.2),
              const SizedBox(height: cDefaultSize,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => OTPVerifyPage(source: 'login')),
                  );
                },// Navigate to Login Page
                child: Container(
                  width:  double.infinity,
                  height:  cButtonHeight,
                  decoration:  BoxDecoration (
                    border:  Border.all(color: AppColors.cBlackColor),
                    borderRadius:  BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text('Login', style: Theme.of(context).textTheme.headlineMedium,),
                  ),
                ),
              ),
              const SizedBox(height: 5.0,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },// Navigate to Sign Up Page
                child: Container(
                  width:  double.infinity,
                  height:  cButtonHeight,
                  decoration:  BoxDecoration (
                    border:  Border.all(color: AppColors.cBlackColor),
                    borderRadius:  BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Center(
                      child: Text('Sign Up', style: Theme.of(context).textTheme.headlineMedium,),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },// Add your desired action here
                child: const Text(
                  'Continue as Guest', 
                  style: TextStyle(decoration: TextDecoration.underline, color: AppColors.cGreyColor3,), 
                ),
              ),
              //start biometric icon
              const Text(
                'OR', 
                style: TextStyle(color: AppColors.cGreyColor3,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.camera_front, size: 40.0), onPressed: () {null;},),
                  IconButton(icon: const Icon(Icons.fingerprint, size: 40.0), onPressed: () {null;},),
                  IconButton(icon: const Icon(Icons.qr_code, size: 40.0), onPressed: () {null;},),
                ],
              ),
              // Add more widgets as needed
              
            ],
          ),
        ),
      ),
    );
  }
}