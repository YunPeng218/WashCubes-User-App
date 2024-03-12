// ignore_for_file: use_build_context_synchronously, must_be_immutable, await_only_futures, deprecated_member_use

import 'package:device_run_test/src/features/screens/order/locker_site_select.dart';
import 'package:device_run_test/src/features/screens/order/select_item_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/config.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/src/features/screens/payment/payment_method.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:device_run_test/src/features/screens/order/collection_site_select.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/common_widgets/cancel_confirm_alert.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';

class OrderSummary extends StatefulWidget {
  final LockerSite? lockerSite;
  LockerCompartment? compartment;
  final String? selectedCompartmentSize;
  final Service? service;
  final Order? order;
  final LockerSite? collectionSite;
  final bool justNavigatedFromGuest;

  OrderSummary({
    super.key,
    required this.lockerSite,
    required this.compartment,
    required this.selectedCompartmentSize,
    required this.service,
    required this.order,
    required this.collectionSite,
    required this.justNavigatedFromGuest,
  });

  @override
  OrderSummaryState createState() => OrderSummaryState();
}

class OrderSummaryState extends State<OrderSummary>
    with WidgetsBindingObserver {
  late String token;
  User? user;

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

  void navigateToPayment() {
    if (widget.collectionSite != null && widget.compartment != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => PaymentScreen(
      //             order: widget.order,
      //             lockerSite: widget.lockerSite,
      //             compartment: widget.compartment!,
      //             user: user,
      //             collectionSite: widget.collectionSite,
      //           )),
      // );
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return PaymentScreen(
          order: widget.order,
          lockerSite: widget.lockerSite,
          compartment: widget.compartment!,
          user: user,
          collectionSite: widget.collectionSite,
          isOrderErrorPayment: false,
        );
      }), (route) {
        return route.isFirst || route.settings.name == '/order';
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          //Alert Dialog PopUp of Order Price Estimation Confirmation
          return CancelConfirmAlert(
              title: 'No Collection Site Selected',
              content: 'Please select a locker site for order collection.',
              onPressedConfirm: () {
                handleSelectCollectionSite();
              },
              cancelButtonText: 'Cancel',
              confirmButtonText: 'Confirm');
        },
      );
    }
  }

  void handleSelectCollectionSite() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectionSiteSelect(
                lockerSite: widget.lockerSite,
                compartment: widget.compartment,
                selectedCompartmentSize: widget.selectedCompartmentSize,
                service: widget.service,
                order: widget.order,
              )),
    );
  }

  Future<void> handleCheckout() async {
    user = await getUserInfo();

    if (user != null) {
      if (widget.compartment != null) {
        navigateToPayment();
      } else {
        LockerCompartment? compartment = await getAllocatedCompartment();
        widget.compartment = compartment;
        if (compartment != null) {
          navigateToPayment();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Compartment Allocation Error',
                  textAlign: TextAlign.center,
                  style: CTextTheme.blackTextTheme.headlineLarge,
                ),
                content: Text(
                  'Sorry, there are no more compartments available for your chosen locker site. Would you like to cancel your order or select another locker site.',
                  textAlign: TextAlign.center,
                  style: CTextTheme.blackTextTheme.headlineSmall,
                ),
                actions: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue[100]!)),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const LockerSiteSelect();
                            }), (route) {
                              return route.isFirst ||
                                  route.settings.name == '/order';
                            });
                          },
                          child: Text(
                            'Yes',
                            style: CTextTheme.blackTextTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red[100]!)),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const OrderPage();
                            }), (route) {
                              return route.isFirst ||
                                  route.settings.name == '/order';
                            });
                          },
                          child: Text(
                            'Cancel Order',
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
        }
      }
    } else {
      if (Provider.of<GuestModeProvider>(context, listen: false).guestMode ==
          true) {
        // PROMPT GUEST SIGN UP
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CancelConfirmAlert(
                title: 'Don\'t Have An Account?',
                content: 'Sign Up to Check Out.',
                onPressedConfirm: handleGuestRedirection,
                cancelButtonText: 'Cancel',
                confirmButtonText: 'Sign Up');
          },
        );
      }
    }
  }

  void handleGuestRedirection() {
    // STORE GUEST'S ORDER
    Provider.of<GuestModeProvider>(context, listen: false)
        .setGuestMadeOrder(true);
    Provider.of<GuestModeProvider>(context, listen: false).setGuestOrderDetails(
        widget.order,
        widget.service,
        widget.lockerSite,
        widget.selectedCompartmentSize,
        widget.collectionSite);
    // REDIRECT TO SIGN IN PAGE
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const WelcomeScreen();
      }), (route) {
        return false;
      });
    });
  }

  Future<LockerCompartment?> getAllocatedCompartment() async {
    try {
      final response = await http.post(
        Uri.parse('${url}orders/select-locker-site'),
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

  Future<bool> handleBackButtonPress() async {
    if (widget.justNavigatedFromGuest == false) {
      print('YO');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CancelConfirmAlert(
              title: 'Modify Order',
              content:
                  'You will be re-directed to the Select Items page. Do you want to proceed?',
              onPressedConfirm: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              cancelButtonText: 'Cancel',
              confirmButtonText: 'Confirm');
        },
      );
      return true;
    } else {
      print('YO');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectItems(
            lockerSite: widget.lockerSite,
            compartment: widget.compartment,
            selectedCompartmentSize: widget.selectedCompartmentSize,
            service: widget.service,
          ),
        ),
      );
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = widget.order?.orderItems;

    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await handleBackButtonPress();
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order Summary',
            style: CTextTheme.blackTextTheme.displaySmall,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: handleBackButtonPress,
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
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  ),
                  Text(
                    'ORDER ID : ${widget.order?.orderNumber}',
                    style: CTextTheme.blackTextTheme.headlineSmall,
                  ),
                ],
              ),
              const Divider(),

              const SizedBox(
                height: 10.0,
              ),
              // Order Items
              Expanded(
                child: ListView.builder(
                  itemCount: orderItems?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blue[50],
                            ),
                            child: Image.asset(
                              'assets/images/select_item/${orderItems![index].name.replaceAll(RegExp(r'[ /]'), '')}.png',
                              width: 80, // Set a fixed width for the image
                              height: 80, // Set a fixed height for the image
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderItems[index].name,
                                style: CTextTheme.blackTextTheme.headlineLarge,
                              ),
                              Text(
                                'RM${orderItems[index].price.toStringAsFixed(2)}/${orderItems[index].unit}',
                                style: CTextTheme.blackTextTheme.headlineSmall,
                              ),
                              Text(
                                'Quantity: ${orderItems[index].quantity}',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                              Text(
                                'RM${orderItems[index].cumPrice.toStringAsFixed(2)}',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Note: Make sure to select a collection site.',
                style: CTextTheme.greyTextTheme.headlineSmall,
              ),
              const SizedBox(height: 5.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Est. Price',
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ),
                  Text(
                    'RM ${widget.order?.estimatedPrice.toStringAsFixed(2)}',
                    style: CTextTheme.blackTextTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Collection Site:',
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  ),
                  Text(
                    widget.collectionSite?.name ?? 'None Selected',
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              (widget.collectionSite == null)
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: handleSelectCollectionSite,
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green[50]!)),
                            child: Text(
                              'Select Collection Site',
                              style: CTextTheme.blackTextTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: handleSelectCollectionSite,
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.yellow[50]!)),
                            child: Text(
                              'Change Collection Site',
                              style: CTextTheme.blackTextTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: handleCheckout,
                      child: Text(
                        'Continue',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
