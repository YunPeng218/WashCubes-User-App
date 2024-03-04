import 'package:device_run_test/src/features/screens/order/order_status_summary.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/features/screens/order/dropoff_qr_popup.dart';
import 'package:device_run_test/src/features/screens/order/pickup_qr_popup.dart';

class OrderStatusDetailWidget extends StatefulWidget {
  final Order order;
  final LockerSite? lockerSite;
  final LockerSite? collectionSite;
  final Service? service;

  const OrderStatusDetailWidget({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.collectionSite,
    required this.service,
  });

  @override
  OrderStatusDetailWidgetState createState() => OrderStatusDetailWidgetState();
}

class OrderStatusDetailWidgetState extends State<OrderStatusDetailWidget> {
  void viewOrderSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderStatusSummaryScreen(
                order: widget.order,
                service: widget.service,
                dropOffSite: widget.lockerSite,
                collectionSite: widget.collectionSite,
              )),
    );
  }

  void displayDropoffQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DropoffQRScreen(
            lockerSite: widget.lockerSite,
            compartment: widget.lockerSite?.compartments.firstWhere(
                (compartment) =>
                    compartment.id ==
                    widget.order.lockerDetails?.compartmentId),
            order: widget.order);
      },
    );
  }

  void displayPickupQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PickupQRScreen(
            lockerSite: widget.collectionSite,
            compartment: widget.collectionSite?.compartments.firstWhere(
                (compartment) =>
                    compartment.id ==
                    widget.order.lockerDetails?.compartmentId),
            order: widget.order);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String orderStage = widget.order.orderStage?.getMostRecentStatus() ?? '';
    return //Order Summary & Details
        Column(
      children: [
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Order Information',
            style: CTextTheme.blueTextTheme.headlineLarge,
          ),
        ),
        //Order Creation Detail Row
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Created:',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              Text(
                widget.order.getFormattedDateTime(widget.order.createdAt),
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collection Site:',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              Text(
                widget.collectionSite?.name ?? 'Loading...',
                style: CTextTheme.blackTextTheme.headlineMedium,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: viewOrderSummary,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue[50]!)),
                child: Text(
                  'Order Summary',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        buildButton(orderStage),
      ],
    );
  }

  Row buildButton(String orderStage) {
    switch (orderStage) {
      case 'Drop Off Pending':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: displayDropoffQRCode,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue[50]!),
                ),
                child: Text(
                  'Order QR Code',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ),
          ],
        );
      case 'Ready For Collection':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: displayPickupQRCode,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue[50]!),
                ),
                child: Text(
                  'Order QR Code',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ),
          ],
        );
      default:
        return const Row(
          children: [
            SizedBox(height: 10.0),
          ],
        );
    }
  }
}
