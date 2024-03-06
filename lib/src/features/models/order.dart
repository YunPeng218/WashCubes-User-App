import 'package:device_run_test/src/features/models/user.dart';
import 'package:intl/intl.dart';

// DEFINE ORDER CLASS
class Order {
  final String id;
  final String orderNumber;
  final User? user;
  final OrderLockerDetails? lockerDetails;
  final CollectionLockerDetails? collectionSite;
  final String serviceId;
  final List<OrderItem> orderItems;
  final double estimatedPrice;
  final OrderStage? orderStage;
  final String createdAt;
  final int v;

  Order({
    required this.id,
    required this.orderNumber,
    required this.user,
    required this.lockerDetails,
    required this.collectionSite,
    required this.serviceId,
    required this.orderItems,
    required this.estimatedPrice,
    required this.orderStage,
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
      collectionSite: json['collectionSite'] != null
          ? CollectionLockerDetails.fromJson(json['collectionSite'])
          : null,
      serviceId: json['service'] ?? '',
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      estimatedPrice: json['estimatedPrice'].toDouble() ?? 0.0,
      orderStage: json['orderStage'] != null
          ? OrderStage.fromJson(json['orderStage'])
          : null, //
      createdAt: json['createdAt'] ?? '',
      v: json['__v'] ?? 0,
    ));
  }

  String getFormattedDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    final timeZoneOffset = Duration(hours: 8);
    dateTime = dateTime.add(timeZoneOffset);
    String formattedDate = DateFormat.yMMMd().format(dateTime);
    String formattedTime = DateFormat.jm().format(dateTime);
    return '$formattedDate / $formattedTime';
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

class CollectionLockerDetails {
  final String lockerSiteId;

  CollectionLockerDetails({required this.lockerSiteId});

  factory CollectionLockerDetails.fromJson(Map<String, dynamic> json) {
    return (CollectionLockerDetails(lockerSiteId: json['lockerSiteId'] ?? ''));
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

class OrderStage {
  OrderStatus dropOff;
  OrderStatus collectedByRider;
  OrderStatus inProgress;
  OrderStatus processingComplete;
  OrderStatus outForDelivery;
  OrderStatus readyForCollection;
  OrderStatus completed;
  OrderStatus orderError;

  OrderStage({
    required this.dropOff,
    required this.collectedByRider,
    required this.inProgress,
    required this.processingComplete,
    required this.outForDelivery,
    required this.readyForCollection,
    required this.completed,
    required this.orderError,
  });

  factory OrderStage.fromJson(Map<String, dynamic> json) {
    return OrderStage(
      dropOff: OrderStatus.fromJson(json['dropOff']),
      collectedByRider: OrderStatus.fromJson(json['collectedByRider']),
      inProgress: OrderStatus.fromJson(json['inProgress']),
      processingComplete: OrderStatus.fromJson(json['processingComplete']),
      outForDelivery: OrderStatus.fromJson(json['outForDelivery']),
      readyForCollection: OrderStatus.fromJson(json['readyForCollection']),
      completed: OrderStatus.fromJson(json['completed']),
      orderError: OrderStatus.fromJson(json['orderError']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dropOff': dropOff.toJson(),
      'collectedByRider': collectedByRider.toJson(),
      'inProgress': inProgress.toJson(),
      'processingComplete': processingComplete.toJson(),
      'outForDelivery': outForDelivery.toJson(),
      'readyForCollection': readyForCollection.toJson(),
      'completed': completed.toJson(),
      'orderError': orderError.toJson(),
    };
  }

  OrderStatus operator [](String key) {
    switch (key) {
      case 'dropOff':
        return dropOff;
      case 'collectedByRider':
        return collectedByRider;
      case 'inProgress':
        return inProgress;
      case 'processingComplete':
        return processingComplete;
      case 'outForDelivery':
        return outForDelivery;
      case 'readyForCollection':
        return readyForCollection;
      case 'completed':
        return completed;
      case 'orderError':
        return orderError;

      default:
        throw ArgumentError('Invalid status key: $key');
    }
  }

  String getMostRecentStatus() {
    if (orderError.status) {
      return 'Order Error';
    }
    if (completed.status) {
      return 'Completed';
    }
    if (readyForCollection.status) {
      return 'Ready For Collection';
    }
    if (outForDelivery.status) {
      return 'Out For Delivery';
    }
    if (processingComplete.status) {
      return 'Processing Complete';
    }
    if (inProgress.status) {
      return 'In Progress';
    }
    if (collectedByRider.status) {
      return 'Collected By Rider';
    }
    if (dropOff.status) {
      return 'Drop Off';
    }
    return 'Drop Off Pending';
  }

  DateTime? getMostRecentDateUpdated() {
    List<DateTime?> dateUpdatedList = [
      dropOff.dateUpdated,
      collectedByRider.dateUpdated,
      inProgress.dateUpdated,
      processingComplete.dateUpdated,
      outForDelivery.dateUpdated,
      readyForCollection.dateUpdated,
      completed.dateUpdated,
      orderError.dateUpdated,
    ];

    dateUpdatedList.removeWhere((date) => date == null);

    if (dateUpdatedList.isEmpty) {
      return null;
    }

    return dateUpdatedList
        .reduce((maxDate, date) => date!.isAfter(maxDate!) ? date : maxDate);
  }
}

class OrderStatus {
  bool status;
  DateTime? dateUpdated;

  OrderStatus({
    required this.status,
    this.dateUpdated,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      status: json['status'] ?? false,
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.parse(json['dateUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'dateUpdated': dateUpdated?.toIso8601String(),
    };
  }
}
