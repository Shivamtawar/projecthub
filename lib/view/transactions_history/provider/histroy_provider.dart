import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projecthub/view/transactions_history/controller/transaction_controller.dart';

import '../model/transaction_model.dart';

class HistroyProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMassage;
  List<TransactionModel>? _transactions;

  TransactionController _transactionController = TransactionController();

  bool get isLoading => _isLoading;
  String? get errorMassage => _errorMassage;
  List<TransactionModel>? get transactions => _transactions;

  setLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  fetchTransactions(int userId) async {
    _errorMassage = null;
    setLoading(true);
    _transactions = await _transactionController.getUserTransactions(userId);
    try {} catch (e) {
      _errorMassage = e.toString();
    }
    setLoading(false);
  }
}
