import 'dart:convert';
import 'dart:developer';

import 'package:projecthub/view/home/model/categories_info_model.dart';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';

class CategoryController {
  Future<List<CategoryModel>> fetchCategories(int userId) async {
    try {
      final response =
          await http.get(Uri.parse("${ApiConfig.categories}/$userId"));
      log(response.body);
      if (response.statusCode == 200) {
        log("pppppp");
        List<dynamic> data = jsonDecode(response.body)['data'];

        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
