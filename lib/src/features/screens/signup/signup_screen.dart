import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/textfield_theme.dart';

import '../userverification/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'LoginPage.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Sign Up Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize * 1.5),
        child: Column(
          children: [
            Text('Kindly provide your mobile number, and a verification OTP will sent to your mobile number via SMS or WhatsApp.', style: Theme.of(context).textTheme.headlineMedium,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: cFormHeight - 20),
              //width:  double.infinity,
              height:  cFormHeight + 30,
              child: Form(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: CTextFormFieldTheme.lightInputDecorationTheme,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter Phone Number Starts with 60',
                      hintText: '60123456789', 
                      counterText: '',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                  ),
                ),
              ),
            ),
            
            //Send OTP Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const OTPVerifyPage()),
                );
              },// Send to OTP Page
              child: Container(
                width:  double.infinity,
                height:  cButtonHeight,
                decoration:  BoxDecoration (
                  color: AppColors.cButtonColor,
                  borderRadius:  BorderRadius.circular(10),
                  boxShadow:  const [
                    BoxShadow(
                      color:  Color(0x3f000000),
                      offset:  Offset(0, 2),
                      blurRadius:  2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send OTP', 
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 8), 
                    const Icon(Icons.send_rounded, color: AppColors.cBlackColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}