import 'package:device_run_test/HomePage.dart';
import 'package:device_run_test/src/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPVerifyPage extends StatelessWidget {
  OTPVerifyPage({Key? key, required this.source}) : super(key: key);
  final String source;
  //Generate 6 controllers for the textfields
  List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            const Text('Enter the OTP sent to +60*********'),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Generate 6 containers with textfields for OTP input
              children: List.generate(6, (index) => Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 10),
                decoration:  BoxDecoration (
                  border:  Border.all(color: Color.fromARGB(255, 157, 213, 243)),
                  borderRadius:  BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: controllers[index],// Connecting Controller to Each TextField
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none
                    ),
                    onChanged: (value) {
                      // Check if current TextField is filled
                      if (value.isNotEmpty) {
                        if (index == 5 && _isOTPFilled()) {
                          // Move to Post-verification Process Depending on the Enter Method
                          _handlePostVerification(context);
                        } else {
                          // Focus the next TextField
                          FocusScope.of(context).nextFocus();
                        }
                      }
                    },
                  ),
                ),
              ),
              ),
            ),
            SizedBox(height: 30.0),
            Text("Didn't receive OTP code?"),
            TextButton(
              onPressed: () {null;},// Add your desired action here
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend Code', 
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _isOTPFilled() {
    // Check if all OTP fields are filled
    return controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _handlePostVerification(BuildContext context) {
    if (source == 'login') {
      // Navigate Login Users to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (source == 'signup') {
      // Navigate New Users to Onboarding Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }

    // Add any common actions you want to perform after OTP verification
  }
}