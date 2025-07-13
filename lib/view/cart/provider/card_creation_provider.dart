import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../controller/creation_controller.dart';
import '../model/incard_creation_model.dart';

class InCardCreationProvider extends ChangeNotifier {
  List<InCardCreationInfo>? _creations;
  int page = 1;
  int perPage = 10;
  bool _isLoading = false;
  String _errorMessage = '';
  List<InCardCreationInfo>? get creations => _creations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  void reset() {
    _creations = null; // Clear data
    notifyListeners();
  }

  Future<void> fetchInCardCreations(int userId) async {
    log("to fetch in card creations");
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 10));
    notifyListeners();
    try {
      _creations = await CreationController().fetchUserInCardCreations(userId);
      _errorMessage = ''; // Clear any previous error
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      //throw Exception("failed to feach in crad creations $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // Method to remove an item from the card
  Future<void> removeItemFromCard(int userId, int cardItemId) async {
    try {
      // Call the controller method to remove the item
      await CreationController().removeItemFromCard(userId, cardItemId);

      // Optionally, update the local state by removing the item
      _creations!.removeWhere((item) => item.carditemId == cardItemId);

      // Notify listeners about the state change
      notifyListeners();
    } catch (e) {
      // Handle any errors that may occur
      debugPrint("Error removing item from card: $e");
      rethrow; // Optionally rethrow to handle the error higher up
    }
  }
}
