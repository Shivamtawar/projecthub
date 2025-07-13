import 'dart:convert';
import 'dart:developer';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/view/shorts/model/reel_model.dart';
import 'package:http/http.dart' as http;
import 'package:projecthub/model/user_info_model.dart';

class ReelsController {
  Future<List<ReelModel>> fetchReels(int userId, int limit, int offset) async {
    try {
      final url = Uri.parse(
          '${ApiConfig.getReels}?limit=$limit&offset=$offset&user_id=$userId');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];

        log(response.body);
        return data.map((json) => ReelModel.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        log("No reels found");
        throw Exception('Failed to load reels');
      } else {
        throw Exception('Failed to load reels');
      }
    } catch (e) {
      throw Exception('Failed to load reels: $e');
    }
  }

  Future addLike(int creationId, int userId) async {
    final header = {'Content-Type': 'application/json'};
    final body = {
      'user_id': userId,
      'creation_id': creationId,
    };

    final url = Uri.parse(ApiConfig.addLikeToReel);

    try {
      // Send POST request
      http.Response response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        log("like added successfully: ${response.body}");
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

  Future removeLike(int creationId, int userId) async {
    final header = {'Content-Type': 'application/json'};
    final body = {
      'user_id': userId,
      'creation_id': creationId,
    };

    final url = Uri.parse(ApiConfig.removeLikeToReel);

    try {
      // Send POST request
      http.Response response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        log("like added successfully: ${response.body}");
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

  Future<List<UserModel>> getLikeInfo(int reelId, int limit, int offset) async {
    try {
      final url = Uri.parse(
          '${ApiConfig.getLikeInfo}?limit=$limit&offset=$offset&reel_id=$reelId');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];

        log(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        log("No like found found");
        throw Exception('Failed to load reel like');
      } else {
        throw Exception('Failed to load reel like');
      }
    } catch (e) {
      rethrow;
    }
  }
}
