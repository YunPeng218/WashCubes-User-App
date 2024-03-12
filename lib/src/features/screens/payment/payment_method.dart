// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/common_widgets/cancel_confirm_alert.dart';
import 'online_banking_option.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/user.dart';

class PaymentScreen extends StatefulWidget {
  final Order? order;
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;
  final User? user;
  final LockerSite? collectionSite;
  final bool isOrderErrorPayment;

  const PaymentScreen({
    super.key,
    required this.order,
    required this.lockerSite,
    required this.compartment,
    required this.user,
    required this.collectionSite,
    required this.isOrderErrorPayment,
  });
  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {
  static const maxSeconds = 10 * 60;
  int seconds = maxSeconds;
  // late BuildContext _context;

  //Payment Timer
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
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
    WidgetsBinding.instance.addObserver(this);
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void handlePaymentMethodSelection() {
    if (widget.isOrderErrorPayment == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BankSelectionScreen(
                  order: widget.order,
                  lockerSite: widget.lockerSite,
                  compartment: widget.compartment,
                  user: widget.user,
                  collectionSite: widget.collectionSite,
                  isOrderErrorPayment: false,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BankSelectionScreen(
                  order: widget.order,
                  lockerSite: widget.lockerSite,
                  compartment: widget.compartment,
                  user: widget.user,
                  collectionSite: widget.collectionSite,
                  isOrderErrorPayment: true,
                )),
      );
    }
  }

  Future<bool> handleBackButtonPress() async {
    if (widget.isOrderErrorPayment == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          //Alert Dialog PopUp of Order Price Estimation Confirmation
          return CancelConfirmAlert(
              title: 'Changed Your Mind?',
              content:
                  'Your order will be cancelled and you will be redirected to the Order Page. Do you want to proceed?',
              onPressedConfirm: releaseAssignedCompartment,
              cancelButtonText: 'Cancel',
              confirmButtonText: 'Confirm');
        },
      );
      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          //Alert Dialog PopUp of Order Price Estimation Confirmation
          return CancelConfirmAlert(
              title: 'Changed Your Mind?',
              content: 'Your will be redirected to the Order Error page.',
              onPressedConfirm: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              cancelButtonText: 'Cancel',
              confirmButtonText: 'Confirm');
        },
      );
      return true;
    }
  }

  Future<void> releaseAssignedCompartment() async {
    Navigator.pop(context);

    Map<String, dynamic> releaseComaprtment = {
      'lockerSiteId': widget.lockerSite?.id,
      'compartmentId': widget.compartment?.id,
    };

    await http.post(
      Uri.parse('${url}locker/release-compartment'),
      body: json.encode(releaseComaprtment),
      headers: {'Content-Type': 'application/json'},
    );

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const OrderPage();
    }), (route) {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _context = context;
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await handleBackButtonPress();
        return shouldPop;
      },
      child: Scaffold(
        //Back Button & Countdown Timer
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await handleBackButtonPress();
            },
          ),
          actions: <Widget>[
            OutlinedButton(
                onPressed: () {},
                child: Text(
                  '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                  style: CTextTheme.blackTextTheme.headlineSmall,
                )),
            const SizedBox(width: 20),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Total Cost & Order Number
              const SizedBox(
                height: 40.0,
              ),
              widget.isOrderErrorPayment
                  ? Text(
                      'RM ${((widget.order?.finalPrice ?? 0.0) - (widget.order?.estimatedPrice ?? 0.0)).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 50.0, color: AppColors.cBlueColor3),
                    )
                  : Text(
                      'RM ${widget.order?.estimatedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 50.0, color: AppColors.cBlueColor3),
                    ),
              Text(
                'Order Number: ${widget.order?.orderNumber}',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              const SizedBox(
                height: 60.0,
              ),
              Text(
                'Please select your payment method',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              const SizedBox(
                height: 30.0,
              ),
              //List of Payment Method
              ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: Text(
                  'Online Banking',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                trailing: const Icon(Icons.navigate_next),
                onTap: () {
                  handlePaymentMethodSelection();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(
                  'E-Wallet',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                trailing: const Icon(Icons.navigate_next),
                onTap: () {
                  handlePaymentMethodSelection();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(
                  'Credit / Debit Card',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
                trailing: const Icon(Icons.navigate_next),
                onTap: () {
                  handlePaymentMethodSelection();
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
