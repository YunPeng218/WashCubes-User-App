// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
        String userId = jwtDecodedToken['_id'];
        final response = await http.get(
          Uri.parse('${url}fetchNotification?userId=$userId'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          List<Map<String, dynamic>> fetchedNotifications = List<Map<String, dynamic>>.from(data['notifications']);
          fetchedNotifications = fetchedNotifications.reversed.toList();
          setState(() {
            notifications = fetchedNotifications;
            isLoading = false;
          });
        } else {
          print('Failed to fetch notifications');
          setState(() {
            isLoading = false;
          });
        }
    } catch (error) {
      print('Error fetching notifications: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      String userId = jwtDecodedToken['_id'];
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Confirmation',
              style: CTextTheme.blackTextTheme.headlineLarge
            ),
            content: Text(
              'Are you sure you want to delete all notifications?',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Delete',
                  style: CTextTheme.blackTextTheme.headlineMedium,
                ),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        final response = await http.delete(
          Uri.parse('${url}deleteAllNotifications?userId=$userId'),
        );
        if (response.statusCode == 200) {
          setState(() {
            notifications = [];
          });
        } else {
          print('Failed to delete notifications. Status Code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error deleting notifications: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget bodyWidget;
    if (isLoading) {
      bodyWidget = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (notifications.isNotEmpty) {
      bodyWidget = SingleChildScrollView(
        child: Column(
          children: [
            for (var notification in notifications)
              NotificationBar(
                size: size,
                title: notification['title'],
                message: notification['message'],
                date: notification['receivedAt'],
                isRead: notification['isRead'],
              ),
          ],
        ),
      );
    } else {
      bodyWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              cChatBotLogoLarge,
              width: 150, 
              height: 150, 
            ),
            Text(
              'No Notification',
              style: CTextTheme.greyTextTheme.headlineSmall,
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
         actions: notifications.isNotEmpty
            ? [
                IconButton(
                  onPressed: () {
                    deleteAllNotifications();
                  },
                  icon: const Icon(Icons.delete_outline_outlined),
                ),
              ]
            : [],
      ),
      body: bodyWidget,
    );
  }
}