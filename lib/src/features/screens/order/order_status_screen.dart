import 'package:device_run_test/src/common_widgets/support_alert_widget.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_status_detail_widget.dart';
import 'package:device_run_test/src/features/screens/order/order_status_widget.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/screens/order/order_qr_popup.dart';

class OrderStatusScreen extends StatefulWidget {
  final Order order;
  const OrderStatusScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatusScreen> {
  LockerSite? lockerSite;
  LockerSite? collectionSite;
  Service? service;

  void initState() {
    super.initState();
    fetchOrderLockerInfo();
    fetchOrderServiceInfo();
  }

  Future<void> fetchOrderLockerInfo() async {
    try {
      var reqUrl = url +
          'locker/order-locker-sites?dropOffSiteId=${widget.order.lockerDetails?.lockerSiteId}&collectionSiteId=${widget.order.collectionSite?.lockerSiteId}';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('dropOffLocker') &&
            data.containsKey('collectionLocker')) {
          final dynamic dropOffLockerData = data['dropOffLocker'];
          final dynamic collectionLockerData = data['collectionLocker'];
          LockerSite dropOffLocker = LockerSite.fromJson(dropOffLockerData);
          LockerSite collectionLocker =
              LockerSite.fromJson(collectionLockerData);
          setState(() {
            lockerSite = dropOffLocker;
            collectionSite = collectionLocker;
          });
        } else {
          print('No lockers found.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load locker sites');
      }
    } catch (error) {
      print('Error fetching locker sites: $error');
    }
  }

  Future<void> fetchOrderServiceInfo() async {
    try {
      final response =
          await http.get(Uri.parse(url + 'services/${widget.order.serviceId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('service')) {
          final dynamic serviceData = data['service'];
          final Service fetchedService = Service.fromJson(serviceData);
          setState(() {
            service = fetchedService;
          });
        } else {
          print('Response data does not contain services.');
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (error) {
      print('Error fetching services: $error');
    }
  }

  void handleBackButtonPress() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(),
      ),
    );
  }

  void displayOrderQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderQRScreen(
            lockerSite: lockerSite,
            compartment: lockerSite?.compartments.firstWhere((compartment) =>
                compartment.id == widget.order.lockerDetails?.compartmentId),
            order: widget.order);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: handleBackButtonPress,
          ),
          title: Text(
            'Order #${widget.order.orderNumber}',
            style: CTextTheme.blackTextTheme.displaySmall,
          ),
          centerTitle: true,
          //Customer Support Icon Button
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SupportAlertWidget();
                    },
                  );
                },
                icon: const Icon(Icons.headset_mic_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0), //Padding Around Screen
            child: Column(
              children: [
                OrderStatusWidget(
                  order: widget.order,
                ),
                Divider(),
                OrderStatusDetailWidget(
                  order: widget.order,
                  lockerSite: lockerSite,
                  collectionSite: collectionSite,
                  service: service,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
