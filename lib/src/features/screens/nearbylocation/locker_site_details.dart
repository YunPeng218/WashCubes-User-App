import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/locker_compartment_select.dart';

class LockerSiteDetailsPopup extends StatelessWidget {
  final LockerSite lockerSite;

  const LockerSiteDetailsPopup({
    super.key,
    required this.lockerSite,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        lockerSite.name,
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineLarge,
      ),
      content: Text(
        lockerSite.address,
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
                  'Back',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockerCompartmentSelect(
                          selectedLockerSite: lockerSite),
                    ),
                  );
                },
                child: Text(
                  'Select',
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
