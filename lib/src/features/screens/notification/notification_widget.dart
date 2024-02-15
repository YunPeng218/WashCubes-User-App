import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({
    Key? key,
    required this.size,
    required this.title,
    required this.message,
    required this.date, 
    this.isRead = false,
  }) : super(key: key);

  final Size size;
  final String title;
  final String message;
  final String date;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(cDefaultSize - 10),
      color: isRead ? Colors.white : Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(cTrimiDefault),
          SizedBox(
            width: size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isRead
                    ? CTextTheme.greyTextTheme.headlineSmall
                    : CTextTheme.blackTextTheme.headlineSmall,
                ),
                Text(
                  message,
                  style: isRead
                    ? CTextTheme.greyTextTheme.labelLarge
                    : CTextTheme.blackTextTheme.labelLarge,
                ),
              ],
            ),
          ),
          Text(
            DateFormat('dd MMM').format(DateTime.parse(date)),
            style: isRead
              ? CTextTheme.greyTextTheme.headlineSmall
              : CTextTheme.blackTextTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
