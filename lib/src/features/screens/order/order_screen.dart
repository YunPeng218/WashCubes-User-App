import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_status_screen.dart';
import 'package:flutter/material.dart';
import '../../../common_widgets/bottom_nav_bar_widget.dart';
import 'create_order_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:device_run_test/src/utilities/order_helper.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/models/order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  User? user;
  List<Order> userOrders = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token') ?? 'No token';
    print(token);
    if (token != 'No token') loadUserOrders();
  }

  Future<void> loadUserOrders() async {
    var userHelper = new UserHelper();
    user = await userHelper.getUser();

    if (user != null) {
      var orderHelper = OrderHelper();
      List<Order>? orders = await orderHelper.getUserOrders(user!.id);

      setState(() {
        userOrders = orders ?? []; // Assign an empty list if orders is null
      });

      if (orders != null) {
        setState(() {
          userOrders = orders;
        });
      } else {
        print('Failed to load orders.');
      }
    } else {
      print('User is null. Unable to load orders.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          //Notification Icon Button
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          // title: const Text('Orders'),
          //Create Button
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    //Alert Pop Up
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "i3wash Would Like to Access the Camera",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        content: Text(
                          "Allow access to your camera?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        actions: <Widget>[
                          //Row & Expanded Widget For Button Centering
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  child: Text(
                                    "Don't Allow",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  child: Text(
                                    "OK",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateOrderCameraPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add, color: AppColors.cBlackColor),
                label: Text(
                  'Create',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            )
          ],
        ),
        // ListView of Orders
        body: Column(
          children: [
            const SizedBox(height: 20.0),
            Text('Your Orders',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20.0),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userOrders.length,
                    itemBuilder: (context, index) {
                      Order order = userOrders[index];
                      return OrderCard(
                          orderNumber: order.orderNumber,
                          date: order.createdAt,
                          location: order.lockerDetails?.lockerSiteId,
                          status: order.orderStatus);
                    })),
          ],
        ),
        //ChatBot Trimi Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
            );
          },
          tooltip: 'Increment',
          child: Image.asset(cChatBotLogo),
        ),
        //Bottom Navigation Bar
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

//Order ListView Class
class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String? location;
  final String status;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.date,
    required this.location,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color:
          status == 'Order Error' ? Colors.red.shade100 : Colors.blue.shade100,
      child: ListTile(
        title: Text(date, style: Theme.of(context).textTheme.labelLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order No: $orderNumber',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'Location: $location',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              'Status: $status',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderStatusScreen()),
          );
          // Handle the tap if necessary
        },
      ),
    );
  }
}
