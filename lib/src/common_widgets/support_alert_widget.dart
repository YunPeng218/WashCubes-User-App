import 'package:device_run_test/src/features/authentication/screens/chatbot/chatbot_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/outlinedbutton_theme.dart';
import 'package:flutter/material.dart';

class SupportAlertWidget extends StatelessWidget {
  const SupportAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Alert Dialog PopUp of Customer Support
    return AlertDialog(
      content: SingleChildScrollView(
        //Keep size to necessary height
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //PopUp Title
                Text(
                  'Select an action',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                //Close Button
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the alert dialog
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Column(
              children: [
                //Trimi ChatBot Redirect Button
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatBotScreen()),
                        );
                      },
                      style: COutlinedButtonTheme
                          .lightOutlinedButtonTheme.style,
                      child: Text(
                        'Chat with Trimi',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )),
                  ],
                ),
                //Customer Hotline Redirect Button
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      style: COutlinedButtonTheme
                          .lightOutlinedButtonTheme.style,
                      child: Text(
                        'Contact Customer Hotline',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}