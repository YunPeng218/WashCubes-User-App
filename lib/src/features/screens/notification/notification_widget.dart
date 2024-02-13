// import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(cDefaultSize - 10),
      //height: cFormHeight * 3.5,
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
                  'Your Laundry is Ready for Pick Up!',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
                Text(
                  'Order #91296 is now ready for pick up at Taylor’s University!',
                  style: CTextTheme.blackTextTheme.labelLarge,
                ),
              ],
            ),
          ),
          Text(
            'Nov23',
            style: CTextTheme.greyTextTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
