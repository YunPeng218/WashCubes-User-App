import 'package:device_run_test/src/utilities/theme/theme.dart';
//import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import '../signup/SignUpPage.dart';
import '../userverification/OTPVerifyPage.dart';
import '../home/HomePage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                      child: Text('Login',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge,),
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
                  child: const Center(
                    child: Center(
                      child: Text('Sign Up',textAlign: TextAlign.center,),
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
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.grey,),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
              //start biometric icon
              Text('OR', style: Theme.of(context).textTheme.displayLarge ),
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
