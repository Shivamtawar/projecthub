import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projecthub/view/profile/controller/user_controller.dart';
import 'package:projecthub/model/user_info_model.dart';

class UserInfoProvider extends ChangeNotifier {
  UserModel? _user;

  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  UserModel get getUserInfo => _user!;

  void setEmail(String email) {
    _user!.userEmail = email;
    notifyListeners();
  }

  void setMobileNumber(String mobileNumber) {
    _user!.userName = mobileNumber;
    notifyListeners();
  }

  void setDescription(String des) {
    _user!.userDescription = des;
    notifyListeners();
  }

  void setUserName(String name) {
    _user!.userName = name;
    notifyListeners();
  }

  void setLocation(Position location) {
    _user!.userLocation = location;
    notifyListeners();
  }

  void reset() {
    _user = null; // Clear data
    notifyListeners();
  }

  // Fetch creations data and update state
  Future<void> fetchUserDetails(userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));

    notifyListeners();
    try {
      _user = await UserController().fetchUserDetailsById(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch user details: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(userId, data) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (data.isNotEmpty) {
        await UserController().updateUser(userId, data);
      }
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to update user details: $e';
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }
}
