/// This file defines the `CreationController` class, responsible for managing
/// the process of listing new creations. It uses the Dio package to handle HTTP
/// POST requests to the server. The class includes a method `listCreation`,
/// which sends creation data such as title, description, price, category ID,
/// keywords, additional images, and files (thumbnail and creation file) to the
/// server. The method also tracks the upload progress and updates it through a
/// callback function.
library;

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/view/user_listed_creation/model/listed_creation_model.dart';
import 'package:http/http.dart' as http;
import 'package:projecthub/view/cart/model/incard_creation_model.dart';
import 'package:projecthub/model/creation_model.dart';

import '../view/purchase/model/purched_creation_model.dart';

class CreationController {
  final Dio _dio = Dio();

  Future<int> listCreation(
      NewCreationModel creation, Function(double) onProgress) async {
    try {
      FormData formData = FormData.fromMap({
        'creation_title': creation.creationTitle,
        'creation_description': creation.creationDescription,
        'creation_price': creation.creationPrice,
        'category_id': creation.categoryId,
        'keyword': json.encode(creation.keyword),
        'otherImages': json.encode(creation.otherImages),
        'user_id': creation.userId,
        'creation_thumbnail': await MultipartFile.fromFile(
            creation.creationThumbnail.path,
            filename: creation.creationThumbnail.path),
        'creation_file': await MultipartFile.fromFile(
            creation.creationFile.path,
            filename: creation.creationFile.path),
        "youtube_link":
            (creation.youtubelink == "") ? null : creation.youtubelink,
      });

      Response response = await _dio.post(
        ApiConfig.listCreation,
        data: formData,
        onSendProgress: (int sent, int total) {
          // Update the progress
          double progress = sent / total;
          onProgress(progress);
        },
      );

      return response.statusCode ?? 500;
    } catch (e) {
      return 500;
    }
  }

  Future<List<ListedCreation>> fetchUserListedCreations(int userId) async {
    try {
      final response =
          await http.get(Uri.parse("${ApiConfig.userListedCreations}/$userId"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];

        log(response.body);
        return data.map((json) => ListedCreation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<List<Creation>> fetchGeneralCreations(
      int userId, int page, int perPage) async {
    log("pppppp");
    try {
      final response = await http.get(Uri.parse(
          "${ApiConfig.getGeneralCreationsUrl(page, perPage)}/$userId"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['creations'];

        // log(response.body);

        return data.map((json) => Creation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<List<Creation>> fetchRecentCreations(
      int userId, int page, int perPage) async {
    log("pppppp");
    try {
      final response = await http.get(Uri.parse(
          "${ApiConfig.getRecentaddedCreationUrl(page, perPage)}/$userId"));
      log(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['creations'];

        return data.map((json) => Creation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<List<Creation>> fetchTrendingCreations(
      int userId, int page, int perPage) async {
    log("pppppp");
    try {
      final response = await http.get(Uri.parse(
          "${ApiConfig.getTrendingCreations(page, perPage)}/$userId"));
      log(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['creations'];

        return data.map((json) => Creation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<List<PurchedCreationModel>> fetchPurchedCreations(
      int userId, int page, int perPage) async {
    try {
      final response = await http.get(
          Uri.parse("${ApiConfig.getPurchedCreations(page, perPage)}/$userId"));
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

  Future<List<Creation>> fetchRecomandedCreations(
      int userId, int pageNo, int perPage, Creation creation) async {
    final data = {"userId": userId, "creation": creation.toJson()};
    final header = {
      'Content-Type': 'application/json',
    };

    log(data.toString());
    try {
      final response = await http.post(
          Uri.parse(
              "${ApiConfig.getRecomandedCreations(pageNo, perPage)}/$userId"),
          body: jsonEncode(data),
          headers: header);
      log(response.body);
      if (response.statusCode == 200) {
        log("pppppp");
        List<dynamic> data = jsonDecode(response.body)['creations'];

        return data.map((json) => Creation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<void> addCreationInCard(int userId, int creationId) async {
    final data = {"userId": userId, "creationId": creationId};
    final header = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(Uri.parse(ApiConfig.addCreationToCard),
          body: jsonEncode(data), headers: header);
      log(response.body);
      if (response.statusCode == 200) {
        log("pppppp");
      } else {
        throw Exception('Failed to add creations in card');
      }
    } catch (e) {
      throw Exception('Failed to add creations in card: $e');
    }
  }

  Future<List<InCardCreationInfo>> fetchUserInCardCreations(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.incardCreations}/$userId"),
      );
      log(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];

        return data.map((json) => InCardCreationInfo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }

  Future<void> removeItemFromCard(int userId, int creationId) async {
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode({'user_id': userId, 'carditem_id': creationId});
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.removeItemFromCard),
        headers: header,
        body: body,
      );
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
      } else {
        throw Exception('Failed to load creations');
      }
    } catch (e) {
      throw Exception('Failed to load creations: $e');
    }
  }
}
