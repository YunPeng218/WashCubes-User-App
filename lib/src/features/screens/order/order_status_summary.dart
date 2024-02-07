import 'package:device_run_test/src/common_widgets/support_alert_widget.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/order/order_status_detail_widget.dart';
import 'package:flutter/material.dart';

class OrderStatusSummaryScreen extends StatefulWidget {
  const OrderStatusSummaryScreen({super.key});

  @override
  State<OrderStatusSummaryScreen> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderStatusSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //Top Page Bar
      appBar: AppBar(
        //Order Number
        title: Text(
          'Order #000001',
          style: Theme.of(context).textTheme.displaySmall,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(cAllGarments, scale: 1.2),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: size.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NOV 23',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            'Reserved',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //Order Summary & Details
              const OrderStatusDetailWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
