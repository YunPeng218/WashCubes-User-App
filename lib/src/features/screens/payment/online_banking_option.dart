import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

import 'card_input.dart';

import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/user.dart';

class BankSelectionScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;
  final User? user;

  const BankSelectionScreen(
      {super.key,
      required this.order,
      required this.lockerSite,
      required this.compartment,
      required this.user});

  @override
  _BankSelectionScreenState createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  final List<Bank> banks = [
    Bank(name: 'Maybank', logoPath: cMaybank),
    Bank(name: 'CIMB', logoPath: cCIMB),
    Bank(name: 'Public Bank', logoPath: cPublicBank),
    Bank(name: 'Hong Leong Bank', logoPath: cHongLeongBank),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Option',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(banks[index].logoPath),
            ),
            title: Text(
              banks[index].name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentFormScreen(
                          order: widget.order,
                          lockerSite: widget.lockerSite,
                          compartment: widget.compartment,
                          user: widget.user,
                        )),
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
