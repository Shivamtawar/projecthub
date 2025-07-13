import 'package:flutter/material.dart';
import 'package:projecthub/view/home/controller/category_controller.dart';

import '../model/categories_info_model.dart';

class CategoriesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<CategoryModel>? _categories;

  bool get isLoading => _isLoading;
  List<CategoryModel>? get categories => _categories;

  Future<void> fetchCategories(int userId) async {
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 5));
    notifyListeners();

    try {
      _categories = await CategoryController().fetchCategories(userId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
