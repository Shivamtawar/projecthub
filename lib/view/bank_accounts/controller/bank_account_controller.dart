import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:projecthub/config/api_config.dart';
import '../model/bank_account_model.dart';
import 'package:http/http.dart' as http;

class BankAccountController {
  Future<List<BankAccount>> fetchUserBankAccounts(int userId) async {
    try {
      final response = await http
          .get(Uri.parse("${ApiConfig.getBankAccount}?user_id=$userId"));

      log(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => BankAccount.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        throw Exception('Bad request. Please check the user ID or input.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found. Please check the user ID.');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error. Please try again later.');
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again later.');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> addUserBankAccounts(Map json) async {
    try {
      final header = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode(json); // Ensure the body is properly encoded
      final response = await http.post(
        Uri.parse(ApiConfig.addBankAccount),
        headers: header,
        body: body,
      );

      if (response.statusCode == 201) {
        // Handle success
        print("Bank account added successfully.");
      } else if (response.statusCode == 400) {
        // Handle client-side error (e.g., validation issues)
        final errorMessage =
            jsonDecode(response.body)['error'] ?? 'Bad Request';
        throw Exception("$errorMessage");
      } else if (response.statusCode == 500) {
        // Handle server-side error
        throw Exception("Server Error: Please try again later.");
      } else {
        // Handle other unexpected status codes
        throw Exception(
            "Unexpected Error: ${response.statusCode}, ${response.body}");
      }
    } on FormatException {
      // Handle JSON formatting errors
      throw Exception("Response formatting error. Invalid JSON received.");
    } on http.ClientException {
      // Handle HTTP client-side issues
      throw Exception("Network error. Please check your internet connection.");
    }
  }

  Future<void> setPrimaryBankAccount(int userId, int accountId) async {
    try {
      final response = await http.put(
        Uri.parse("${ApiConfig.setPrimaryBankAccount}/$userId/$accountId"),
      );

      if (response.statusCode == 200) {
        // Update the local accounts list
      } else {
        throw Exception('Failed to set primary account');
      }
    } catch (e) {
      throw Exception('Failed to set primary account:$e');
    }
  }
}
