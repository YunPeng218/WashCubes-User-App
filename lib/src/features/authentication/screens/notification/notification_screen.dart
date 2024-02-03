import 'package:device_run_test/src/constants/image_strings.dart';
// import 'package:device_run_test/src/constants/sizes.dart';
import 'package:flutter/material.dart';

import 'notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotificationScreen> {
  final int _notifNumber = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget bodyWidget;
    if (_notifNumber != 0) {
      bodyWidget = SingleChildScrollView(
        child: Column(
          children: [
            NotificationBar(size: size),
          ],
        ),
      );
    } else {
      bodyWidget = Center(
        child: Column(
          children: [
            Image.asset(cChatBotLogo),
            Text(
              'No Notification',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline_outlined),
          ),
        ],
      ),
      body: bodyWidget,
    );
  }
}
