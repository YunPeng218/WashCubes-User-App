import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/config.dart';

class OrderHelper {
  // GET ALL ORDERS FOR A USER
  Future<List<Order>?> getUserOrders(String? userId) async {
    try {
      final response = await http.get(
        Uri.parse('${url}orders/user?userId=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('orders')) {
          final List<dynamic> orderData = data['orders'];
          final List<Order> fetchedOrders =
              orderData.map((order) => Order.fromJson(order)).toList();
          return fetchedOrders;
        } else {
          print('Response data does not contain services.');
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }
}
