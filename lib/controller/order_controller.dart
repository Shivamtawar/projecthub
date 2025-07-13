import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';

class OrderController {
  Future<void> placeOrder(
      int userId, dynamic paymentDetails, List products, String date) async {
    final header = {'Content-Type': 'application/json'};
    final body = {
      'user_id': userId,
      'payment_details': paymentDetails,
      'product': products,
      'order_date': date,
    };

    log("Request Body: ${body.toString()}");

    final url = Uri.parse(ApiConfig.placeOrder);

    try {
      // Send POST request
      http.Response response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );

      // Check if the request was successful
      if (response.statusCode == 201) {
        log("Order placed successfully: ${response.body}");
        // Handle the response (you can parse it as needed)
      } else {
        log("Error placing order: ${response.statusCode}, ${response.body}");
        // You can throw or handle error accordingly
        throw Exception(
            'Failed to place order. Server responded with: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors such as network failure
      log("Error: $e");
      // Optionally throw or return the error for further handling
      throw Exception('Network or server error: $e');
    }
  }
}
