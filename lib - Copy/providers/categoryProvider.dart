import 'package:api_project/providers/authProvider.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  late ApiService apiService;
  List<Category> categories = [];
  late AuthProvider authProvider;

  CategoryProvider(this.authProvider) {
    this.apiService = ApiService(authProvider.token);

    init();
  }

  Future init() async {
    categories = await apiService.fetchCategories();
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    try {
      Category updatedCategory = await apiService.updateCategory(category);
      int index = categories.indexOf(category);
      categories[index] = updatedCategory;
      notifyListeners();
    } catch (Exception) {
      print(Exception);
      await authProvider.logout();
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      await apiService.deleteCategory(category.id);
      categories.remove(category);
      notifyListeners();
    } catch (Exception) {
      print(Exception);
      await authProvider.logout();
    }
  }

  Future<void> addCategory(String name) async {
    try {
      Category addedCategory = await apiService.addCategory(name);
      categories.add(addedCategory);
      notifyListeners();
    } catch (Exception) {
      print(Exception);
      await authProvider.logout();
    }
  }
}
