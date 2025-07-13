// services/payment_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';

import '../model/transaction_model.dart';

class TransactionController {
  Future<List<TransactionModel>> getUserTransactions(int userId) async {
    String baseUrl = ApiConfig.getUserTransactions(userId);
    final response = await http.get(
      Uri.parse(baseUrl),
    );
    log(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

//   Future<Payment> getTransactionDetails(int paymentId) async {
//   //   final response = await http.get(
//   //     Uri.parse('$baseUrl/transactions/$paymentId'),
//   //     headers: {'Authorization': 'Bearer your_token'},
//   //   );

//   //   if (response.statusCode == 200) {
//   //     return Payment.fromJson(json.decode(response.body));
//   //   } else {
//   //     throw Exception('Failed to load transaction details');
//   //   }
//   // }
}
