import 'package:device_run_test/src/constraints/image_strings.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Column(
          children: [
            Image(image: AssetImage(cAppLogo)),
          ],
        )
      )
    
    );
  }
}