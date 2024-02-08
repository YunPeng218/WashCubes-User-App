import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/order/order_est_confirm_popup.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/config.dart';

import 'order_summary_screen.dart';
import 'checkout_details_popup.dart';

import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/features/models/order.dart';

class SelectItems extends StatefulWidget {
  final LockerSite lockerSite;
  //final LockerCompartment? compartment;
  final String selectedCompartmentSize;
  final Service service;

  SelectItems(
      {required this.lockerSite,
      required this.selectedCompartmentSize,
      required this.service});

  @override
  _SelectItemsState createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
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

  Map<String, int> selectedQuantity = {};

  // UPDATE ESTIMATED PRICE
  double updateEstimatedPrice() {
    double estimatedPrice = 0.0;
    for (var item in widget.service.items) {
      int quantity = selectedQuantity[item.id] ?? 0;
      estimatedPrice += item.price * quantity;
    }
    return estimatedPrice;
  }

  // SEND ORDER DETAILS TO SERVER
  Future<void> sendOrderToServer() async {
    Navigator.of(context).pop();

    try {
      Map<String, dynamic> orderDetails = {
        // 'lockerSiteId': widget.lockerSite.id,
        // 'compartmentId': widget.compartment?.id,
        // 'compartmentNumber': widget.compartment?.compartmentNumber,
        'serviceId': widget.service.id,
        'orderItems': [],
      };

      for (var item in widget.service.items) {
        int quantity = selectedQuantity[item.id] ?? 0;
        if (quantity > 0) {
          orderDetails['orderItems']
              .add({'itemId': item.id, 'quantity': quantity});
        }
      }

      final response = await http.post(
        Uri.parse(url + 'orders/create-order'),
        body: json.encode(orderDetails),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Handle the success scenario, e.g., navigate to the next screen
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('newOrder')) {
          final dynamic orderData = data['newOrder'];
          final Order order = Order.fromJson(orderData);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderSummary(
                  lockerSite: widget.lockerSite,
                  // compartment: widget.compartment,
                  selectedCompartmentSize: widget.selectedCompartmentSize,
                  service: widget.service,
                  order: order),
            ),
          );
        } else {
          print('Response data does not contain services.');
        }
        // Navigator.push(...);
      } else {
        print(
            'Failed to send order details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending order details: $error');
    }
  }

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
              style: CTextTheme.blueTextTheme.displayLarge,
            ),
            const SizedBox(
              height: cDefaultSize * 0.5,
            ),
            Text(
              'Select your items and quantity for Total Est. Price.',
              style: CTextTheme.greyTextTheme.headlineSmall,
            ),
            const SizedBox(
              height: cDefaultSize,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.service.items.length,
                itemBuilder: ((context, index) {
                  ServiceItem item = widget.service.items[index];
                  return ListTile(
                    leading: Image.asset(
                      'assets/images/select_item/top.png', // Use the image asset path from the map
                      width: 24, // Set the desired width
                      height: 24, // Set the desired height
                    ), // Replace with your own icons
                    title: Text(item.name, style: CTextTheme.blackTextTheme.headlineMedium,),
                    subtitle: Text(
                        'RM ${item.price.toStringAsFixed(2)}/${item.unit}', style: CTextTheme.blackTextTheme.headlineMedium,),
                    trailing: QuantitySelector(
                        initialQuantity: selectedQuantity[item.id] ?? 0,
                        onChanged: (quantity) {
                          setState(() {
                            // Update the selected quantities map
                            selectedQuantity[item.id] = quantity;
                          });
                        }),
                  );
                }),
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
                    'RM ${updateEstimatedPrice().toStringAsFixed(2)}',
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
                  bool noItemSelected =
                      selectedQuantity.values.every((value) => value == 0);

                  if (noItemSelected) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('OOPS! No items selected.', style: CTextTheme.blackTextTheme.headlineMedium,),
                          content: Text('Please select some items to procced.', style: CTextTheme.blackTextTheme.headlineMedium,),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK', style: CTextTheme.blackTextTheme.headlineMedium,),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //Alert Dialog PopUp of Order Price Estimation Confirmation
                      return AlertDialog(
                        content: Text(
                          "If your order exceeds the estimated price, we'll provide further instructions. Click 'Continue' to agree to our Terms and Conditions and Privacy Policy.",
                          style: CTextTheme.blackTextTheme.headlineSmall,
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
                                    style: CTextTheme.blackTextTheme.headlineSmall,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await sendOrderToServer();
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: CTextTheme.blackTextTheme.headlineSmall,
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

// QUANTITY SELECTOR
class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onChanged;

  QuantitySelector({required this.initialQuantity, required this.onChanged});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (quantity > 0) {
              setState(() {
                quantity--;
                widget.onChanged(quantity);
              });
            }
          },
        ),
        Text('${quantity}', style: CTextTheme.blackTextTheme.headlineSmall,),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              quantity++;
              widget.onChanged(quantity);
            });
          },
        ),
      ],
    );
  }
}
