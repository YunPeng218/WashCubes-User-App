import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/screens/order/order_status_summary.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class OrderStatusDetailWidget extends StatelessWidget {
  const OrderStatusDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return //Order Summary & Details
        Column(
      children: [
        //Order Number & Summary Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#000001',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderStatusSummaryScreen()),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'ORDER SUMMARY',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.cBlueColor2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //Order Creation Detail Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Created',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              Text(
                '23 NOV 2023, 14:29',
                style: CTextTheme.blackTextTheme.headlineMedium,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //Pick Up Info Title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Self-Pick Up Information',
            style: CTextTheme.blackTextTheme.headlineLarge,
          ),
        ),
        //Time Detail Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              Text(
                '25 NOV 2023, 14:00 - 16:00',
                style: CTextTheme.blackTextTheme.headlineMedium,
              )
            ],
          ),
        ),
        //Location Detail Row
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         'Location',
        //         style: Theme.of(context).textTheme.headlineMedium,
        //       ),
        //       const Row(
        //         children: [
        //           Text(
        //             "TAYLOR'S UNIVERSITY",
        //             style: CTextTheme.greyTextTheme.headlineMedium,
        //           ),
        //           Icon(
        //             Icons.edit_outlined,
        //             color: AppColors.cGreyColor3,
        //           ),
        //           // GestureDetector(
        //           //   onTap: () {
        //           //     Navigator.push(
        //           //       context,
        //           //       MaterialPageRoute(
        //           //           builder: (context) => const NearbyLocationPage()),
        //           //     );
        //           //   },
        //           //   child: null,
        //           // ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
