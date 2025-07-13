import 'dart:convert';
import 'dart:developer';

import 'package:projecthub/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:projecthub/model/creation_model.dart';

class SearchedCreationController {
  Future<List<Creation>> getSearchedCreation(
      {required String query,
      required int userId,
      required int offset,
      required int limit}) async {
    final url =
        "${ApiConfig.getSearchedCreation}?limit=$limit&offset=$offset&user_query=$query&user_id=$userId";

    try {
      final response = await http.get(Uri.parse(url));
      log(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];

        return data.map((json) => Creation.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        log("No creation found for query ");
        throw Exception('No creation found for query');
      } else {
        throw Exception('No creation found for query');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
