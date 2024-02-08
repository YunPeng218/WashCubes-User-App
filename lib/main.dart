import 'package:device_run_test/src/features/screens/welcome/welcome_screen.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/utilities/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/src/utilities/guest_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GuestModeProvider>(
        create: (_) => GuestModeProvider(),
      ),
    ],
    child: MyApp(
      token: prefs.getString('token'),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // themeMode: ThemeMode.system,
        title: 'WashCubes App',
        theme: CAppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: (token != null) ? HomePage(token: token) : const WelcomeScreen());
  }
}
