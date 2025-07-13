import 'package:flutter/material.dart';
import 'package:projecthub/controller/user_controller.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/model/user_info_model.dart';

class UserInfoProvider extends ChangeNotifier {
  UserModel? _user;

  // ignore: prefer_final_fields

  // ignore: prefer_final_fields
  List<Creation> _userPurchasedCreations = [
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
  ];
  List<Creation> _userInCartCreation = [
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
    Creation.fromJson({
      'title': 'Modern Template',
      'subtitle': 'A stunning modern template for websites.',
      'imagePath': 'assets/images/c1.jpg',
      'price': 29.99,
      'rating': 4.5,
      'seller': {
        'id': 1,
        'name': 'John Doe',
        'image': 'assets/images/user_image.png',
      }
    }),
  ];

  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch creations data and update state
  Future<void> fetchUserDetails(userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));

    notifyListeners();
    try {
      _user = await UserController().fetchUserDetailsById(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
    }
    _isLoading = false;
    notifyListeners();
  }



  UserModel get getUserInfo => _user!;
  List<Creation> get userPerchedCreations => _userPurchasedCreations;
  List<Creation> get userInCartCreation => _userInCartCreation;
}
