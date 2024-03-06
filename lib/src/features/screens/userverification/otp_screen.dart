// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';

import 'package:device_run_test/src/features/screens/onboarding/onboarding_screen.dart';
import 'package:device_run_test/src/features/screens/setting/edit_profile_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:device_run_test/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

// SCREENS
import 'package:device_run_test/src/features/screens/biometric_setup/biometric_setup_screen.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_summary_screen.dart';

// STYLES
import 'package:device_run_test/src/constants/colors.dart';

// UTILS
import 'package:device_run_test/src/utilities/guest_mode.dart';

class OTPVerifyPage extends StatefulWidget {
  final String phoneNumber;
  String otp;
  bool isResendButtonEnabled = false;
  bool isUpdating;

  OTPVerifyPage(
      {required this.phoneNumber,
      required this.otp,
      required this.isUpdating,
      super.key});

  @override
  OTPPageState createState() => OTPPageState();
}

class OTPPageState extends State<OTPVerifyPage> {
  late SharedPreferences prefs;
  TextEditingController otpController = TextEditingController();
  late Timer timer;
  int remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    startTimer();
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          widget.otp = '';
          widget.isResendButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void resendOTP() async {
    if (widget.isResendButtonEnabled) {
      var reqUrl = '${url}sendOTP';
      var response = await http
          .post(Uri.parse(reqUrl), body: {"phoneNumber": widget.phoneNumber});
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        widget.otp = jsonResponse['otp'];
        widget.isResendButtonEnabled = false;
        remainingSeconds = 60;
      });
      timer.cancel();
      startTimer();
    }
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
    if ((widget.otp == otpController.text) && !widget.isUpdating) {
      var reqUrl = '${url}userVerification';
      var response = await http.post(Uri.parse(reqUrl), body: {
        "phoneNumber": widget.phoneNumber,
        "fcmToken": prefs.getString('fcmToken')
      });
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'existingUser') {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        prefs.setString('isNotificationEnabled', 'true');

        // Set Guest Mode to False
        Provider.of<GuestModeProvider>(context, listen: false)
            .setGuestMode(false);

        // Check if Guest Has Made Order
        if (Provider.of<GuestModeProvider>(context, listen: false)
            .guestMadeOrder) {
          Provider.of<GuestModeProvider>(context, listen: false)
              .setGuestMadeOrder(false);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return OrderSummary(
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
              justNavigatedFromGuest: true,
            );
          }), (route) {
            return false;
          });
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
        prefs.setString('isNotificationEnabled', 'true');
        checkBiometrics(context);
      }
    } else if ((widget.otp == otpController.text) && widget.isUpdating) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      String userId = jwtDecodedToken['_id'];
      var reqUrl = '${url}editPhoneNumber';
      var response = await http.patch(Uri.parse(reqUrl),
          body: {"userId": userId, "phoneNumber": widget.phoneNumber});
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EditProfilePage()));
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Error', style: CTextTheme.blackTextTheme.headlineLarge),
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
            const SizedBox(height: 40.0),
            Text(
              'Enter the OTP sent to +60*********',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            const SizedBox(height: 30.0),
            //Pin Code Field
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
              child: PinCodeTextField(
                appContext: context,
                controller: otpController,
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
                onCompleted: (value) {
                  otpValidation();
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              "Didn't receive OTP code?",
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            Text(
              'Resend in ${remainingSeconds}s',
              style: const TextStyle(
                color: AppColors.cGreyColor2,
              ),
            ),
            //OTP Resend Link
            TextButton(
              onPressed: () {
                resendOTP();
              }, // Resend OTP Code
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend Code',
                    style: TextStyle(
                      color: widget.isResendButtonEnabled
                          ? AppColors.cBlueColor2
                          : AppColors.cGreyColor2,
                      decoration: widget.isResendButtonEnabled
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: AppColors.cBlueColor2,
                    ),
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
