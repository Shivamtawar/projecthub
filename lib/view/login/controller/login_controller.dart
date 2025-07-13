//This model is only work for indianed mobile number beacuse it has prifix +91 join
// to make working for all contries handel contry code logic

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';

class LoginController {
  Future<Map> checkLogindetails(String userKey, String userPassword) async {
    final url = ApiConfig.checkLogindetails;
    Uri uri = Uri.parse(url);
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      'user_key': '+91$userKey',
      'user_password': userPassword
    };

    try {
      http.Response response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(body),
      );
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log("error $e");
    }
    return {'status': 'False', 'massage': "Error during making request"};
  }
}
