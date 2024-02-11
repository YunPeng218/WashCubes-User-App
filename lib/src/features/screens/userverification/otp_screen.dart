// ignore_for_file: use_build_context_synchronously

import 'package:device_run_test/src/features/screens/onboarding/onboarding_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:device_run_test/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

// SCREENS
import 'package:device_run_test/src/features/screens/biometricSetup/biometric_setup_screen.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_summary_screen.dart';

// STYLES
import 'package:device_run_test/src/constants/colors.dart';

// UTILS
import 'package:device_run_test/src/utilities/guest_mode.dart';

class OTPVerifyPage extends StatefulWidget {
  const OTPVerifyPage({super.key});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPVerifyPage> {
  late SharedPreferences prefs;
  TextEditingController phoneNumberController = TextEditingController();
  String currentText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void resendOTP() async {
    await http.post(Uri.parse(otpverification));
  }

  Future<void> checkBiometrics(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        if (canAuthenticateWithBiometrics && await auth.isDeviceSupported()) {
          // Biometric authentication is available
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BiometricSetupPage(),
            ),
            (Route<dynamic> route) => false);
        } else {
          // No biometrics available on the device
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
            (Route<dynamic> route) => false);
        }
      } else {
        // Biometrics cannot be checked on the device
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
          (Route<dynamic> route) => false);
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  void otpValidation() async {
    var response = await http.post(Uri.parse(registration),
        body: {"otpRes": phoneNumberController.text});
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 'existingUser') {
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);

      // Set Guest Mode to False
      Provider.of<GuestModeProvider>(context, listen: false)
          .setGuestMode(false);

      // Check if Guest Has Made Order
      if (Provider.of<GuestModeProvider>(context, listen: false)
          .guestMadeOrder) {
        Provider.of<GuestModeProvider>(context, listen: false)
            .setGuestMadeOrder(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummary(
              order: Provider.of<GuestModeProvider>(context, listen: false)
                  .guestOrder,
              service: Provider.of<GuestModeProvider>(context, listen: false)
                  .guestService,
              lockerSite: Provider.of<GuestModeProvider>(context, listen: false)
                  .guestLockerSite,
              selectedCompartmentSize:
                  Provider.of<GuestModeProvider>(context, listen: false)
                      .guestSelectedCompartmentSize,
              compartment: null,
              collectionSite:
                  Provider.of<GuestModeProvider>(context, listen: false)
                      .guestCollectionSite,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (Route<dynamic> route) => false);
      }
    } else if (jsonResponse['status'] == 'newUser') {
      // Set Guest Mode to False
      Provider.of<GuestModeProvider>(context, listen: false)
          .setGuestMode(false);
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);
      checkBiometrics(context);
    } else if (jsonResponse['status'] == 'wrongOTP') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(
              'The OTP entered is incorrect. Please try again.',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            Text(
              'Enter the OTP sent to +60*********',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            const SizedBox(height: 30.0),
            //Pin Code Field
            PinCodeTextField(
              appContext: context,
              controller: phoneNumberController,
              length: 6,
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              pastedTextStyle: Theme.of(context).textTheme.headlineMedium,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldWidth: 50,
                inactiveColor: AppColors.cPrimaryColor,
                selectedColor: AppColors.cPrimaryColor,
                activeFillColor: AppColors.cWhiteColor,
                selectedFillColor: AppColors.cWhiteColor,
                inactiveFillColor: AppColors.cWhiteColor,
              ),
              onChanged: (value) {
                setState(() {
                  // currentText = value;
                });
              },
              onCompleted: (value) {
                otpValidation();
              },
              beforeTextPaste: (text) {
                return true;
              },
            ),
            const SizedBox(height: 30.0),
            Text(
              "Didn't receive OTP code?",
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            //OTP Resend Link
            TextButton(
              onPressed: () {
                resendOTP();
              }, // Resend OTP Code
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend Code',
                    style: TextStyle(
                        color: AppColors.cBlueColor2,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
