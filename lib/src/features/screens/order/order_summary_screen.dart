import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/config.dart';
import 'package:flutter/scheduler.dart';

import '../payment/payment_method.dart';
import '../home/home_screen.dart';

import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/user.dart';

class OrderSummary extends StatefulWidget {
  final LockerSite? lockerSite;
  final String? selectedCompartmentSize;
  final Service? service;
  final Order? order;

  OrderSummary({
    required this.lockerSite,
    required this.selectedCompartmentSize,
    required this.service,
    required this.order,
  });

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final double pricePerKg = 6.00;
  final int quantity = 5;
  final double totalPrice = 30.00;

  late String token;
  User? user;
  LockerCompartment? compartment;

  Future<User?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = (await prefs.getString('token')) ?? 'No token';
    if (token == 'No token') {
      return null;
    } else {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      String userId = jwtDecodedToken['_id'];
      int phoneNumber = jwtDecodedToken['phoneNumber'];
      User user = User(id: userId, phoneNumber: phoneNumber);
      return user;
    }
  }

  Future<void> handlePaymentNavigation() async {
    user = await getUserInfo();
    print(user?.id);
    print(user?.phoneNumber);

    if (user != null) {
      compartment = await getAllocatedCompartment();
      print(compartment?.id);
      print(compartment?.size);

      if (compartment != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentScreen(
                    order: widget.order,
                    lockerSite: widget.lockerSite,
                    compartment: compartment,
                    user: user,
                  )),
        );
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry, no compartments available.', style: CTextTheme.blackTextTheme.headlineMedium,),
              content: Text(
                  'All compartments are occupied. Would you like to cancel your order or select another locker site.',
                  style: CTextTheme.blackTextTheme.headlineMedium,),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text('Cancel Order', style: CTextTheme.blackTextTheme.headlineMedium,),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SelectLockerSite()));
                  },
                  child: Text('Select', style: CTextTheme.blackTextTheme.headlineMedium,),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Ask guest to register
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       Provider.of<GuestVisitedOrderSummaryProvider>(context,
        //               listen: false)
        //           .setGuestVisitedOrderSummary(true);
        //       return Registration(
        //         lockerSite: widget.lockerSite,
        //         selectedCompartmentSize: widget.selectedCompartmentSize,
        //         service: widget.service,
        //         order: widget.order,
        //       );
        //     },
        //   ),
        // );
      });
    }
  }

  Future<LockerCompartment?> getAllocatedCompartment() async {
    try {
      final response = await http.post(
        Uri.parse(url + 'orders/select-locker-site'),
        body: json.encode({
          'selectedLockerSiteId': widget.lockerSite?.id,
          'selectedSize': widget.selectedCompartmentSize,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey('allocatedCompartment')) {
          final dynamic compartmentData = data['allocatedCompartment'];
          return LockerCompartment.fromJson(compartmentData);
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        return null;
      }
    } catch (error) {
      print('Error sending selected locker site: $error');
    }
    return null;
  }

  Future<void> cancelOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(token: prefs.getString('token'))));
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = widget.order?.orderItems;

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
                            onPressed: () async {
                              await cancelOrder();
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
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Type & Order ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.service?.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'ORDER ID : ${widget.order?.orderNumber}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            // Order Items
            Expanded(
                child: ListView.builder(
              itemCount: orderItems?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
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
                              '${orderItems![index].name}',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Text(
                              'RM${orderItems[index].price.toStringAsFixed(2)}/${orderItems[index].unit}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    // IconButton(
                                    //   icon: const Icon(Icons.remove),
                                    //   onPressed: () {
                                    //     // Handle decrement
                                    //     quantity - 1;
                                    //   },
                                    // ),
                                    Text(
                                      'Quantity: ${orderItems[index].quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.add),
                                    //   onPressed: () {
                                    //     // Handle increment
                                    //     quantity + 1;
                                    //   },
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              'RM${orderItems[index].cumPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                );
              },
            )),

            // const Divider(),
            // ListTile(
            //   title: Text(
            //     'Self Pick Up Information',
            //     style: Theme.of(context).textTheme.headlineMedium,
            //   ),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.access_time),
            //   title: Text(
            //     'Time',
            //     style: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   trailing: TextButton(
            //     onPressed: () {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return const CheckoutDetailPopUp();
            //         },
            //       );
            //     },
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Text(
            //           '25 NOV, 14:00 - 16:00',
            //           style: Theme.of(context).textTheme.labelLarge,
            //         ),
            //         const Icon(
            //           Icons.navigate_next,
            //           color: AppColors.cBlackColor,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.location_on),
            //   title: Text(
            //     'Location',
            //     style: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   trailing: TextButton(
            //     onPressed: () {},
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Text(
            //           'TAYLOR’S UNIVERSITY',
            //           style: Theme.of(context).textTheme.labelLarge,
            //         ),
            //         const Icon(
            //           Icons.navigate_next,
            //           color: AppColors.cBlackColor,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const Divider(),
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
                    'RM ${widget.order?.estimatedPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //Continue Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ElevatedButton(
          onPressed: () async {
            await handlePaymentNavigation();
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
