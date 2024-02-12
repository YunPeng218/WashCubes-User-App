import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:device_run_test/src/features/screens/setting/account_screen.dart';
import 'package:flutter/material.dart';

import '../features/screens/order/order_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    const iconPadding = EdgeInsets.only(top: 8.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: iconPadding,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                icon: const Icon(Icons.home_outlined),
                color: AppColors.cWhiteColor,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: iconPadding,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderPage()),
                  );
                },
                icon: const Icon(Icons.shopping_basket_outlined),
                color: AppColors.cWhiteColor,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: iconPadding,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                },
                icon: const Icon(Icons.person_outlined),
                color: AppColors.cWhiteColor,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
