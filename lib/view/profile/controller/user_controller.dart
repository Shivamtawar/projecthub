import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/model/user_info_model.dart';

class UserController {

  Future<Map> addUser(NewUserInfo newUserInfo) async {
    log(newUserInfo.userName);
    final basUrl = ApiConfig.addUser;
    final url = Uri.parse(basUrl);
    //log('$basUrl/');

    Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    final body = newUserInfo.toJson();
    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Response: ${response.body}');
        return {"isadded": true, "data": jsonDecode(response.body)};
      } else {
        // Handle the error
        return {"isadded": false, "data": jsonDecode(response.body)};
      }
    } catch (e) {
      log("error $e");
    }
    return {"isadded": false, "data": "user addition failed"};
  }

  Future<UserModel> fetchUserDetailsById(int id) async {
    final basUrl = ApiConfig.getUserDetailsByID;
    final url = Uri.parse('$basUrl/$id');
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.body);
        return UserModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception("Failed to load user details");
      }
    } catch (e) {
      throw Exception("Failed to load user details $e");
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> data) async {
    final baseUrl = ApiConfig.updateUser;
    final url = '$baseUrl/$userId';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    final Dio _dio = Dio();

    // Check if profile_photo exists and convert it to MultipartFile
    if (data.containsKey("profile_photo") && data["profile_photo"] is String) {
      String filePath = data["profile_photo"];
      data["profile_photo"] = await MultipartFile.fromFile(
        filePath,
        filename: basename(filePath), // Extract filename
      );
    }

    FormData formData = FormData.fromMap(data);

    try {
      final response = await _dio.patch(
        url,
        data: formData,
        options: Options(headers: headers), // Specify headers
      );

      if (response.statusCode == 200) {
        log("User updated successfully");
      } else if (response.statusCode == 400) {
        log("no failed to update user");
      }
    } catch (e) {
      log("Failed to update user: $e");
      throw Exception("Failed to update user details: $e");
    }
  }
}
