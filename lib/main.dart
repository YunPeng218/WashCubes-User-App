import 'package:device_run_test/firebase_options.dart';
import 'package:device_run_test/src/features/screens/notification/notification_screen.dart';
import 'package:device_run_test/src/utilities/locker_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.black, // Set the status bar color to white
  ));

  FirebaseMessaging.instance.getToken().then((value) {
    prefs.setString('fcmToken', '$value');
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GuestModeProvider>(
        create: (_) => GuestModeProvider(),
      ),
      ChangeNotifierProvider<LockerService>(
        create: (_) => LockerService(),
      ),
    ],
    child: MyApp(
      token: prefs.getString('token'),
    ),
  ));
}

Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Notification for when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async { 
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          '/notificationPage',
        );
      },
    );

    // Notification for when the app is closed or terminated
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null) {
          Navigator.pushNamed(
          navigatorKey.currentState!.context,
          '/notificationPage',
          );
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);

    return MaterialApp(
      // themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: (token != null) ? const HomePage() : const WelcomeScreen(),
      navigatorKey: navigatorKey,
      routes: {
        '/notificationPage': ((context) => const NotificationScreen())
      }
    );
  }
}
