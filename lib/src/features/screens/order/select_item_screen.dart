import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/order/order_est_confirm_popup.dart';
import 'package:flutter/material.dart';

import 'order_summary_screen.dart';
import 'checkout_details_popup.dart';

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
          // title: const Text('Select your item'),
          // centerTitle: true,
          ),
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your item',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: cDefaultSize * 0.5,
            ),
            Text(
              'Select your items and quantity for Total Est. Price.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: cDefaultSize,
            ),
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
                    //item count +-
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: quantities[key]! > 0
                              ? () {
                                  setState(() {
                                    quantities[key] =
                                        (quantities[key] ?? 0) - 1;
                                  });
                                }
                              : null,
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
          ],
        ),
      ),
      //Bottom Bar of Est.Price & Checkout Button
      bottomNavigationBar: SingleChildScrollView(
        child: Container(
          color: AppColors.cBarColor,
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Est. Price',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cWhiteColor),
                  ),
                  Text(
                    'RM ${totalEstPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cWhiteColor),
                  ),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.cWhiteColor),
                ),
                onPressed: () {
                  // Check out action
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //Alert Dialog PopUp of Order Price Estimation Confirmation
                      return AlertDialog(
                        content: Text(
                          "If your order exceeds the estimated price, we'll provide further instructions. Click 'Continue' to agree to our Terms and Conditions and Privacy Policy.",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SummaryPage()),
                                    );
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Check Out',
                  style: TextStyle(color: AppColors.cWhiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
