import 'package:device_run_test/src/common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/authentication/screens/chatbot/chatbot_screen.dart';
import 'package:device_run_test/src/features/authentication/screens/nearbylocation/NearbyLocationPage.dart';
import 'package:device_run_test/src/features/authentication/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/authentication/screens/setting/account_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/elevatedbutton_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  final token;
  const HomePage({Key? key, this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userID;

  @override
  void initState() {
    super.initState();

    if (widget.token != null) {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      userID = jwtDecodedToken['_id'];
    } else {
      userID = 'Guest';
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
            backgroundImage: const AssetImage(cAvatar),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingMainPage()),
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              // Discover Text
              Text(
                'Discover your closest\nlaundry lockers',
                style: Theme.of(context).textTheme.displayLarge,
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
                style: CElevatedButtonTheme.lightElevatedButtonTheme.style,
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
                    const Icon(Icons.location_on, color: AppColors.cPrimaryColor,),
                    Text("Taylor's University", style: Theme.of(context).textTheme.labelLarge),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.cBlackColor,),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Special Event Title
              Text(
                'Special Event',
                style: Theme.of(context).textTheme.displaySmall,
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
              // Ongoing Order Title
              Text(
                'Ongoing Order',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              
              const SizedBox(height: 5), // ...
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '“Leave it to Trimi - cleaning magic in progress!”',
                            style: Theme.of(context).textTheme.headlineSmall,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              //Current Order Progress Bar
                              Container(
                                height: 10,
                                width: 200 *
                                    0.7, // Assuming the container is 200 wide, 70% filled
                                decoration: BoxDecoration(
                                  color: AppColors.cPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: -2,
                                child: Text(
                                  '70%',
                                  style: Theme.of(context).textTheme.labelMedium,
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
                              foregroundColor: Colors.black, // Text color
                              backgroundColor: Colors.white, // Button Fill color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: AppColors.cGreyColor1),
                              ),
                            ),
                            child: Text('Check', style: Theme.of(context).textTheme.labelMedium,),
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
            MaterialPageRoute(builder: (context) => const ChatBotScreen()),
          );
        },
        tooltip: 'Increment',
        child: Image.asset(cChatBotLogo),
      ),
      //BottomNavBar
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
