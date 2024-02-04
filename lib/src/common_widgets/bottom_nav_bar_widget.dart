import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/authentication/screens/home/home_screen.dart';
import 'package:device_run_test/src/features/authentication/screens/order/LaundryServicePicker.dart';
import 'package:device_run_test/src/features/authentication/screens/setting/SettingMainPage.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.cBlueColor3,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            icon: const Icon(Icons.home_outlined),
            color: AppColors.cWhiteColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LaundryServicePicker()),
              );
            },
            icon: const Icon(Icons.shopping_basket_outlined),
            color: AppColors.cWhiteColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingMainPage()),
              );
            },
            icon: const Icon(Icons.person_outlined),
            color: AppColors.cWhiteColor,
          ),
          label: '',
        ),
      ],
    );
  }
}
