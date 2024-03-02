import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'card_input.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/user.dart';
// import 'package:provider/provider.dart';
// import 'package:device_run_test/src/utilities/locker_service.dart';
// import 'package:device_run_test/src/features/screens/order/order_screen.dart';

class BankSelectionScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;
  final User? user;
  final LockerSite? collectionSite;

  const BankSelectionScreen({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
    required this.user,
    required this.collectionSite,
  });

  @override
  BankSelectionScreenState createState() => BankSelectionScreenState();
}

class BankSelectionScreenState extends State<BankSelectionScreen>
    with WidgetsBindingObserver {
  // late BuildContext _context;

  final List<Bank> banks = [
    Bank(name: 'Maybank', logoPath: cMaybank),
    Bank(name: 'CIMB', logoPath: cCIMB),
    Bank(name: 'Public Bank', logoPath: cPublicBank),
    Bank(name: 'Hong Leong Bank', logoPath: cHongLeongBank),
  ];

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

  @override
  Widget build(BuildContext context) {
    // _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Option',
          style: CTextTheme.blackTextTheme.displaySmall,
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
              style: CTextTheme.blackTextTheme.headlineMedium,
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
                          collectionSite: widget.collectionSite,
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
