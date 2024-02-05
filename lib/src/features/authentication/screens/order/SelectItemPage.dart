import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

import 'OrderSummaryPage.dart';
import 'checkout_details_popup.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: SelectYourItemPage(),
//     );
//   }
// }

class SelectYourItemPage extends StatefulWidget {
  const SelectYourItemPage({super.key});

  @override
  _SelectYourItemPageState createState() => _SelectYourItemPageState();
}

class _SelectYourItemPageState extends State<SelectYourItemPage> {
  Map<String, double> prices = {
    'Top': 6.0,
    'Bottom': 8.0,
    'Curtain': 8.0,
    'Comforter Cover / Bedsheet': 6.0,
  };
  Map<String, int> quantities = {
    'Top': 0,
    'Bottom': 0,
    'Curtain': 0,
    'Comforter Cover / Bedsheet': 0,
  };

  double get totalEstPrice => quantities.entries
      .map((e) => e.value * prices[e.key]!)
      .reduce((value, element) => value + element);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button
          },
        ),
        title: const Text('Select your item'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: prices.length,
              itemBuilder: (context, index) {
                String key = prices.keys.elementAt(index);
                return ListTile(
                  leading: Image.asset(
                    itemImages[key]!, // Use the image asset path from the map
                    width: 24, // Set the desired width
                    height: 24, // Set the desired height
                  ), // Replace with your own icons
                  title: Text(key),
                  subtitle: Text('RM ${prices[key]}/kg'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantities[key]! > 0 ? () {
                          setState(() {
                            quantities[key] = (quantities[key] ?? 0) - 1;
                          });
                        } : null,
                      ),
                      Text('${quantities[key]}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantities[key] = (quantities[key] ?? 0) + 1;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Est. Price',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'RM ${totalEstPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Text('Check Out'),
              onPressed: () {
                // Check out action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SummaryPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
