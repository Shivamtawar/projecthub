import 'dart:convert';
import 'dart:developer';

import 'package:projecthub/view/purchase/model/purched_creation_details_model.dart';

import '../../../config/api_config.dart';
import 'package:http/http.dart' as http;

import '../model/purched_creation_model.dart';

class PuechasedCreationController {
  Future<List<PurchedCreationModel>> fetchPurchedCreations(
      int userId, int page, int perPage) async {
    try {
      final response = await http.get(Uri.parse(
          "${ApiConfig.getPurchedCreations(page, perPage)}?user_id=$userId"));
      log(response.body);
      if (response.statusCode == 200) {
        log("pppppp");
        List<dynamic> data = jsonDecode(response.body)['data'];

        return data.map((json) => PurchedCreationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<PurchaseDetails> fetchPurchedCreationDetails(
      int userId, int creationId) async {
    try {
      final response = await http.get(
          Uri.parse(ApiConfig.getPurchedCreationDetails(userId, creationId)));
      log(response.body);
      if (response.statusCode == 200) {
        log("pppppp");
        Map<String, dynamic> data = jsonDecode(response.body)['data'];

        return PurchaseDetails.fromJson(data);
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }
}
