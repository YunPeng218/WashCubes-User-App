import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/screens/order/order_status_screen.dart';
//import 'package:device_run_test/src/features/screens/order/confirm_order_dropoff.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_run_test/config.dart';

class DropOffQRPage extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;

  const DropOffQRPage({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
  });

  @override
  State<DropOffQRPage> createState() => DropOffQRPageState();
}

class DropOffQRPageState extends State<DropOffQRPage> {
  Future<void> confirmOrderDropOff() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }

  Future<void> confirmDropOff() async {
    if (widget.order == null) {
      print('Order is null or order id is null.');
      return;
    }

    Map<String, dynamic> confirmDropOff = {
      'orderId': widget.order!.id,
    };

    final response = await http.post(
      Uri.parse('${url}orders/confirm-drop-off'),
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
        );
      } else {
        print('Response data does not contain saved order.');
      }
    } else {
      print('Failed to confirm order. Status code: ${response.statusCode}');
    }
  }

  void navigateToOrderStatus() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderStatusScreen(
          order: widget.order!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            Text(
              'Order Successfully Placed!',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Display this QR code at the locker terminal scanner to unlock your compartment. You can also access this QR code in your order status page.',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineSmall,
            ),
            Image.asset(cDummyOrderQR, height: 300, width: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order No.',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                Text(
                  widget.order?.orderNumber ?? 'Loading...',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Drop Off:',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                Text(
                  widget.lockerSite?.name ?? 'Loading...',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned Compartment:',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                Text(
                  widget.compartment?.compartmentNumber ?? 'Loading...',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: confirmOrderDropOff,
                    child: Text(
                      'Confirm Order Drop-Off',
                      style: CTextTheme.blackTextTheme.headlineSmall,
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
}

class ConfirmDropOffSuccess extends StatelessWidget {
  final Order order;

  const ConfirmDropOffSuccess({Key? key, required this.order})
      : super(key: key);

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
