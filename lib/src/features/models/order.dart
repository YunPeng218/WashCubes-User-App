import 'package:device_run_test/src/features/models/user.dart';

// DEFINE ORDER CLASS
class Order {
  final String id;
  final String orderNumber;
  final User? user;
  final OrderLockerDetails? lockerDetails;
  final String serviceId;
  final List<OrderItem> orderItems;
  final double estimatedPrice;
  final String orderStatus;
  final String createdAt;
  final int v;

  Order({
    required this.id,
    required this.orderNumber,
    required this.user,
    required this.lockerDetails,
    required this.serviceId,
    required this.orderItems,
    required this.estimatedPrice,
    required this.orderStatus,
    required this.createdAt,
    required this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return (Order(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      lockerDetails: json['locker'] != null
          ? OrderLockerDetails.fromJson(json['locker'])
          : null,
      serviceId: json['service'] ?? '',
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      estimatedPrice: json['estimatedPrice'].toDouble() ?? 0.0,
      orderStatus: json['orderStatus'] ?? '',
      createdAt: json['createdAt'] ?? '',
      v: json['__v'] ?? 0,
    ));
  }
}

class OrderLockerDetails {
  final String lockerSiteId;
  final String compartmentId;
  final String compartmentNumber;

  OrderLockerDetails({
    required this.lockerSiteId,
    required this.compartmentId,
    required this.compartmentNumber,
  });

  factory OrderLockerDetails.fromJson(Map<String, dynamic> json) {
    return (OrderLockerDetails(
      lockerSiteId: json['lockerSiteId'] ?? '',
      compartmentId: json['compartmentId'] ?? '',
      compartmentNumber: json['compartmentNumber'] ?? '',
    ));
  }
}

class OrderItem {
  final String id;
  final String name;
  final String unit;
  final double price;
  final int quantity;
  final double cumPrice;

  OrderItem(
      {required this.id,
      required this.name,
      required this.unit,
      required this.price,
      required this.quantity,
      required this.cumPrice});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return (OrderItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      price: json['price'].toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      cumPrice: json['cumPrice'].toDouble() ?? 0.0,
    ));
  }
}
