import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/order.dart';

class OrderErrorStatusWidget extends StatefulWidget {
  final Order order;
  const OrderErrorStatusWidget({super.key, required this.order});

  @override
  State<OrderErrorStatusWidget> createState() => OrderErrorStatusWidgetState();
}

class OrderErrorStatusWidgetState extends State<OrderErrorStatusWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<StatusItem> statusIcons = [
      StatusItem(
          date: '23 NOV', title: 'Return Processed', icon: cPrepCompletionIcon),
      StatusItem(
          date: '23 NOV', title: 'Out For Delivery', icon: cDeliveryIcon),
      StatusItem(
          date: '23 NOV', title: 'Ready For Collection', icon: cCollectionIcon),
      StatusItem(date: '23 NOV', title: 'Completed', icon: cCompleteIcon),
    ];

    final List<StatusItem> statusIconsGrey = [
      StatusItem(
          date: '23 NOV',
          title: 'Return Processed',
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
      'Return Processed': 'returnProcessed',
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
                          widget.order.orderStage?.orderError.returnProcessed ??
                              false;
                      break;
                    case 1:
                      isStatusTrue =
                          widget.order.orderStage?.outForDelivery.status ??
                              false;
                      break;
                    case 2:
                      isStatusTrue =
                          widget.order.orderStage?.readyForCollection.status ??
                              false;
                      break;
                    case 3:
                      isStatusTrue =
                          widget.order.orderStage?.completed.status ?? false;
                      break;
                    default:
                      isStatusTrue = false;
                  }

                  String statusKey =
                      statusFields[statusIcons[index].title] ?? '';
                  String? dateUpdated = widget
                      .order.orderStage![statusKey].dateUpdated
                      ?.toString();

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
                                    dateUpdated != null
                                        ? widget.order
                                            .getFormattedDateTime(dateUpdated)
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
