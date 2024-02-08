import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cReservedIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 23',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Reserved',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cDropOffIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 23',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Drop Off',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cCollectedOperatorIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 23',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Collected By Operator',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cInProgressIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 24',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'In Progress',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cPrepCompletionIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 25',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Preparation Completed',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cDeliveryIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 26',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Out Of Delivery',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cCollectionIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 26',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Ready For Collection',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(cCompleteIcon),
              const SizedBox(width: 20),
              SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOV 26',
                      style: CTextTheme.blackTextTheme.labelLarge,
                    ),
                    Text(
                      'Completed',
                      style: CTextTheme.blueTextTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
