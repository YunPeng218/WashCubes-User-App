import 'package:device_run_test/src/constraints/colors.dart';
import 'package:device_run_test/src/constraints/sizes.dart';

import '../userverification/OTPVerifyPage.dart';
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
            Form(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: cFormHeight - 10),
                child: Row(
                  children: [
                    //Country Phone Code
                    Container(
                      width:  70,
                      height:  cButtonHeight,
                      decoration:  BoxDecoration (
                        border:  Border.all(color: AppColors.cBlackColor),
                        borderRadius:  BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('MY +60', style: Theme.of(context).textTheme.headlineSmall,),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    //Phone No. Input Box
                    Expanded(
                      child: Container(
                        width:  200,
                        height:  cButtonHeight,
                        decoration:  BoxDecoration (
                          border:  Border.all(color: AppColors.cBlueColor1),
                          borderRadius:  BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            // labelText: 'MOBILE NUMBER',
                            hintText: '123456789',
                            hintStyle: TextStyle(color: AppColors.cGreyColor3), 
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            //Send OTP Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => OTPVerifyPage(source: 'signup')),
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