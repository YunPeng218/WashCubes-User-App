import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Service Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LaundryServicePicker(),
    );
  }
}

class LaundryServicePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button
          },
        ),
        title: Text('Pick your Laundry Service'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'One service is available for a single order.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: <Widget>[
                ServiceCard(serviceName: 'Wash & Fold', iconName: 'icons/wash_fold.png'),
                ServiceCard(serviceName: 'Dry Cleaning', iconName: 'icons/dry_cleaning.png'),
                ServiceCard(serviceName: 'Handwash', iconName: 'icons/handwash.png'),
                ServiceCard(serviceName: 'Laundry & Iron', iconName: 'icons/laundry_iron.png'),
                // Assuming you have an icon for the chatbot as well
                // ServiceCard(serviceName: 'Chat with Support', iconName: 'icons/support_chat.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String iconName;

  ServiceCard({required this.serviceName, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(iconName, height: 80), // Replace with NetworkImage if your images are network-based
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(serviceName, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
