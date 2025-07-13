import 'package:flutter/material.dart';
import 'package:projecthub/view/advertisement/model/advertisement_model.dart';

import '../controller/advertisement_controller.dart';

class AdvertisementProvider extends ChangeNotifier {
  List<AdvertisementModel> _advertisements = [];
  bool _isLoading = false;
  final _advertisementController = AdvertisementController();

  List<AdvertisementModel> get advertisements => _advertisements;

  bool get isLoading => _isLoading;
  String? _errorMessage = "";
  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getAdvertisements(int userId, String city) async {
    errorMessage = null;
    isLoading = true;
    try {
      _advertisements =
          await _advertisementController.fetchAdvertisements(userId, city);
      if (advertisements.isEmpty) {
        errorMessage = "No advertisements found";
      } else {
        errorMessage = null;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  void addAdvertisement(AdvertisementModel advertisement) {
    _advertisements.add(advertisement);
    notifyListeners();
  }

  void removeAdvertisement(AdvertisementModel advertisement) {
    _advertisements.remove(advertisement);
    notifyListeners();
  }
}
