// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'create_order_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SCREENS
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_status_screen.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:device_run_test/src/features/screens/order/locker_site_select.dart';

// STYLES
import '../../../common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/common_widgets/cancel_confirm_alert.dart';

// MODELS
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/models/order.dart';

// UTILS
import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:device_run_test/src/utilities/order_helper.dart';

// Make the icons resemble an open locker compartment, and within the compartment there is laundry, for each size from small to extra large, put an increasing amount of laundry

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});
  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  var userHelper = UserHelper();
  bool isSignedIn = false;
  User? user;
  List<Order> userOrders = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    init();
    _tabController = TabController(length: 3, vsync: this);
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token') ?? 'No token';
    print(token);
    if (token != 'No token') loadUserOrders();
  }

  Future<void> loadUserOrders() async {
    user = await userHelper.getUser();

    if (user != null) {
      setState(() {
        isSignedIn = true;
      });

      var orderHelper = OrderHelper();
      List<Order>? orders = await orderHelper.getUserOrders(user!.id);

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

  // HANDLE CREATE ORDER BUTTON PRESS
  void handleCreateButtonPress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Locker Location',
            textAlign: TextAlign.center,
            style: CTextTheme.blackTextTheme.headlineLarge,
          ),
          content: Text(
            'How would you like to select the locker location?',
            textAlign: TextAlign.center,
            style: CTextTheme.blackTextTheme.headlineMedium,
          ),
          actions: <Widget>[
            //Row & Expanded Widget For Button Centering
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          'Select Manually',
                          style: CTextTheme.blackTextTheme.headlineSmall,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LockerSiteSelect(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          'Scan Locker QR Code',
                          style: CTextTheme.blackTextTheme.headlineSmall,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          handleSelectCameraOption();
                        },
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
                        child: Text(
                          'Cancel',
                          style: CTextTheme.blackTextTheme.headlineSmall,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ASK USERS PERMISSION TO USE CAMERA
  void handleSelectCameraOption() {
    showDialog(
      context: context,
      //Alert Pop Up
      builder: (BuildContext context) {
        return CancelConfirmAlert(
            title: 'Camera Access',
            content: 'i3Cubes would like to access your camera.',
            onPressedConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateOrderCameraPage(),
                ),
              );
            },
            cancelButtonText: 'Don\'t Allow',
            confirmButtonText: 'Allow');
      },
    );
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
                  handleCreateButtonPress();
                },
                icon: const Icon(Icons.add, color: AppColors.cBlackColor),
                label: Text(
                  'Create',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            Text('Your Orders', style: CTextTheme.blackTextTheme.displayMedium),
            const SizedBox(height: 20.0),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Active Orders'),
                Tab(text: 'Order Error'),
                Tab(text: 'Completed'),
              ],
              indicatorColor:
                  AppColors.cBlueColor3, // Set the indicator color to blue
            ),
            const SizedBox(height: 15.0),
            isSignedIn
                ? Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      buildActiveOrderList(),
                      buildOrderErrorList(),
                      buildCompletedOrderList(),
                    ]),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 50.0),
                          Text('Sign In To View Your Orders',
                              style: CTextTheme.greyTextTheme.displayMedium),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: CTextTheme.blackTextTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

  Widget buildActiveOrderList() {
    // Filter the orders based on the selected orderStage
    List<Order> filteredOrders = userOrders
        .where((order) =>
            order.orderStage?.completed.status == false &&
            order.orderStage?.orderError.status == false)
        .toList();

    print('YO');
    print(filteredOrders);

    if (filteredOrders.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50.0),
          Text(
            'No Active Orders',
            style: CTextTheme.greyTextTheme.headlineLarge,
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        Order order = filteredOrders[index];
        return OrderCard(order: order);
      },
    );
  }

  Widget buildOrderErrorList() {
    // Filter the orders based on the selected orderStage
    List<Order> filteredOrders = userOrders
        .where((order) =>
            order.orderStage?.completed.status == false &&
            order.orderStage?.orderError.status == true)
        .toList();

    if (filteredOrders.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50.0),
          Text(
            'No Order Errors',
            style: CTextTheme.greyTextTheme.headlineLarge,
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        Order order = filteredOrders[index];
        return OrderCard(order: order);
      },
    );
  }

  Widget buildCompletedOrderList() {
    // Filter the orders based on the selected orderStage
    List<Order> filteredOrders = userOrders
        .where(
            (order) => order.orderStage?.getMostRecentStatus() == 'Completed')
        .toList();

    if (filteredOrders.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50.0),
          Text(
            'No Completed Orders',
            style: CTextTheme.greyTextTheme.headlineLarge,
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        Order order = filteredOrders[index];
        return OrderCard(order: order);
      },
    );
  }
}

//Order ListView Class
class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  Map<String, String> statusIcons = {
    'Pending Drop Off': cDropOffIcon,
    'Collected By Rider': cCollectedOperatorIcon,
    'In Progress': cInProgressIcon,
    'Processing Complete': cPrepCompletionIcon,
    'Out For Delivery': cDeliveryIcon,
    'Ready For Collection': cCollectionIcon,
    'Completed': cCompleteIcon,
    'Order Error': cOrderErrorIcon,
  };

  @override
  Widget build(BuildContext context) {
    bool isOrderError = order.orderStage?.orderError.status ?? false;
    bool isOrderComplete = order.orderStage?.completed.status ?? false;

    Color cardColor = isOrderError
        ? Colors.red[50]!
        : isOrderComplete
            ? Colors.green[50]!
            : Colors.blue[50]!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      color: cardColor,
      child: ListTile(
        leading: isOrderError
            ? Image.asset(
                statusIcons['Order Error'] ?? cAppLogo,
                width: 70,
                height: 70,
              )
            : Image.asset(
                statusIcons[order.orderStage?.getMostRecentStatus()] ??
                    cAppLogo,
                width: 70,
                height: 70,
              ),
        title: Text(order.getFormattedDateTime(order.createdAt),
            style: CTextTheme.greyTextTheme.labelLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            Text(
              'Order No: ${order.orderNumber}',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            const SizedBox(height: 5.0),
            Text(
              'Status: ${order.orderStage?.getMostRecentStatus() ?? 'Loading...'}',
              style: CTextTheme.blackTextTheme.headlineSmall,
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderStatusScreen(
                      order: order,
                    )),
          );
          // Handle the tap if necessary
        },
      ),
    );
  }
}
