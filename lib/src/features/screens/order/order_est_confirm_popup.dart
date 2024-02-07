import 'package:device_run_test/src/features/screens/chatbot/chatbot_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/outlinedbutton_theme.dart';
import 'package:flutter/material.dart';

class OrderEstConfirmationAlertWidget extends StatelessWidget {
  const OrderEstConfirmationAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Alert Dialog PopUp of Order Price Estimation Confirmation
    return AlertDialog(
      // title: Text("If your order exceeds the estimated price, we'll provide further instructions. Click 'Continue' to agree to our Terms and Conditions and Privacy Policy."),
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
            Row(
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
                      style:
                          COutlinedButtonTheme.lightOutlinedButtonTheme.style,
                      child: Text(
                        'Cancel',
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
                      style:
                          COutlinedButtonTheme.lightOutlinedButtonTheme.style,
                      child: Text(
                        'Continue',
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
