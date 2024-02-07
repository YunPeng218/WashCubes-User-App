import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../order/order_screen.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Payment Form',
//       home: PaymentFormScreen(),
//     );
//   }
// }

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  _PaymentFormScreenState createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String cardHolderName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit / Debit Card', style: Theme.of(context).textTheme.displaySmall,),
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
              const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.cPrimaryColor),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Your card details will be saved securely.',
                      style: TextStyle(fontSize: 14.0, color: AppColors.cPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0,),
              const Text(
                'We ensure the security and privacy of your card information. Rest assured, i3wash does not have access to your card details.',
                style: TextStyle(color: AppColors.cGreyColor2),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // You can now use the card details for processing
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderPage()),
            );
          },
          child: Text(
            'Check Out',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}