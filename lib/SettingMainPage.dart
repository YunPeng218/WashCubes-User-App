import 'package:flutter/material.dart';

class SettingMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: <Widget>[
          Icon(Icons.settings, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: <Widget>[
          UserHeader(),
          ProfileOption(title: 'Edit Profile', icon: Icons.edit),
          //ProfileOption(title: 'Referral', icon: Icons.card_giftcard),
          //ProfileOption(title: 'Rewards', icon: Icons.star),
          ProfileOption(title: 'Settings', icon: Icons.settings),
          ProfileOption(title: 'Customer Support', icon: Icons.support),
          ProfileOption(title: 'Feedback Ratings', icon: Icons.feedback),
          ProfileOption(title: 'About i3Cubes', icon: Icons.info_outline),
          ProfileOption(title: 'FAQs', icon: Icons.question_answer),
          //ProfileOption(title: 'Terms & Conditions', icon: Icons.description),
          ProfileOption(title: 'Privacy Policy', icon: Icons.privacy_tip),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        radius: 30,
      ),
      title: Text('Trimity Wang'),
      subtitle: Text('#90601912023'),
      trailing: Icon(Icons.message, color: Colors.blue),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final IconData icon;

  const ProfileOption({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Handle the tap event
      },
    );
  }
}
