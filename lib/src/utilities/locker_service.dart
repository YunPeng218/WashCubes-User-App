import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/config.dart';

class LockerService extends ChangeNotifier {
  Future<int?> freeUpLockerCompartment(
      LockerSite? lockerSite, LockerCompartment? compartment) async {
    try {
      if (compartment != null) {
        Map<String, dynamic> compartmentToRelease = {
          'lockerSiteId': lockerSite?.id,
          'compartmentId': compartment.id,
        };

        final response = await http.post(
          Uri.parse(url + 'locker/release-compartment'),
          body: json.encode(compartmentToRelease),
          headers: {'Content-Type': 'application/json'},
        );

        return response.statusCode;
      } else {
        return null;
      }
    } catch (error) {
      print('Error releasing compartment: $error');
      return null;
    }
  }
}
