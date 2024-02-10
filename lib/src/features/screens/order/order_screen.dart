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

class OrderPageState extends State<OrderPage> {
  var userHelper = UserHelper();
  bool isSignedIn = false;
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
    user = await userHelper.getUser();

    if (user != null) {
      setState(() {
        isSignedIn = true;
      });

      var orderHelper = OrderHelper();
      List<Order>? orders = await orderHelper.getUserOrders(user!.id);

      setState(() {
        userOrders = orders ?? [];
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
            isSignedIn
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userOrders.length,
                        itemBuilder: (context, index) {
                          Order order = userOrders[index];
                          return OrderCard(
                            orderNumber: order.orderNumber,
                            date: order.createdAt,
                            location: order.lockerDetails?.lockerSiteId,
                            status: order.orderStage!.getMostRecentStatus(),
                            order: order,
                          );
                        }))
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
}

//Order ListView Class
class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String? location;
  final String status;
  final Order order;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.date,
    required this.location,
    required this.status,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color:
          status == 'Order Error' ? Colors.red.shade100 : Colors.blue.shade100,
      child: ListTile(
        title: Text(date, style: CTextTheme.greyTextTheme.labelLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order No: $orderNumber',
              style: CTextTheme.blackTextTheme.headlineLarge,
            ),
            Text(
              'Location: $location',
              style: CTextTheme.greyTextTheme.labelLarge,
            ),
            Text(
              'Status: $status',
              style: CTextTheme.greyTextTheme.labelLarge,
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
