import 'package:device_run_test/src/common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/nearbylocation/NearbyLocationPage.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/setting/account_screen.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final token;
  const HomePage({Key? key, this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userID;
  UserProfile? user;
  String profilePic = 'https://res.cloudinary.com/ddweldfmx/image/upload/v1707480915/profilePic/zxltbifbulr4m45lbsqq.png';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'No token';
    if (token != 'No token') loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      var userHelper = UserHelper();
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
                        MaterialPageRoute(
                            builder: (context) => AccountPage()),
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cGreyColor2.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          // Left side (6 flex)
                          Expanded(
                            flex: 6,
                            child: guestProvider.guestMode
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
                                          backgroundColor:
                                              AppColors.cWhiteColor, // Button Fill color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '#906912',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Laundry In Progress',
                                        style: CTextTheme.blackTextTheme.displaySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '“Leave it to Trimi - cleaning magic in progress!”',
                                        style: CTextTheme.blackTextTheme.headlineSmall,
                                      ),
                                      const SizedBox(height: 10),
                                      //Order Progress Bar
                                      Stack(
                                        children: <Widget>[
                                          //Entire Order Progress Bar
                                          Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: AppColors.cWhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          //Current Order Progress Bar
                                          Container(
                                            height: 10,
                                            width: 200 *
                                                0.7, // Assuming the container is 200 wide, 70% filled
                                            decoration: BoxDecoration(
                                              color: AppColors.cPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: -2,
                                            child: Text(
                                              '70%',
                                              style: CTextTheme.blackTextTheme.labelMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Implement the button action
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.cBlackColor, // Text color
                                          backgroundColor:
                                              AppColors.cWhiteColor, // Button Fill color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                color: AppColors.cGreyColor1),
                                          ),
                                        ),
                                        child: Text(
                                          'Check',
                                          style: CTextTheme.blackTextTheme.labelMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          // Right side (4 flex)
                          // Expanded(
                          //   flex: 4,
                          //   child: Container(
                          //     // Placeholder for the image
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(12),
                          //       image: const DecorationImage(
                          //         image: AssetImage('assets/images/hp_order_1.png'),
                          //         fit: BoxFit.cover,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
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
