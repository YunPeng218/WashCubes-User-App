import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
// import 'package:device_run_test/src/utilities/theme/widget_themes/outlinedbutton_theme.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
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
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //PopUp Title
                Text(
                  'Select An Action',
                  textAlign: TextAlign.center,
                  style: CTextTheme.blackTextTheme.headlineMedium,
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
            const SizedBox(height: 5.0),
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
                              builder: (context) => const ChatbotScreen()),
                        );
                      },
                      // style:
                      //     COutlinedButtonTheme.lightOutlinedButtonTheme.style,
                      child: Text(
                        'Chat with Trimi',
                        style: CTextTheme.blackTextTheme.headlineSmall,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 5.0),
                //Customer Hotline Redirect Button
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      // style:
                      //     COutlinedButtonTheme.lightOutlinedButtonTheme.style,
                      child: Text(
                        'Contact Customer Hotline',
                        style: CTextTheme.blackTextTheme.headlineSmall,
                      ),
                    )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
