import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/screens/order/confirm_order_pickup.dart';

class PickupQRScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;

  const PickupQRScreen({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
  });

  @override
  State<PickupQRScreen> createState() => PickupQRScreenState();
}

class PickupQRScreenState extends State<PickupQRScreen> {
  Future<void> confirmOrderPickup() async {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmPickupScreen(
            lockerSite: widget.lockerSite,
            compartment: widget.compartment,
            order: widget.order);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const SizedBox(height: 15.0),
          Text(
            'Order Collection',
            textAlign: TextAlign.center,
            style: CTextTheme.blackTextTheme.headlineLarge,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Display this QR code at the locker terminal scanner to unlock your compartment. You can also access this QR code in your order status page.',
            textAlign: TextAlign.center,
            style: CTextTheme.blackTextTheme.headlineSmall,
          ),
        ],
      ),
      content: Column(
        children: [
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
                'Collection Site:',
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
        ],
      ),
      actions: <Widget>[
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: confirmOrderPickup,
                    child: Text(
                      'Confirm Collection',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue[100]!)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'To Order Status Page',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ],
    );
  }
}
