import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}
class SettingPageState extends State<SettingPage> {
  bool orderstatuslight = true;
  bool emaillight = true;
  bool biometriclight = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Notification Category
            Text('NOTIFICATION', style: CTextTheme.greyTextTheme.labelLarge,),
            //Order Status Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('When your order status changed ', style: CTextTheme.blackTextTheme.headlineMedium,),
                Switch(
                  // This bool value toggles the switch.
                  value: orderstatuslight,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      orderstatuslight = value;
                    },);
                  },
                ),
              ],
            ),
            //Email Newsletter Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receive email newsletter', style: CTextTheme.blackTextTheme.headlineMedium,),
                Switch(
                  // This bool value toggles the switch.
                  value: emaillight,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      emaillight = value;
                    },);
                  },
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize,),
            //Security Category
            Text('SECURITY', style: CTextTheme.greyTextTheme.labelLarge,),
            //Biometric Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Use biometric to login', style: CTextTheme.blackTextTheme.headlineMedium,),
                      Text('All biometrics stored on this device can be used to log into your account', style: CTextTheme.greyTextTheme.labelLarge,),
                    ],
                  ),
                ),
                Switch(
                  // This bool value toggles the switch.
                  value: biometriclight,
                  activeColor: AppColors.cSwitchColor,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      biometriclight = value;
                    },);
                  },
                ),
              ],
            ),
            const SizedBox(height: cDefaultSize,),
            //Delete Account Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){}, 
                    child: Text('Delete Account', 
                    style: CTextTheme.blackTextTheme.headlineMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }
}