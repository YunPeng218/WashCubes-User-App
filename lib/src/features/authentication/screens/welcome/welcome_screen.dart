import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/authentication/screens/signup/SignUpPage.dart';
import 'package:device_run_test/OTPVerifyPage.dart';
import 'package:device_run_test/HomePage.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';
import 'package:device_run_test/src/constraints/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CAppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logos/washcube_logo.png'),
              const SizedBox(height: 40.0,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => OTPVerifyPage(source: 'login')),
                  );
                },// Navigate to Sign Up Page
                // style: TextButton.styleFrom(padding: EdgeInsets.only(top: 50.0)),
                child: Container(
                  width:  329,
                  height:  46,
                  //margin: EdgeInsets.only(top: 50.0),
                  decoration:  BoxDecoration (
                    border:  Border.all(color: Colors.black),
                    borderRadius:  BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text('Login',textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium,),
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
                // style: TextButton.styleFrom(padding: EdgeInsets.only(top: 50.0)),
                child: Container(
                  width:  329,
                  height:  46,
                  //margin: EdgeInsets.only(top: 50.0),
                  decoration:  BoxDecoration (
                    border:  Border.all(color: Colors.black),
                    borderRadius:  BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Center(
                      child: Text('Sign Up',textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium,),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Continue as Guest', 
                      style: TextStyle(decoration: TextDecoration.underline, color: AppColors.cGreyColor3,), 
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
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
                // crossAxisAlignment: CrossAxisAlignment.end,
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