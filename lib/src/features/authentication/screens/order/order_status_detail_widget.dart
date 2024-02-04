import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/features/authentication/screens/order/order_status_summary.dart';
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderStatusSummaryScreen()),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'ORDER SUMMARY',
                      style: TextStyle(color: AppColors.cBlueColor2),
                    ),
                    Icon(
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '23 NOV 2023, 14:29',
                style: Theme.of(context).textTheme.headlineMedium,
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
            style: Theme.of(context).textTheme.headlineLarge,
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '25 NOV 2023, 14:00 - 16:00',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),
        //Location Detail Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Row(
                children: [
                  Text(
                    "TAYLOR'S UNIVERSITY",
                    style: TextStyle(color: AppColors.cGreyColor3),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.cGreyColor3,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const NearbyLocationPage()),
                  //     );
                  //   },
                  //   child: null,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
