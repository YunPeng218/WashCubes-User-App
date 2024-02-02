import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Service Summary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SummaryPage(),
    );
  }
}

class SummaryPage extends StatelessWidget {
  final double pricePerKg = 6.00;
  final int quantity = 5;
  final double totalPrice = 30.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('WASH & FOLD', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('ORDER ID : #906912'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_laundry_service, size: 50), // Replace with actual image/icon
            title: Text('All Garments'),
            subtitle: Text('RM $pricePerKg/kg'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    // Handle decrement
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Handle increment
                  },
                ),
                Text('RM ${pricePerKg * quantity}'),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Self Pick Up Information'),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Time'),
            subtitle: Text('25 NOV, 14:00 - 16:00'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            subtitle: Text('TAYLOR’S UNIVERSITY'),
            trailing: Icon(Icons.navigate_next),
          ),
          Divider(),
          ListTile(
            title: Text('Voucher'),
            trailing: Icon(Icons.navigate_next),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Est. Price', style: TextStyle(fontSize: 18)),
                Text('RM $totalPrice', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Continue'),
                onPressed: () {
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
