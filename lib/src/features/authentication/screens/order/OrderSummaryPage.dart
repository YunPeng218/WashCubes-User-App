import 'package:flutter/material.dart';

import '../payment/payment_method.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Laundry Service Summary',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const SummaryPage(),
//     );
//   }
// }

class SummaryPage extends StatelessWidget {
  final double pricePerKg = 6.00;
  final int quantity = 5;
  final double totalPrice = 30.00;

  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            title: Text('WASH & FOLD', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('ORDER ID : #906912'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.local_laundry_service, size: 50), // Replace with actual image/icon
            title: const Text('All Garments'),
            subtitle: Text('RM $pricePerKg/kg'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    // Handle decrement
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Handle increment
                  },
                ),
                Text('RM ${pricePerKg * quantity}'),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Self Pick Up Information'),
          ),
          const ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Time'),
            subtitle: Text('25 NOV, 14:00 - 16:00'),
            trailing: Icon(Icons.navigate_next),
          ),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            subtitle: Text('TAYLOR’S UNIVERSITY'),
            trailing: Icon(Icons.navigate_next),
          ),
          const Divider(),
          const ListTile(
            title: Text('Voucher'),
            trailing: Icon(Icons.navigate_next),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Est. Price', style: TextStyle(fontSize: 18)),
                Text('RM $totalPrice', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                  // Handle continue press
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
