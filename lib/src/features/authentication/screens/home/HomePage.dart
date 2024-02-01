import 'package:device_run_test/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/outlinedbutton_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('HomePage', style: TextStyle(fontWeight: FontWeight.bold),),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Column(
          children: [
            const Text('this is home page'),
          ],
        ),
      ),

    );
  }
}