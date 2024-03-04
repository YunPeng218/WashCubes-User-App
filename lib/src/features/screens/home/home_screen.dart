// ignore_for_file: sort_child_properties_last

import 'dart:async';

import 'package:device_run_test/src/common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/login_session/session_expired_page.dart';
import 'package:device_run_test/src/features/screens/nearbylocation/nearby_location_page.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/features/screens/setting/account_screen.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:device_run_test/src/utilities/order_helper.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_run_test/src/features/models/order.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late String userID;
  UserProfile? user;
  late Timer timer;
  int elapsedTime = 0;
  String? profilePic;
  var userHelper = UserHelper();
  bool isInactive = false;
  List<Order> userOrders = [];
  int activeOrdersCount = 0;
  int orderErrorsCount = 0;
  int completedOrdersCount = 0;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    loadUserOrders();
    timer = Timer.periodic(const Duration(seconds: 1), (tm) {
      if (isInactive) {
        setState(() {
          elapsedTime += 1;
          if (elapsedTime == 300) {
            setSessionStatus(true);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => SessionExpiredPage(),
              ),
              (Route<dynamic> route) => false,
            );
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      setAuthenticationStatus(false);
      isInactive = true;
    } else if (state == AppLifecycleState.resumed) {
      setAuthenticationStatus(true);
      isInactive = false;
      elapsedTime = 0;
    }
  }

  Future<void> setAuthenticationStatus(bool boolean) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isAuthenticated', boolean ? 'true' : 'false');
  }

  Future<void> setSessionStatus(bool boolean) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sessionExpired', boolean ? 'true' : 'false');
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'No token';
    if (token != 'No token') {
      loadUserInfo();
    } else {
      setState(() {
        profilePic = 'https://res.cloudinary.com/ddweldfmx/image/upload/v1707480915/profilePic/zxltbifbulr4m45lbsqq.png';
      });
    }
    String isBiometricsEnabled =
        prefs.getString('isBiometricsEnabled') ?? 'false';
    String isAuthenticated = prefs.getString('isAuthenticated') ?? 'false';
    String sessionExpired = prefs.getString('sessionExpired') ?? 'false';
    if ((isBiometricsEnabled == 'true' && isAuthenticated == 'false') ||
        isBiometricsEnabled == 'true' && sessionExpired == 'true') {
      showBiometricPrompt(context);
    }
  }

  // Function to show biometric prompt
  Future<void> showBiometricPrompt(BuildContext context) async {
    final localAuth = LocalAuthentication();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access i3Cubes.',
      );
      if (isAuthenticated) {
        prefs.setString('isAuthenticated', 'true');
        prefs.setString('sessionExpired', 'false');
      } else {
        SystemNavigator.pop();
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  Future<void> loadUserInfo() async {
    try {
      UserProfile? foundUser = await userHelper.getUserDetails();
      if (mounted) {
        setState(() {
          user = foundUser;
          profilePic = user!.profilePicURL;
        });
      }
    } catch (error) {
      print('Failed to load user: $error');
    }
  }

  Future<void> loadUserOrders() async {
    User? user = await userHelper.getUser();

    if (user != null) {
      var orderHelper = OrderHelper();
      List<Order>? orders = await orderHelper.getUserOrders(user.id);

      setState(() {
        userOrders = orders ?? [];
      });

      if (orders != null) {
        setState(() {
          userOrders = orders;

          print(userOrders);

          activeOrdersCount = userOrders
              .where((order) =>
                  order.orderStage?.completed.status != true &&
                  order.orderStage?.orderError.status != true)
              .length;

          orderErrorsCount = userOrders
              .where((order) =>
                  order.orderStage?.completed.status != true &&
                  order.orderStage?.orderError.status == true)
              .length;

          completedOrdersCount = userOrders
              .where((order) =>
                  order.orderStage?.completed.status == true &&
                  order.orderStage?.orderError.status != true)
              .length;
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
    return Scaffold(
      // Notification icon and circle avatar
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
        //Avatar Icon
        actions: <Widget>[
          CircleAvatar(
            backgroundImage: profilePic != null ? NetworkImage(profilePic!) : null,
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
              child: null,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              // Good Morning Text
              Text(
                'Good Morning, Trimity!',
                style: CTextTheme.blackTextTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              // Discover Text
              Text(
                'Discover your closest\nlaundry lockers',
                style: CTextTheme.blackTextTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              // Location Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NearbyLocationPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.cBlueColor3,
                    ),
                    Text("View Locker Sites",
                        style: CTextTheme.blackTextTheme.headlineSmall),
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: AppColors.cBlackColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Special Event Title
              Text(
                'Special Event',
                style: CTextTheme.blackTextTheme.displaySmall,
              ),
              // RecyclerView for images
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4, // The number of items in the list
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                          'assets/images/homepage_image/special_event_${index + 1}.png'),
                    );
                  },
                ),
              ),
              const Divider(),
              // Ongoing Order Section
              const SizedBox(height: 5),
              // Ongoing Order Title
              Text(
                'Ongoing Orders',
                style: CTextTheme.blackTextTheme.displaySmall,
              ),
              const SizedBox(height: 15),
              Provider.of<GuestModeProvider>(context, listen: false).guestMode
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In to View Your Orders',
                              style: CTextTheme.blackTextTheme.headlineSmall,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const WelcomeScreen();
                            }), (route) {
                              return false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                AppColors.cBlackColor, // Text color
                            backgroundColor:
                                AppColors.cWhiteColor, // Button Fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: AppColors.cGreyColor1),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: CTextTheme.blackTextTheme.labelMedium,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Card(
                          color: Colors.blue[50],
                          child: ListTile(
                            leading: Image.asset(
                              cHpOrder,
                              width: 60,
                              height: 60,
                            ),
                            title: Text(activeOrdersCount.toString(),
                                style: CTextTheme.blackTextTheme.headlineLarge),
                            subtitle: Text('Active Orders',
                                style: CTextTheme.greyTextTheme.headlineMedium),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderPage()),
                              );
                            },
                          ),
                        ),
                        Card(
                          color: Colors.green[50],
                          child: ListTile(
                            leading: Image.asset(
                              cCompleteIcon,
                              width: 60,
                              height: 60,
                            ),
                            title: Text(completedOrdersCount.toString(),
                                style: CTextTheme.blackTextTheme.headlineLarge),
                            subtitle: Text('Completed Orders',
                                style: CTextTheme.greyTextTheme.headlineMedium),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderPage()),
                              );
                            },
                          ),
                        ),
                        Card(
                          color: Colors.red[50],
                          child: ListTile(
                            leading: Image.asset(
                              cOrderErrorIcon,
                              width: 60,
                              height: 60,
                            ),
                            title: Text(orderErrorsCount.toString(),
                                style: CTextTheme.blackTextTheme.headlineLarge),
                            subtitle: Text('Order Errors',
                                style: CTextTheme.greyTextTheme.headlineMedium),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderPage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
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
        backgroundColor: Colors.blue[50],
      ),
      //BottomNavBar
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
