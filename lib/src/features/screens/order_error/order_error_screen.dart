// ignore_for_file: deprecated_member_use

import 'package:device_run_test/src/common_widgets/support_alert_widget.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/screens/order/dropoff_qr_popup.dart';
import 'package:device_run_test/src/constants/sizes.dart';

class OrderErrorScreen extends StatefulWidget {
  final Order order;
  const OrderErrorScreen({super.key, required this.order});

  @override
  State<OrderErrorScreen> createState() => OrderErrorState();
}

class OrderErrorState extends State<OrderErrorScreen> {
  LockerSite? lockerSite;
  LockerSite? collectionSite;
  Service? service;

  @override
  void initState() {
    super.initState();
    fetchOrderLockerInfo();
    fetchOrderServiceInfo();
  }

  Future<void> fetchOrderLockerInfo() async {
    try {
      var reqUrl =
          '${url}locker/order-locker-sites?dropOffSiteId=${widget.order.lockerDetails?.lockerSiteId}&collectionSiteId=${widget.order.collectionSite?.lockerSiteId}';
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
          await http.get(Uri.parse('${url}services/${widget.order.serviceId}'));

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

  bool handleBackButtonPress() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const OrderPage();
    }), (route) {
      return false;
    });
    return true;
  }

  void displayOrderQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DropoffQRScreen(
            lockerSite: lockerSite,
            compartment: lockerSite?.compartments.firstWhere((compartment) =>
                compartment.id == widget.order.lockerDetails?.compartmentId),
            order: widget.order);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double actualPrice = 42.00;
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = handleBackButtonPress();
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              handleBackButtonPress();
            },
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
            padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
            child: Column(
              children: [
                //Order Status Progress Icon Column
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service?.name.toUpperCase() ?? 'Loading...',
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(
                              color: AppColors
                                  .cBlueColor3)), // Set your desired color here
                        ),
                        child: Text('Proof',
                            style: CTextTheme.blueTextTheme.headlineSmall)),
                  ],
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget
                        .order.orderItems.length, // Use null-aware operator
                    itemBuilder: ((context, index) {
                      OrderItem? item = widget.order.orderItems[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.blue[50],
                                ),
                                child: Image.asset(
                                  'assets/images/select_item/${item.name.replaceAll(RegExp(r'[ /]'), '')}.png', // Use the image asset path from the map
                                  width: 80, // Set the desired width
                                  height: 80, // Set the desired height
                                ),
                              ),
                              const SizedBox(width: 25.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: CTextTheme
                                          .blackTextTheme.headlineLarge,
                                    ),
                                    Text(
                                      '${item.quantity} ${item.unit.toUpperCase()}',
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'RM ${item.cumPrice.toStringAsFixed(2)}',
                                          style: CTextTheme
                                              .blackTextTheme.headlineMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                        ],
                      );
                    }),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment Information',
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
                        'Actual Price:',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      Text(
                        'RM ${actualPrice.toStringAsFixed(2)}',
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
                        'Estimated Price:',
                        style: CTextTheme.greyTextTheme.headlineMedium,
                      ),
                      Text(
                        'RM ${widget.order.estimatedPrice.toStringAsFixed(2)}',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Payable:',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      Text(
                        'RM ${(actualPrice - widget.order.estimatedPrice).toStringAsFixed(2)}',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red[50]!)),
                        child: Text(
                          'Cancel Order',
                          style: CTextTheme.blackTextTheme.headlineMedium,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue[50]!)),
                        child: Text(
                          'Pay Balance',
                          style: CTextTheme.blackTextTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
