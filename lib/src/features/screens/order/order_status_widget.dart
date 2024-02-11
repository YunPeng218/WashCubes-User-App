import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';

class OrderStatusWidget extends StatefulWidget {
  final Order order;
  const OrderStatusWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderStatusWidget> createState() => OrderStatusWidgetState();
}

class OrderStatusWidgetState extends State<OrderStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final List<StatusItem> statusIcons = [
      StatusItem(date: '23 NOV', title: 'Pending Drop Off', icon: cDropOffIcon),
      StatusItem(
          date: '23 NOV',
          title: 'Collected By Rider',
          icon: cCollectedOperatorIcon),
      StatusItem(date: '23 NOV', title: 'In Progress', icon: cInProgressIcon),
      StatusItem(
          date: '23 NOV',
          title: 'Processing Complete',
          icon: cPrepCompletionIcon),
      StatusItem(
          date: '23 NOV', title: 'Out For Delivery', icon: cDeliveryIcon),
      StatusItem(
          date: '23 NOV', title: 'Ready For Collection', icon: cCollectionIcon),
      StatusItem(date: '23 NOV', title: 'Completed', icon: cCompleteIcon),
    ];

    final List<StatusItem> statusIconsGrey = [
      StatusItem(
          date: '23 NOV', title: 'Pending Drop Off', icon: cDropOffIconGrey),
      StatusItem(
          date: '23 NOV',
          title: 'Collected By Rider',
          icon: cCollectedOperatorIconGrey),
      StatusItem(
          date: '23 NOV', title: 'In Progress', icon: cInProgressIconGrey),
      StatusItem(
          date: '23 NOV',
          title: 'Processing Complete',
          icon: cPrepCompletionIconGrey),
      StatusItem(
          date: '23 NOV', title: 'Out For Delivery', icon: cDeliveryIconGrey),
      StatusItem(
          date: '23 NOV',
          title: 'Ready For Collection',
          icon: cCollectionIconGrey),
      StatusItem(date: '23 NOV', title: 'Completed', icon: cCompleteIconGrey),
    ];

    final Map<String, String> statusFields = {
      'Pending Drop Off': 'pendingDropOff',
      'Collected By Rider': 'collectedByRider',
      'In Progress': 'inProgress',
      'Processing Complete': 'processingComplete',
      'Out For Delivery': 'outForDelivery',
      'Ready For Collection': 'readyForCollection',
      'Completed': 'completed',
    };

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 270,
              child: CustomPaint(
                painter: TimelinePainter(),
              ),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: statusIcons.length,
                itemBuilder: (context, index) {
                  bool isStatusTrue;
                  switch (index) {
                    case 0:
                      isStatusTrue =
                          widget.order.orderStage!.pendingDropOff.status;
                      break;
                    case 1:
                      isStatusTrue =
                          widget.order.orderStage!.collectedByRider.status;
                      break;
                    case 2:
                      isStatusTrue = widget.order.orderStage!.inProgress.status;
                      break;
                    case 3:
                      isStatusTrue =
                          widget.order.orderStage!.processingComplete.status;
                      break;
                    case 4:
                      isStatusTrue =
                          widget.order.orderStage!.outForDelivery.status;
                      break;
                    case 5:
                      isStatusTrue =
                          widget.order.orderStage!.readyForCollection.status;
                      break;
                    case 6:
                      isStatusTrue = widget.order.orderStage!.completed.status;
                      break;
                    default:
                      isStatusTrue = false;
                  }

                  String statusKey = statusFields[statusIcons[index].title]!;

                  return isStatusTrue
                      ? Row(
                          children: [
                            Image.asset(
                              statusIcons[index].icon,
                              width: 100,
                              height: 100,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // Use the dateUpdated from the OrderStage model
                                    widget.order.orderStage![statusKey]
                                                .dateUpdated !=
                                            null
                                        ? widget.order.getFormattedDateTime(
                                            widget.order.orderStage![statusKey]
                                                .dateUpdated
                                                .toString())
                                        : 'N/A',
                                    style: isStatusTrue
                                        ? CTextTheme
                                            .blackTextTheme.headlineSmall
                                        : CTextTheme
                                            .greyTextTheme.headlineSmall,
                                  ),
                                  Text(
                                    statusIcons[index].title,
                                    style:
                                        CTextTheme.blueTextTheme.headlineMedium,
                                  ),
                                ]),
                          ],
                        )
                      : Row(
                          children: [
                            Image.asset(
                              statusIconsGrey[index].icon,
                              width: 100,
                              height: 100,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'N/A',
                                    style: isStatusTrue
                                        ? CTextTheme
                                            .blackTextTheme.headlineSmall
                                        : CTextTheme
                                            .greyTextTheme.headlineSmall,
                                  ),
                                  Text(
                                    statusIcons[index].title,
                                    style:
                                        CTextTheme.greyTextTheme.headlineMedium,
                                  ),
                                ]),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TimelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    double lineX = 50;

    canvas.drawLine(Offset(lineX, 30), Offset(lineX, 370), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StatusItem {
  final String date;
  final String title;
  final String icon;

  StatusItem({required this.date, required this.title, required this.icon});
}

//   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cReservedIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'YOOO',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Reserved',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cDropOffIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 23',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Drop Off',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cCollectedOperatorIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 23',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Collected By Operator',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cInProgressIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 24',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'In Progress',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cPrepCompletionIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 25',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Preparation Completed',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cDeliveryIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 26',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Out Of Delivery',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cCollectionIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 26',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Ready For Collection',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //       children: [
        //         Image.asset(cCompleteIcon),
        //         const SizedBox(width: 20),
        //         SizedBox(
        //           width: size.width * 0.6,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'NOV 26',
        //                 style: CTextTheme.blackTextTheme.labelLarge,
        //               ),
        //               Text(
        //                 'Completed',
        //                 style: CTextTheme.blueTextTheme.headlineMedium,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),