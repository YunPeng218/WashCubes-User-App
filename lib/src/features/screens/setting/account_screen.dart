import 'package:device_run_test/src/common_widgets/bottom_nav_bar_widget.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/chatbot/chatbotScreen.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/features/screens/setting/setting_screen.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';
import 'faq_screen.dart';
import 'policy_screen.dart';
import 'feedback_screen.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Notification Button
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize - 10),
        child: ListView(
          children: <Widget>[
            const UserHeader(),
            ProfileOption(
              title: 'Edit Profile',
              icon: Icons.person_outline_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()),
                );
              },
            ),
            const Divider(),
            //ProfileOption(title: 'Referral', icon: Icons.card_giftcard),
            //ProfileOption(title: 'Rewards', icon: Icons.star),
            // ProfileOption(
            //   title: 'Settings',
            //   icon: Icons.settings,
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => EditProfilePage()),
            //     );
            //   },
            // ),
            ProfileOption(
              title: 'Settings',
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
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
                      builder: (context) => const FeedbackRatingsPage()),
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
                  MaterialPageRoute(builder: (context) => const PolicyPage()),
                );
              },
            ),
            const Divider(),
            ProfileOption(
              title: 'Logout',
              icon: Icons.logout,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
      //BottomNavBar
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(cAvatar),
        radius: 30,
      ),
      title: Text(
        'Trimity Wang',
        style: CTextTheme.blackTextTheme.displaySmall,
      ),
      subtitle: Text(
        '#90601912023',
        style: CTextTheme.greyTextTheme.labelLarge,
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
