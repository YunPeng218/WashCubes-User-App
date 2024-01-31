import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PolicyPage(),
    );
  }
}

class PolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          // Replace with actual privacy policy text
          'Lorem ipsum dolor sit amet, quo aperiores inventore et eum maxime est necessitatibus voluptates molestias animi. Et ab voluptatem delicti et quos possimus non tosto. Nunc magnam, quos interdum molestiae non dolor assumenda non ipsa pariatur et consequatur vitae sed numquam eius!\n\n'
          // ... Continue with the rest of the privacy policy text
              'Lorem ipsum dolor sit amet, quo aperiores inventore et eum maxime est necessitatibus...',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
