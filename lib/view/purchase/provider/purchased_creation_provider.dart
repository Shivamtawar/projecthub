import 'package:flutter/material.dart';
import 'package:projecthub/view/purchase/model/purched_creation_details_model.dart';
import '../controller/puechased_creation_controller.dart';
import '../model/purched_creation_model.dart';

class PurchedCreationProvider extends ChangeNotifier {
  List<PurchedCreationModel>? _purchedCreations;
  List<PurchedCreationModel>? _filteredCreations;
  List<PurchedCreationModel>? get filteredCreations => _filteredCreations;
  PurchaseDetails? _purchedCreationDetails;
  PurchaseDetails? get purchedCreationDetails => _purchedCreationDetails;
  int page = 1;
  int perPage = 10;
  bool _isLoading = false;
  bool _isDetailsLoading = false;
  String _errorMessage = '';
  String _detailScreenErrorMessage = '';
  List<PurchedCreationModel>? get purchedCreations => _purchedCreations;
  bool get isLoading => _isLoading;
  bool get isDetailsLoading => _isDetailsLoading;
  String get errorMessage => _errorMessage;
  String get detailScreenErrorMessage => _detailScreenErrorMessage;
  final _puechasedCreationController = PuechasedCreationController();

  void reset() {
    _errorMessage = '';
    _detailScreenErrorMessage = '';
    _isLoading = false;
    _purchedCreations = null; // Clear data
    notifyListeners();
  }

  setIsDetailsLoading(bool isLoading) {
    _isDetailsLoading = isLoading;
    notifyListeners();
  }

  setFilteredCreations(List<PurchedCreationModel>? creations) {
    _filteredCreations = creations;
    notifyListeners();
  }

  Future<void> fetchUserPurchedCreation(int userId) async {
    List<PurchedCreationModel>? newFetchedCreations;

    if (_purchedCreations != null) {
      await fetchMoreUserPurchedCreation(userId);
      return;
    }
    _isLoading = true;
    await Future.delayed(const Duration(microseconds: 5));

    notifyListeners();
    try {
      newFetchedCreations = await _puechasedCreationController
          .fetchPurchedCreations(userId, page, perPage);
      _purchedCreations = newFetchedCreations;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach purched creations $e");
    } finally {
      _isLoading = false;
      if (newFetchedCreations != null && newFetchedCreations.length == 10) {
        page++;
      }
      notifyListeners();
    }
  }

  Future<void> fetchMoreUserPurchedCreation(int userId) async {
    List<PurchedCreationModel>? newFetchedCreations;

    if (_purchedCreations == null) {
      _isLoading = true;
      await Future.delayed(const Duration(microseconds: 5));
      notifyListeners();
    }
    try {
      newFetchedCreations = await _puechasedCreationController
          .fetchPurchedCreations(userId, page, perPage);
      _purchedCreations = newFetchedCreations;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch creations: $e';
      throw Exception("failed to feach purched creations $e");
    }
    _isLoading = false;
    if (newFetchedCreations.length == (perPage + 1)) {
      page++;
    }
    notifyListeners();
  }

  Future<void> fetchPurchedCreationDetails(int userId, int creationId) async {
    setIsDetailsLoading(true);
    try {
      _purchedCreationDetails = await _puechasedCreationController
          .fetchPurchedCreationDetails(userId, creationId);
      _errorMessage = '';
    } catch (e) {
      _detailScreenErrorMessage = 'Failed to fetch creations: $e';
      // throw Exception("failed to feach purched creations $e");
    } finally {
      setIsDetailsLoading(false);
    }
  }
}
