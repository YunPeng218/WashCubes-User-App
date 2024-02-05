import 'dart:async';
import 'package:flutter/material.dart';

import 'online_banking_option.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Payment Screen',
//       home: PaymentScreen(),
//     );
//   }
// }

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const maxSeconds = 10 * 60;
  int seconds = maxSeconds;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('RM 25.00'),
        actions: <Widget>[
          Center(child: Text('${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}')),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Online Banking'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              // Handle Online Banking tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BankSelectionScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('E-Wallet'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              // Handle E-Wallet tap
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Credit / Debit Card'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              // Handle Credit / Debit Card tap
            },
          ),
        ],
      ),
    );
  }
}