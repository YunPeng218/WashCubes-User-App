import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/order/checkout_details_popup.dart';
import 'package:device_run_test/src/features/screens/order/select_item_screen.dart';
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
        title: Text(
          'Summary',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            showDialog(
              context: context,
              builder: (BuildContext context) {
                //Alert Dialog PopUp of Backtrack Confirmation
                return AlertDialog(
                  content: Text(
                    "Are you sure you want to cancel the order?",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  actions: [
                    Row(
                      children: [
                        //Confirm Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectYourItemPage()),
                              );
                            },
                            child: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        //Back Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Back',
                              style: Theme.of(context).textTheme.headlineSmall,
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
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Order Type & ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WASH & FOLD',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'ORDER ID : #906912',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              //All Garments Row
              Row(
                children: [
                  Image.asset(cAllGarments),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Garments',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'RM $pricePerKg/kg',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  // Handle decrement
                                  quantity - 1;
                                },
                              ),
                              Text(
                                '$quantity',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  // Handle increment
                                  quantity + 1;
                                },
                              ),
                            ],
                          ),
                          Text(
                            'RM ${pricePerKg * quantity}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Self Pick Up Information',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  'Time',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                trailing: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CheckoutDetailPopUp();
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '25 NOV, 14:00 - 16:00',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: AppColors.cBlackColor,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(
                  'Location',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TAYLOR’S UNIVERSITY',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: AppColors.cBlackColor,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Voucher',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'APPLY',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: AppColors.cBlackColor,
                      ),
                    ],
                  ),
                ),
              ),
              // const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Est. Price',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      'RM $totalPrice',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      //Continue Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentScreen(totalPrice: totalPrice)),
            );
          },
          child: Text(
            'Continue',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
