import 'package:flutter/material.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/features/models/order.dart';

class GuestModeProvider extends ChangeNotifier {
  bool _guestMode = false;
  bool _guestMadeOrder = false;
  LockerSite? lockerSite;
  String? selectedCompartmentSize;
  Service? service;
  Order? order;

  bool get guestMode => _guestMode;
  bool get guestMadeOrder => _guestMadeOrder;
  Order? get guestOrder => order;
  LockerSite? get guestLockerSite => lockerSite;
  String? get guestSelectedCompartmentSize => selectedCompartmentSize;
  Service? get guestService => service;

  void setGuestMode(bool visited) {
    _guestMode = visited;
    //notifyListeners();
  }

  void setGuestMadeOrder(bool madeOrder) {
    _guestMadeOrder = madeOrder;
    //notifyListeners();
  }

  void setGuestOrderDetails(Order? order, Service? service, LockerSite? site,
      String? selectedCompartmentSize) {
    this.order = order;
    this.service = service;
    this.lockerSite = site;
    this.selectedCompartmentSize = selectedCompartmentSize;
    //notifyListeners();
  }
}
