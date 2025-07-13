import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projecthub/config/api_config.dart';

class AppPhoneNumberController {
  Future<bool> checkPhoneNumberAlreadyExit(String phone) async {
    final url = ApiConfig.checkNumber;
    final uri = Uri.parse(url);
    final header = {
      'Content-Type': 'application/json',
    };

    final body = {'user_contact': phone};
    try {
      final response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['userExist'] == "True") {
          return true;
        }

        return false;
      } else {
        Get.snackbar("Something went wrong", "please try again");
      }
    } catch (e) {
      log("error $e");
    }
    return true;
  }
}
