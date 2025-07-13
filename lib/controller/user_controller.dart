import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
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
}
