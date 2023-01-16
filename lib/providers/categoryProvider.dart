import 'package:api_project/models/category.dart';
import 'package:api_project/providers/authProvider.dart';
import 'package:api_project/services/api.dart';
import 'package:flutter/material.dart';


class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  CategoryProvider(this.authProvider) {
    init();
  }

  Future init() async {
    apiService = ApiService(authProvider.token);
    categories = await apiService.fetchCategories();
    notifyListeners();
  }
  void clear(){
    categories=[];
    notifyListeners();
  }
  Future<void> addCategory(String name) async {
    try {
      Category addedCategory = await apiService.addCategory(name);
      categories.add(addedCategory);

      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      Category updatedCategory = await apiService.updateCategory(category);
      int index = categories.indexOf(category);
      categories[index] = updatedCategory;

      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      await apiService.deleteCategory(category.id);

      categories.remove(category);
      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }
}