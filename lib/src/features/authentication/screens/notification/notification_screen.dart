import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: Theme.of(context).textTheme.displaySmall,),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () { },
            icon: const Icon(Icons.delete_outline_outlined),
          ),
        ],
      ),
      
    );
  }
}