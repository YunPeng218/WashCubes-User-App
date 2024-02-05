import 'package:device_run_test/src/features/authentication/screens/order/order_status_detail_widget.dart';
import 'package:device_run_test/src/features/authentication/screens/order/order_status_screen.dart';
import 'package:flutter/material.dart';
import '../../../../common_widgets/bottom_nav_bar_widget.dart';
import 'create_order_camera.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("i3wash Would Like to Access the Camera"),
                      content: const Text("Allow access to your camera?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Don't Allow"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateOrderCameraPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );

              },
              icon: const Icon(Icons.add),
              label: const Text('Create'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          )

        ],
      ),
      body: ListView(
        children: const <Widget>[
          OrderCard(orderNumber: '131233213', date: 'NOV 23', location: 'Taylor’s University', status: 'Collected by Operator'),
          OrderCard(orderNumber: '131233233', date: 'NOV 24', location: 'Taylor’s University', status: 'Order Error'),
          OrderCard(orderNumber: '131233443', date: 'NOV 26', location: 'Taylor’s University', status: 'In Progress'),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String location;
  final String status;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.date,
    required this.location,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: status == 'Order Error' ? Colors.red.shade100 : Colors.blue.shade100,
      child: ListTile(
        title: Text('Order No: $orderNumber'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Location: $location'),
            Text('Status: $status'),
          ],
        ),
        trailing: Text(date),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderStatusScreen()),
          );
          // Handle the tap if necessary
        },
      ),
    );
  }
}