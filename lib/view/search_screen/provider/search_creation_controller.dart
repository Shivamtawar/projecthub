import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../model/creation_model.dart';
import '../controller/searched_creation_controller.dart';

class SearchedCreationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMassage = '';
  List<Creation>? _seachedCreations;
  int offset = 0;
  int limit = 5;

  final SearchedCreationController _searchedCreationController =
      SearchedCreationController();

  bool get isLoading => _isLoading;
  String get errormassage => _errorMassage;
  List<Creation>? get searchedCreations => _seachedCreations;

  setLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  reset() {
    offset = 0;
    _seachedCreations = null;
    _errorMassage = '';
  }

  Future<void> fetchSearchedCreation(
      String query, int userId, bool isFirstCall) async {
    if (isFirstCall) {
      reset();
    }
    setLoading(true);
    try {
      final newFetchedCreations =
          await _searchedCreationController.getSearchedCreation(
              query: query, userId: userId, offset: offset, limit: limit);
      if (isFirstCall) {
        _seachedCreations = newFetchedCreations;
      } else {
        _seachedCreations!.addAll(newFetchedCreations);
      }
      offset += newFetchedCreations.length; // Update the offset for pagination
    } catch (e) {
      _errorMassage = 'Failed to fetch searched creation creations: $e';
      log(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
