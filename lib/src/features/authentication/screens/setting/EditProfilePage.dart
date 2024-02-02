import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Status bar text color
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          ProfileHeader(),
          EditableProfileItem(title: 'PREFERRED NAME', value: 'Trimity Wang'),
          EditableProfileItem(title: 'MOBILE NUMBER', value: '+60 14-096 0912'),
          EditableProfileItem(title: 'EMAIL ADDRESS', value: 'trimityi3@gmail.com'),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          radius: 50,
        ),
        SizedBox(height: 10),
        Text(
          '#90601912023',
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          '20,322 i3Coins',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class EditableProfileItem extends StatelessWidget {
  final String title;
  final String value;

  const EditableProfileItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  // Implement edit functionality
                },
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
