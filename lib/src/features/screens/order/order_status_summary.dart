import 'package:device_run_test/src/common_widgets/support_alert_widget.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';

class OrderStatusSummaryScreen extends StatefulWidget {
  final Order order;
  final Service? service;
  final LockerSite? dropOffSite;
  final LockerSite? collectionSite;
  const OrderStatusSummaryScreen({
    super.key,
    required this.order,
    required this.service,
    required this.dropOffSite,
    required this.collectionSite,
  });

  @override
  State<OrderStatusSummaryScreen> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderStatusSummaryScreen> {
  void handleBackButtonPress() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => OrderStatusScreen(
    //             order: widget.order,
    //           )),
    // );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.service?.name.toUpperCase() ?? 'Loading...',
                    style: CTextTheme.blueTextTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      widget.order.orderItems.length, // Use null-aware operator
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
                                    style:
                                        CTextTheme.blackTextTheme.headlineLarge,
                                  ),
                                  Text(
                                    '${item.quantity} ${item.unit.toUpperCase()}',
                                    style:
                                        CTextTheme.greyTextTheme.headlineMedium,
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
              Column(
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'LOCKER INFORMATION',
                        style: CTextTheme.blueTextTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Drop Off:',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                        ],
                      ),
                      Text(
                        widget.dropOffSite?.name ?? 'Loading...',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Compartment:',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      Text(
                        widget.order.lockerDetails?.compartmentNumber ?? 'N/A',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collection:',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      Text(
                        widget.collectionSite?.name ?? 'Loading...',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
              const Divider(),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Est. Price:',
                    style: CTextTheme.blueTextTheme.displayMedium,
                  ),
                  Text(
                    'RM ${widget.order.estimatedPrice.toStringAsFixed(2)}',
                    style: CTextTheme.blueTextTheme.displayMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: handleBackButtonPress,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue[50]!)),
                      child: Text(
                        'Back',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
