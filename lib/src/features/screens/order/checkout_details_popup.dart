import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CheckoutDetailPopUp extends StatelessWidget {
  const CheckoutDetailPopUp({super.key});

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 350,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Self Pick Up Information', style: CTextTheme.blackTextTheme.headlineMedium,),
                subtitle: Text('Time\n25 NOV, 14:00 - 16:00', style: CTextTheme.blackTextTheme.headlineMedium,),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '25 NOV, ${14 + index * 2}:00 - ${16 + index * 2}:00', style: CTextTheme.blackTextTheme.headlineMedium,),
                      onTap: () {
                        // Handle the time slot selection
                        Navigator.pop(context); // Close the modal on selection
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showModalBottomSheet(context));
    return Container();
  }
}
