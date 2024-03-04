import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_run_test/src/features/screens/order/dropoff_qr_popup.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/screens/order/order_status_screen.dart';

class PaymentFormScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;
  final User? user;
  final LockerSite? collectionSite;

  const PaymentFormScreen({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
    required this.user,
    required this.collectionSite,
  });

  @override
  PaymentFormScreenState createState() => PaymentFormScreenState();
}

class PaymentFormScreenState extends State<PaymentFormScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  // late BuildContext _context;

  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String cardHolderName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   print('State = $state');
  //   if (state == AppLifecycleState.paused) {
  //     final lockerService = Provider.of<LockerService>(_context, listen: false);
  //     lockerService.freeUpLockerCompartment(
  //         widget.lockerSite, widget.compartment);
  //   } else if (state == AppLifecycleState.resumed) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => OrderPage(),
  //       ),
  //     );
  //   }
  // }

  Future<void> confirmOrder() async {
    Map<String, dynamic> newOrder = {
      'orderNumber': widget.order?.orderNumber,
      'user': {
        'userId': widget.user?.id,
        'phoneNumber': widget.user?.phoneNumber,
      },
      'locker': {
        'lockerSiteId': widget.lockerSite?.id,
        'compartmentId': widget.compartment?.id,
        'compartmentNumber': widget.compartment?.compartmentNumber,
      },
      'collectionSite': {
        'lockerSiteId': widget.collectionSite?.id,
      },
      'service': widget.order?.serviceId,
      'orderItems': [],
      'estimatedPrice': widget.order?.estimatedPrice,
    };

    if (widget.order != null) {
      for (var item in widget.order!.orderItems) {
        newOrder['orderItems'].add({
          'name': item.name,
          'unit': item.unit,
          'price': item.price,
          'quantity': item.quantity,
          'cumPrice': item.cumPrice,
        });
      }
    }

    final response = await http.post(
      Uri.parse('${url}orders/confirm-order'),
      body: json.encode(newOrder),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('newOrder')) {
        final dynamic orderData = data['newOrder'];
        final Order order = Order.fromJson(orderData);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DropoffQRScreen(
                lockerSite: widget.lockerSite,
                compartment: widget.compartment,
                order: order);
          },
        ).then((value) => {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return OrderStatusScreen(
                  order: order,
                );
              }), (route) {
                return route.isFirst || route.settings.name == '/order';
              })
            });
      } else {
        print('Response data does not contain saved order.');
      }
    } else {
      print('Failed to confirm order. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Credit / Debit Card',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'CARD NUMBER',
                  hintText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  cardNumber = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'EXPIRY DATE',
                        hintText: 'MM / YY',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        expiryDate = value ?? '';
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        cvv = value ?? '';
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'NAME ON CARD',
                  hintText: 'Name on Card',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                onSaved: (value) {
                  cardHolderName = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.cPrimaryColor),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Your card details will be saved securely.',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'We ensure the security and privacy of your card information. Rest assured, i3wash does not have access to your card details.',
                style: CTextTheme.greyTextTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ElevatedButton(
          onPressed: () async {
            // if (_formKey.currentState!.validate()) {
            //   _formKey.currentState!.save();
            //   // You can now use the card details for processing
            // }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const OrderPage()),
            // );
            await confirmOrder();
          },
          child: Text(
            'Check Out',
            style: CTextTheme.blackTextTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
