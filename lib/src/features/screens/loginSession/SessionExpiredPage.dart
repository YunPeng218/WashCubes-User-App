import 'package:device_run_test/src/features/screens/home/home_screen.dart';
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Looks like you've been inactive for 5 minutes.\nTo continue, please reauthenticate again.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              },
              child: Text('Reauthenticate Now'),
            ),
          ],
        ),
      ),
    );
  }
}