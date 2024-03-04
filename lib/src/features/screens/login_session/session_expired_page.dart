import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class SessionExpiredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Session Expired',
              style: CTextTheme.blackTextTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            Text(
              "Looks like you've been inactive for 5 minutes.\nTo continue, please reauthenticate again.",
              style: CTextTheme.blackTextTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              },
              child: Text('Reauthenticate Now', style: CTextTheme.blackTextTheme.headlineMedium,),
            ),
          ],
        ),
      ),
    );
  }
}