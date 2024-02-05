import 'package:flutter/material.dart';

import 'card_input.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bank Selection',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: BankSelectionScreen(),
//     );
//   }
// }

class BankSelectionScreen extends StatelessWidget {
  final List<Bank> banks = [
    Bank(name: 'Maybank', logoPath: 'assets/maybank_logo.png'),
    Bank(name: 'CIMB', logoPath: 'assets/cimb_logo.png'),
    Bank(name: 'Public Bank', logoPath: 'assets/publicbank_logo.png'),
    Bank(name: 'Hong Leong Bank', logoPath: 'assets/hongleong_logo.png'),
    // ... add other banks here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Option'),
      ),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(banks[index].logoPath),
            ),
            title: Text(banks[index].name),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle the bank selection
              print('Selected: ${banks[index].name}');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentFormScreen()),
              );
            },
          );
        },
      ),
    );
  }
}

class Bank {
  final String name;
  final String logoPath;

  Bank({required this.name, required this.logoPath});
}