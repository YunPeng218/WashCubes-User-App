import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CancelConfirmAlert extends StatelessWidget {
  final String title;
  final String content;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onPressedConfirm;

  const CancelConfirmAlert(
      {super.key,
      required this.title,
      required this.content,
      required this.onPressedConfirm,
      required this.cancelButtonText,
      required this.confirmButtonText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineLarge,
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineMedium,
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[100]!)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  cancelButtonText,
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                onPressed: onPressedConfirm,
                child: Text(
                  confirmButtonText,
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
