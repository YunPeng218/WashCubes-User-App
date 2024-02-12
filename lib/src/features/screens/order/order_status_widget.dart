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
  void initState() {
    super.initState();
    print('widget.order: ${widget.order}');
    print(
        'widget.order.orderStage AHHHHHh: ${widget.order.orderStage?.dropOff.status ?? 'FUCK'}');
  }

  @override
  Widget build(BuildContext context) {
    final List<StatusItem> statusIcons = [
      StatusItem(date: '23 NOV', title: 'Drop Off', icon: cDropOffIcon),
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
      StatusItem(date: '23 NOV', title: 'Drop Off', icon: cDropOffIconGrey),
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
      'Drop Off': 'dropOff',
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
                          widget.order.orderStage?.dropOff.status ?? false;
                      break;
                    case 1:
                      isStatusTrue =
                          widget.order.orderStage?.collectedByRider.status ??
                              false;
                      break;
                    case 2:
                      isStatusTrue =
                          widget.order.orderStage?.inProgress.status ?? false;
                      break;
                    case 3:
                      isStatusTrue =
                          widget.order.orderStage?.processingComplete.status ??
                              false;
                      break;
                    case 4:
                      isStatusTrue =
                          widget.order.orderStage?.outForDelivery.status ??
                              false;
                      break;
                    case 5:
                      isStatusTrue =
                          widget.order.orderStage?.readyForCollection.status ??
                              false;
                      break;
                    case 6:
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
