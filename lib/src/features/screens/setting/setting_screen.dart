import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  bool orderstatuslight = true;
  bool emaillight = true;
  late bool biometriclight;

  Future<bool> isBiometricsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isEnabled = prefs.getString('isBiometricsEnabled') ?? 'false';
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
        await prefs.setString('isBiometricsEnabled', 'true');
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
          showCustomDialog(context, 'No biometrics available on this device');
        }
      } else {
        // Biometrics cannot be checked on the device
        showCustomDialog(context, 'Biometrics cannot be checked on this device');
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
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
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
                Text('When your order status changed ', style: CTextTheme.blackTextTheme.headlineMedium),
                Switch(
                  value: orderstatuslight,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    setState(() {
                      orderstatuslight = value;
                    });
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
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error loading biometric status');
                    } else {
                      return Switch(
                        value: snapshot.data ?? false,
                        activeColor: AppColors.cSwitchColor,
                        onChanged: (bool value) async {
                          if (value==true)
                            checkBiometrics(context);
                          else {
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