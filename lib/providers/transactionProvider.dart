import 'package:api_project/models/category.dart';
import 'package:api_project/providers/authProvider.dart';
import 'package:api_project/services/api.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> transactions = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  TransactionProvider(this.authProvider) {
    init();
  }

  Future init() async {
    apiService = ApiService(authProvider.token);
    print(authProvider.token);
    transactions = await apiService.fetchTransactions();
    notifyListeners();
  }
  void clear(){
    transactions=[];
    notifyListeners();
  }

  Future<void> addTransaction(String amount, String category, String description, String date) async {
    try {
      Transaction addedTransaction = await apiService.addTransaction(amount, category, description, date);
      transactions.add(addedTransaction);

      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      Transaction updatedTransaction = await apiService.updateTransaction(transaction);
      int index = transactions.indexOf(transaction);
      transactions[index] = updatedTransaction;

      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      await apiService.deleteTransaction(transaction.id);

      transactions.remove(transaction);
      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }
}