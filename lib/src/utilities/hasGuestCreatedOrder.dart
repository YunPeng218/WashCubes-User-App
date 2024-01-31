import 'package:flutter/material.dart';

class GuestVisitedOrderSummaryProvider extends ChangeNotifier {
  bool _guestVisitedOrderSummary = false;

  bool get guestVisitedOrderSummary => _guestVisitedOrderSummary;

  void setGuestVisitedOrderSummary(bool visited) {
    _guestVisitedOrderSummary = visited;
    //notifyListeners();
  }
}
