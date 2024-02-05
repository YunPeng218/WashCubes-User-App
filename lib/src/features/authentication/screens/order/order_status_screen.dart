import 'package:device_run_test/src/common_widgets/support_alert_widget.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/authentication/screens/order/order_status_detail_widget.dart';
import 'package:device_run_test/src/features/authentication/screens/order/order_status_widget.dart';
import 'package:flutter/material.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatusScreen> {
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
            icon: const Icon(Icons.headset_mic_outlined)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
          child: Column(
            children: [
              //Order Status Progress Icon Column
              OrderStatusWidget(size: size),
              const SizedBox(
                height: 50,
              ),
              //Order Summary & Details
              const OrderStatusDetailWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            'Write a Review',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
