import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projecthub/controller/order_controller.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> placeOrder(int userId,  paymentDetails, List products,String date) async {
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 10));
    notifyListeners();
    try {
      await OrderController().placeOrder(userId, paymentDetails, products,date);
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
