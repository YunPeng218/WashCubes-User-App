import 'package:device_run_test/src/constants/image_strings.dart';
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
    Bank(name: 'Maybank', logoPath: cMaybank),
    Bank(name: 'CIMB', logoPath: cCIMB),
    Bank(name: 'Public Bank', logoPath: cPublicBank),
    Bank(name: 'Hong Leong Bank', logoPath: cHongLeongBank),
    // ... add other banks here
  ];

  BankSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Option', style: Theme.of(context).textTheme.displaySmall,),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(banks[index].logoPath),
            ),
            title: Text(banks[index].name, style: Theme.of(context).textTheme.headlineMedium,),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle the bank selection
              // print('Selected: ${banks[index].name}');
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