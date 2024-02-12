import 'package:device_run_test/src/common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/setting/setting_screen.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';
import 'faq_screen.dart';
import 'policy_screen.dart';
import 'feedback_screen.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserProfile? user;

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
        return Scaffold(
          appBar: AppBar(
            // Notification Button
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_none),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(cDefaultSize - 10),
            child: guestProvider.guestMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign In to View Your Profile',
                            style: CTextTheme.blackTextTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.cBlackColor,
                              backgroundColor: AppColors.cWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                    color: AppColors.cGreyColor1),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: CTextTheme.blackTextTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : ListView(
                    children: <Widget>[
                      if (user != null) UserHeader(user: user),
                      SizedBox(height: 15),
                      ProfileOption(
                        title: 'Edit Profile',
                        icon: Icons.person_outline_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          ).whenComplete(() => loadUserInfo());
                        },
                      ),
                      const Divider(),
                      ProfileOption(
                        title: 'Settings',
                        icon: Icons.settings_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingPage()),
                          );
                        },
                      ),
                      const Divider(),
                      ProfileOption(
                        title: 'Feedback Ratings',
                        icon: Icons.star_border_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FeedbackRatingsPage()),
                          );
                        },
                      ),
                      const Divider(),
                      ProfileOption(
                        title: 'FAQs',
                        icon: Icons.question_answer,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQsPage()),
                          );
                        },
                      ),
                      const Divider(),
                      ProfileOption(
                        title: 'Privacy Policy',
                        icon: Icons.shield_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PolicyPage()),
                          );
                        },
                      ),
                      const Divider(),
                      ProfileOption(
                        title: 'Logout',
                        icon: Icons.logout,
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.clear();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      const Divider(),
                    ],
                  ),
          ),
          // ChatBot Trimi Button
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
          // BottomNavBar
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}

class UserHeader extends StatelessWidget {
  final UserProfile? user;

  UserHeader({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user!.profilePicURL),
        radius: 30,
      ),
      title: Text(
        user?.name.isNotEmpty ?? false ? user!.name : 'Trimi',
        style: CTextTheme.blackTextTheme.displaySmall,
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileOption(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.cBlueColor5),
      title: Text(
        title,
        style: CTextTheme.blackTextTheme.headlineMedium,
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
