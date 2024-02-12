// ignore_for_file: must_be_immutable

import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/order_status_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_run_test/config.dart';

class ConfirmDropOffScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;

  const ConfirmDropOffScreen({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
  });

  @override
  State<ConfirmDropOffScreen> createState() => ConfirmDropOffScreenState();
}

class ConfirmDropOffScreenState extends State<ConfirmDropOffScreen> {
  void navigateToOrderStatus(Order order) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderStatusScreen(
          order: order,
        ),
      ),
    );
  }

  // CONFIRM DROP OFF ON SERVER SIDE
  Future<void> confirmDropOff() async {
    Map<String, dynamic> confirmDropOff = {
      'orderId': widget.order?.id,
      'lockerSiteId': widget.lockerSite?.id,
      'compartmentId': widget.compartment?.id
    };

    final response = await http.post(
      Uri.parse(url + 'orders/confirm-drop-off'),
      body: json.encode(confirmDropOff),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('order')) {
        final dynamic orderData = data['order'];
        final Order order = Order.fromJson(orderData);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDropOffSuccess(
              order: order,
            );
          },
        ).then((value) => {navigateToOrderStatus(order)});
      } else {
        print('Response data does not contain saved order.');
      }
    } else {
      print('Failed to confirm order. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirm Drop Off of Laundry?',
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineLarge,
      ),
      content: Text(
        'Please ensure that you have placed the correct amount of laundry in your assigned compartment and securely shut the compartment door. Your order cannot proceed until the door is closed.',
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineSmall,
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
                  'Cancel',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await confirmDropOff();
                },
                child: Text(
                  'Confirm',
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

class ConfirmDropOffSuccess extends StatelessWidget {
  Order order;

  ConfirmDropOffSuccess({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Drop Off Successful!',
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineLarge,
      ),
      content: Text(
        'Your order status has been updated. A rider will pick up your laundry order soon.',
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineMedium,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue[100]!)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderStatusScreen(
                      order: order,
                    ),
                  ),
                );
              },
              child: Text(
                'Nice!',
                style: CTextTheme.blackTextTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
