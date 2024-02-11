import 'package:device_run_test/src/common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/nearbylocation/NearbyLocationPage.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/features/screens/setting/account_screen.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:device_run_test/src/utilities/order_helper.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_run_test/src/features/models/order.dart';

class HomePage extends StatefulWidget {
  final token;
  const HomePage({Key? key, this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userID;
  UserProfile? user;
  String profilePic =
      'https://res.cloudinary.com/ddweldfmx/image/upload/v1707480915/profilePic/zxltbifbulr4m45lbsqq.png';
  var userHelper = UserHelper();
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
    init();
    loadUserOrders();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'No token';
    if (token != 'No token') {
      loadUserInfo();
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
    return Consumer<GuestModeProvider>(
      builder: (context, guestProvider, child) {
        return SafeArea(
          child: Scaffold(
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
                  backgroundImage: NetworkImage(profilePic),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    },
                    child: null,
                  ),
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
                      style: CTextTheme.blackTextTheme.displayLarge,
                    ),
                    const SizedBox(height: 16),
                    // Location Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NearbyLocationPage()),
                        );
                      },
                      // style:
                      //     CElevatedButtonTheme.lightElevatedButtonTheme.style,
                      // ElevatedButton.styleFrom(
                      //   primary: Colors.blue,
                      //   onPrimary: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30.0),
                      //   ),
                      //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.cPrimaryColor,
                          ),
                          Text("Taylor's University",
                              style: CTextTheme.blackTextTheme.labelLarge),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
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
                    // Ongoing Order Box
                    // Container(
                    // padding: const EdgeInsets.all(2),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(20),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: AppColors.cGreyColor2.withOpacity(0.3),
                    //       spreadRadius: 1,
                    //       blurRadius: 6,
                    //       offset: const Offset(0, 3),
                    //     ),
                    //   ],
                    // ),
                    // child:
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       flex: 6,
                    //       child:
                    guestProvider.guestMode
                        ? Column(
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Text(
                                'Sign In to View Your Orders',
                                style: CTextTheme.blackTextTheme.headlineSmall,
                                textAlign: TextAlign.end,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomeScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      AppColors.cBlackColor, // Text color
                                  backgroundColor: AppColors
                                      .cWhiteColor, // Button Fill color
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
                                // margin: const EdgeInsets.symmetric(
                                //     vertical: 5.0, horizontal: 15.0),
                                color: Colors.blue[50],
                                child: ListTile(
                                  leading: Image.asset(
                                    cAppLogo,
                                    width: 60,
                                    height: 60,
                                  ),
                                  title: Text(activeOrdersCount.toString(),
                                      style: CTextTheme
                                          .blackTextTheme.headlineLarge),
                                  subtitle: Text('Active Orders',
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderPage()),
                                    );
                                  },
                                ),
                              ),
                              Card(
                                // margin: const EdgeInsets.symmetric(
                                //     vertical: 5.0, horizontal: 15.0),
                                color: Colors.green[50],
                                child: ListTile(
                                  leading: Image.asset(
                                    cCompleteIcon,
                                    width: 60,
                                    height: 60,
                                  ),
                                  title: Text(completedOrdersCount.toString(),
                                      style: CTextTheme
                                          .blackTextTheme.headlineLarge),
                                  subtitle: Text('Completed Orders',
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderPage()),
                                    );
                                  },
                                ),
                              ),
                              Card(
                                // margin: const EdgeInsets.symmetric(
                                //     vertical: 5.0, horizontal: 15.0),
                                color: Colors.red[50],
                                child: ListTile(
                                  leading: Image.asset(
                                    cOrderErrorIcon,
                                    width: 60,
                                    height: 60,
                                  ),
                                  title: Text(orderErrorsCount.toString(),
                                      style: CTextTheme
                                          .blackTextTheme.headlineLarge),
                                  subtitle: Text('Order Errors',
                                      style: CTextTheme
                                          .greyTextTheme.headlineMedium),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderPage()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                    //   ),
                    // ],
                    //),
                    // )
                  ],
                ),
              ),
            ),
            //ChatBot Trimi Button
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatbotScreen()),
                );
              },
              tooltip: 'Increment',
              child: Image.asset(cChatBotLogo),
            ),
            //BottomNavBar
            bottomNavigationBar: const BottomNavBar(),
          ),
        );
      },
    );
  }
}
