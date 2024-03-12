// ignore_for_file: deprecated_member_use

import 'package:device_run_test/src/common_widgets/support_alert_widget.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/screens/order/dropoff_qr_popup.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:device_run_test/src/features/screens/payment/payment_method.dart';
import 'package:device_run_test/src/features/screens/order_error/order_error_return_screen.dart';

class OrderErrorScreen extends StatefulWidget {
  final Order order;
  const OrderErrorScreen({super.key, required this.order});

  @override
  State<OrderErrorScreen> createState() => OrderErrorState();
}

class OrderErrorState extends State<OrderErrorScreen> {
  LockerSite? lockerSite;
  LockerSite? collectionSite;
  Service? service;
  final PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchOrderLockerInfo();
    fetchOrderServiceInfo();
    print(widget.order.oldOrderItems);
    print(widget.order.orderItems);
  }

  Future<void> fetchOrderLockerInfo() async {
    try {
      var reqUrl =
          '${url}locker/order-locker-sites?dropOffSiteId=${widget.order.lockerDetails?.lockerSiteId}&collectionSiteId=${widget.order.collectionSite?.lockerSiteId}';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('dropOffLocker') &&
            data.containsKey('collectionLocker')) {
          final dynamic dropOffLockerData = data['dropOffLocker'];
          final dynamic collectionLockerData = data['collectionLocker'];
          LockerSite dropOffLocker = LockerSite.fromJson(dropOffLockerData);
          LockerSite collectionLocker =
              LockerSite.fromJson(collectionLockerData);
          setState(() {
            lockerSite = dropOffLocker;
            collectionSite = collectionLocker;
          });
        } else {
          print('No lockers found.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load locker sites');
      }
    } catch (error) {
      print('Error fetching locker sites: $error');
    }
  }

  Future<void> fetchOrderServiceInfo() async {
    try {
      final response =
          await http.get(Uri.parse('${url}services/${widget.order.serviceId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('service')) {
          final dynamic serviceData = data['service'];
          final Service fetchedService = Service.fromJson(serviceData);
          setState(() {
            service = fetchedService;
          });
        } else {
          print('Response data does not contain services.');
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (error) {
      print('Error fetching services: $error');
    }
  }

  bool handleBackButtonPress() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const OrderPage();
    }), (route) {
      return false;
    });
    return true;
  }

  void displayOrderQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DropoffQRScreen(
            lockerSite: lockerSite,
            compartment: lockerSite?.compartments.firstWhere((compartment) =>
                compartment.id == widget.order.lockerDetails?.compartmentId),
            order: widget.order);
      },
    );
  }

  void cancelOrder() async {
    Map<String, dynamic> data = {
      'orderId': widget.order.id,
    };

    final response = await http.post(
      Uri.parse('${url}orders/order-error/return'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Order Return Initiated',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            content: Text(
              'The return process for Order #${widget.order.orderNumber} has been initiated.',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineSmall,
            ),
            actions: <Widget>[
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: CTextTheme.blackTextTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ).then((value) => {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return OrderErrorStatusScreen(
                order: widget.order,
              );
            }), (route) {
              return route.isFirst || route.settings.name == '/order';
            })
          });
    } else {
      print('Failed to confirm order. Status code: ${response.statusCode}');
    }
  }

  void payBalance() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PaymentScreen(
                order: widget.order,
                lockerSite: null,
                compartment: null,
                user: null,
                collectionSite: null,
                isOrderErrorPayment: true,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = handleBackButtonPress();
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              handleBackButtonPress();
            },
          ),
          title: Text(
            'Order #${widget.order.orderNumber}',
            style: CTextTheme.blackTextTheme.displaySmall,
          ),
          centerTitle: true,
          //Customer Support Icon Button
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SupportAlertWidget();
                    },
                  );
                },
                icon: const Icon(Icons.headset_mic_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(cDefaultSize), //Padding Around Screen
            child: Column(
              children: [
                //Order Status Progress Icon Column
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service?.name.toUpperCase() ?? 'Loading...',
                      style: CTextTheme.blackTextTheme.headlineLarge,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ImageDisplayDialog(
                                imageUrls: widget
                                    .order.orderStage?.orderError.proofPicUrl,
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(
                              color: AppColors
                                  .cBlueColor3)), // Set your desired color here
                        ),
                        child: Text('Proof',
                            style: CTextTheme.blueTextTheme.headlineSmall)),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 320,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 2,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page.toDouble();
                      });
                    },
                    itemBuilder: ((context, index) {
                      if (index == 0) {
                        return buildNewOrderItemsList();
                      } else {
                        return buildOldOrderItemsList();
                      }
                    }),
                  ),
                ),
                DotsIndicator(
                  dotsCount: 2, // Number of pages
                  position: _currentPage.floor(),
                  decorator: const DotsDecorator(
                    color: Colors.grey, // Inactive dot color
                    activeColor: Colors.blue, // Active dot color
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment Information',
                    style: CTextTheme.blueTextTheme.headlineLarge,
                  ),
                ),
                //Order Creation Detail Row
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Final Price:',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      Text(
                        'RM ${widget.order.finalPrice.toStringAsFixed(2)}',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Price:',
                        style: CTextTheme.greyTextTheme.headlineMedium,
                      ),
                      Text(
                        'RM ${widget.order.estimatedPrice.toStringAsFixed(2)}',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Payable:',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      ),
                      Text(
                        'RM ${(widget.order.finalPrice - widget.order.estimatedPrice).toStringAsFixed(2)}',
                        style: CTextTheme.blackTextTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Refund Order',
                                  textAlign: TextAlign.center,
                                  style:
                                      CTextTheme.blackTextTheme.headlineLarge,
                                ),
                                content: Text(
                                  'A refund will be processed to your original payment method and your laundry will be returned to your collection site. A RM5.00 admin fee will be charged.',
                                  textAlign: TextAlign.center,
                                  style:
                                      CTextTheme.blackTextTheme.headlineSmall,
                                ),
                                actions: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red[100]!),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: CTextTheme
                                                .blackTextTheme.headlineSmall,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: cancelOrder,
                                          child: Text(
                                            'Confirm',
                                            style: CTextTheme
                                                .blackTextTheme.headlineSmall,
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red[50]!)),
                        child: Text(
                          'Cancel Order',
                          style: CTextTheme.blackTextTheme.headlineMedium,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: payBalance,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue[50]!)),
                        child: Text(
                          'Pay Balance',
                          style: CTextTheme.blackTextTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOldOrderItemsList() {
    return ListView.builder(
      itemCount: 2 + (widget.order.oldOrderItems.length), // 2 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Original Order Items',
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
          );
        } else if (index == 1) {
          return const SizedBox(height: 20.0);
        } else {
          OrderItem? item = widget.order.oldOrderItems[index - 2];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue[50],
                      ),
                      child: Image.asset(
                        'assets/images/select_item/${item.name.replaceAll(RegExp(r'[ /]'), '')}.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: 25.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: CTextTheme.blackTextTheme.headlineLarge,
                          ),
                          Text(
                            '${item.quantity} ${item.unit.toUpperCase()}',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'RM ${item.cumPrice.toStringAsFixed(2)}',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildNewOrderItemsList() {
    return ListView.builder(
      itemCount: 2 + widget.order.orderItems.length, // 2 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Updated Order Items',
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
          );
        } else if (index == 1) {
          return const SizedBox(height: 20.0);
        } else {
          OrderItem? item = widget.order.orderItems[index - 2];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue[50],
                      ),
                      child: Image.asset(
                        'assets/images/select_item/${item.name.replaceAll(RegExp(r'[ /]'), '')}.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: 25.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: CTextTheme.blackTextTheme.headlineLarge,
                          ),
                          Text(
                            '${item.quantity} ${item.unit.toUpperCase()}',
                            style: CTextTheme.greyTextTheme.headlineMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'RM ${item.cumPrice.toStringAsFixed(2)}',
                                style: CTextTheme.blackTextTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          );
        }
      },
    );
  }
}

class ImageDisplayDialog extends StatefulWidget {
  final List<String>? imageUrls;

  const ImageDisplayDialog({super.key, this.imageUrls});

  @override
  ImageDisplayDialogState createState() => ImageDisplayDialogState();
}

class ImageDisplayDialogState extends State<ImageDisplayDialog> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void nextImage() {
    if (currentIndex < (widget.imageUrls?.length ?? 0) - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousImage() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Proof Image ${currentIndex + 1} of ${widget.imageUrls?.length}',
              textAlign: TextAlign.center,
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imageUrls!.length,
                      onPageChanged: onPageChanged,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.imageUrls![index],
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    child: DotsIndicator(
                      dotsCount: widget.imageUrls!.length,
                      position: currentIndex.floor(),
                      decorator: DotsDecorator(
                        color: Colors.grey[300]!,
                        activeColor: Colors.blue[400]!,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue[100]!)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: CTextTheme.blackTextTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
