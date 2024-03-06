import 'dart:convert';

import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/outlinedbutton_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/textfield_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/screens/userverification/otp_screen.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:flutter/services.dart';
import 'package:device_run_test/config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:device_run_test/src/features/screens/onboarding/onboarding_screen.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool isNotValidate = false;
  String errorText = '';

  void phoneNumbervalidation() async {
    RegExp pattern = RegExp(r'^(601)[0-46-9][0-9]{7,8}$');
    if (phoneNumberController.text.isNotEmpty) {
      if (pattern.hasMatch(phoneNumberController.text)) {
        var reqUrl = '${url}sendOTP';
        var response = await http.post(Uri.parse(reqUrl),
            body: {"phoneNumber": phoneNumberController.text});
        var jsonResponse = jsonDecode(response.body);
        String otpGenerated = jsonResponse['otp'];
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerifyPage(
                  phoneNumber: phoneNumberController.text,
                  otp: otpGenerated,
                  isUpdating: false)),
        );
      } else {
        setState(() {
          errorText = 'Invalid Phone Number Entered.';
          isNotValidate = true;
        });
      }
    } else {
      setState(() {
        errorText = 'Please Enter Your Phone Number.';
        isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(cAppLogo, height: size.height * 0.2),
            const SizedBox(
              height: cDefaultSize,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: cFormHeight - 30),
              //width:  double.infinity,
              height: cFormHeight + 40,
              child: Form(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme:
                        CTextFormFieldTheme.lightInputDecorationTheme,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme:
                          CTextFormFieldTheme.lightInputDecorationTheme,
                    ),
                    child: TextField(
                      controller: phoneNumberController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Phone Number Starts with 60',
                        hintText: '60123456789',
                        errorStyle: const TextStyle(color: Colors.red),
                        errorText: isNotValidate ? errorText : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            OutlinedButton(
              onPressed: () {
                phoneNumbervalidation(); // Navigate to OTP
              },
              style: COutlinedButtonTheme.lightOutlinedButtonTheme.style,
              child: Center(
                child: Text(
                  'Continue',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextButton(
              onPressed: () {
                Provider.of<GuestModeProvider>(context, listen: false)
                    .setGuestMode(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnboardingScreen()),
                );
              },
              child: const Text(
                'Continue as Guest',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.cGreyColor3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
