import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;
import 'package:device_run_test/config.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  late bool orderstatuslight;
  bool emaillight = true;
  late bool biometriclight;

  Future<bool> isBiometricsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isEnabled = prefs.getString('isBiometricsEnabled') ?? 'false';
    return isEnabled == 'true';
  }

  Future<bool> isNotificationEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isEnabled = prefs.getString('isNotificationEnabled') ?? 'false';
    return isEnabled == 'true';
  }

  Future<void> showBiometricPrompt(BuildContext context) async {
    final localAuth = LocalAuthentication();
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometric access',
        options: const AuthenticationOptions(biometricOnly: true)
      );
      if (isAuthenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('isBiometricsEnabled', 'true');
        prefs.setString('isAuthenticated', 'true');
        prefs.setString('sessionExpired', 'false');
        setState(() {
          biometriclight = true;
        });
      } else {
        print('Biometric authentication failed');
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  Future<void> checkBiometrics(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        if (canAuthenticateWithBiometrics && await auth.isDeviceSupported()) {
          // Biometric authentication is available
          showBiometricPrompt(context);
        } else {
          // No biometrics available on the device
          showCustomDialog(context, 'Please enable biometrics under phone settings.');
        }
      } else {
        // Biometrics cannot be checked on the device
        showCustomDialog(context, 'Biometrics is not supported on this device.');
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  void showCustomDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Error',
          style: CTextTheme.blackTextTheme.headlineLarge
        ),
        content: Text(
          message,
          style: CTextTheme.blackTextTheme.headlineMedium
        ),
        actions: [
          TextButton(
            onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: CTextTheme.blackTextTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Category
            Text('NOTIFICATION', style: CTextTheme.greyTextTheme.labelLarge),
            // Order Status Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('When your order status changed', style: CTextTheme.blackTextTheme.headlineMedium),
                FutureBuilder<bool>(
                  future: isNotificationEnabled(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error loading notification status');
                    } else {
                      return Switch(
                        value: snapshot.data ?? false,
                        activeColor: AppColors.cSwitchColor,
                        onChanged: (bool value) async {
                          if (value==true) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var token = prefs.getString('token');
                            Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
                            http.patch(Uri.parse(addFCMToken),
                              body: {"userId": jwtDecodedToken['_id'], "fcmToken": prefs.getString('fcmToken')});
                            await prefs.setString('isNotificationEnabled', 'true');
                          } else {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var token = prefs.getString('token');
                            Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
                            http.patch(Uri.parse(deleteFCMToken),
                              body: {"userId": jwtDecodedToken['_id'], "fcmToken": prefs.getString('fcmToken')});
                            await prefs.setString('isNotificationEnabled', 'false');
                          }
                          setState(() {
                            orderstatuslight = value;
                          });
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            // Email Newsletter Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receive email newsletter', style: CTextTheme.blackTextTheme.headlineMedium),
                Switch(
                  value: emaillight,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    setState(() {
                      emaillight = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize),
            // Security Category
            Text('SECURITY', style: CTextTheme.greyTextTheme.labelLarge),
            // Biometric Switch Row using FutureBuilder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Use biometric to login', style: CTextTheme.blackTextTheme.headlineMedium),
                      Text('All biometrics stored on this device can be used to log into your account',
                          style: CTextTheme.greyTextTheme.labelLarge),
                    ],
                  ),
                ),
                FutureBuilder<bool>(
                  future: isBiometricsEnabled(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error loading biometric status');
                    } else {
                      return Switch(
                        value: snapshot.data ?? false,
                        activeColor: AppColors.cSwitchColor,
                        onChanged: (bool value) async {
                          if (value==true) {
                            checkBiometrics(context);
                          } else {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('isBiometricsEnabled', 'false');
                          }
                          setState(() {
                            biometriclight = value;
                          });
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize),
            // Delete Account Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Delete Account',
                      style: CTextTheme.blackTextTheme.headlineMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}