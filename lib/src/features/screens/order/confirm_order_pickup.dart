// ignore_for_file: must_be_immutable

import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/order_status_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/screens/order_error/order_error_return_screen.dart';

class ConfirmPickupScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;

  const ConfirmPickupScreen({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
  });

  @override
  State<ConfirmPickupScreen> createState() => ConfirmPickupScreenState();
}

class ConfirmPickupScreenState extends State<ConfirmPickupScreen> {
  void navigateToOrderStatus(Order order) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderStatusScreen(
          order: widget.order!,
        ),
      ),
    );
  }

  // CONFIRM DROP OFF ON SERVER SIDE
  Future<void> confirmPickup() async {
    Map<String, dynamic> confirmPickup = {
      'orderId': widget.order?.id,
      'lockerSiteId': widget.lockerSite?.id,
      'compartmentId': widget.compartment?.id
    };

    final response = await http.post(
      Uri.parse('${url}orders/confirm-collection'),
      body: json.encode(confirmPickup),
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
            return ConfirmPickupSuccess(
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
        'Confirm Collection of Laundry?',
        textAlign: TextAlign.center,
        style: CTextTheme.blackTextTheme.headlineLarge,
      ),
      content: Text(
        'Please ensure that you have retrieved all of your items and securely shut the compartment door. Your order cannot proceed until the door is closed.',
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
                  await confirmPickup();
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

class ConfirmPickupSuccess extends StatelessWidget {
  Order order;

  ConfirmPickupSuccess({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.orderStage?.orderError.status == true) {
      return AlertDialog(
        title: Text(
          'Collection Successful!',
          textAlign: TextAlign.center,
          style: CTextTheme.blackTextTheme.headlineLarge,
        ),
        content: Text(
          'Your order has been succesfully returned. We apologize for any inconvenience caused.',
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
                      builder: (context) => OrderErrorStatusScreen(
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
    } else {
      return AlertDialog(
        title: Text(
          'Collection Successful!',
          textAlign: TextAlign.center,
          style: CTextTheme.blackTextTheme.headlineLarge,
        ),
        content: Text(
          'Your order is completed. Thank you for using WashCubes!',
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
}
