import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';
import '../model/advertisement_model.dart';

class AdvertisementController {
  Future<List<AdvertisementModel>> fetchAdvertisements(
      int userId, String location) async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.getAdvertisements(userId, location)));
      log(response.body.toString());
      if (response.statusCode == 200) {
        log("pppppp");
        List<dynamic> data = jsonDecode(response.body)['advertisements'];

        return data.map((json) => AdvertisementModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch advertisements');
      }
    } catch (e) {
      throw Exception('Failed to fetch advertisements: $e');
    }
  }

  // Add your advertisement-related logic here
  void createAdvertisement(String title, String description) {
    // Logic to create an advertisement
    print('Advertisement created: $title - $description');
  }

  void deleteAdvertisement(int id) {
    // Logic to delete an advertisement
    print('Advertisement deleted with ID: $id');
  }

  void updateAdvertisement(int id, String title, String description) {
    // Logic to update an advertisement
    print('Advertisement updated: $id - $title - $description');
  }
}
