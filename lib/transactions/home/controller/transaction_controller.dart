import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart'
    as my_transaction;
import 'package:myfinance_app/transactions/home/model/category.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';
import 'package:collection/collection.dart';

class TransactionController extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int _selectedIcon = 14;

  int get selectedIcon => _selectedIcon;

  Category _selectedCategory =
      Category(name: 'أخرى', icon: 'assets/icons/expenses_icons/other.png');

  Category get selectedCategory => _selectedCategory;

  Wallet _selectedWallet = Wallet();

  Wallet get selectedWallet => _selectedWallet;

  void onChangeSelectedIcon(int selectedIconIndex) {
    _selectedIcon = selectedIconIndex;
    notifyListeners();
  }

  void onCategoryChange(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void onWalletChange(Wallet wallet) {
    _selectedWallet = wallet;
    notifyListeners();
  }

  Future<void> saveTransaction(my_transaction.Transaction transaction) async {
    _firestore
        .collection('Transactions')
        .withConverter(
            fromFirestore: my_transaction.Transaction.fromFirestore,
            toFirestore: (my_transaction.Transaction transaction, _) =>
                transaction.toFirestore())
        .add(transaction);
  }

  List<Map<String, dynamic>> groupExpenses(
      List<my_transaction.Transaction> transactions) {
    final expenses =
        transactions.where((element) => element.type == 'expense').toList();
    // group expenses by category name
    final groupedExpenses =
        groupBy(expenses, (expense) => expense.category!.name);

    final categorySummary = groupedExpenses.entries.map((entry) {
      final categoryName = entry.key;
      final transactions = entry.value;
      final categoryTotalAmount = transactions.fold(
          0.0,
          (previousValue, transaction) =>
              previousValue + transaction.category!.amount!);
      final categoryIcon = transactions.first.category!.icon;
      return {
        'name': categoryName,
        'icon': categoryIcon,
        'amount': categoryTotalAmount
      };
    }).toList();
    // Sort category summaries by amount
    categorySummary.sort(
        (a, b) => (a['amount'] as double).compareTo(b['amount'] as double));
    return categorySummary;
  }

  Stream<List<my_transaction.Transaction>> getTransactions() {
    return _firestore
        .collection('Transactions')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .withConverter(
            fromFirestore: my_transaction.Transaction.fromFirestore,
            toFirestore: (my_transaction.Transaction transaction, _) =>
                transaction.toFirestore())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  double calculateTotal(
      {required List<my_transaction.Transaction> transactions, String? type}) {
    if (type == null) {
      final realTransactions =
          transactions.where((element) => element.type != null);
      return realTransactions.fold(
          0.0,
          (previousValue, transaction) =>
              previousValue + transaction.category!.amount!);
    } else {
      final transactionsByType =
          transactions.where((element) => element.type == type).toList();
      return transactionsByType.fold(
          0.0,
          (previousValue, transaction) =>
              previousValue + transaction.category!.amount!);
    }
  }

  void clearSelections() {
    _selectedCategory =
        Category(name: 'أخرى', icon: 'assets/icons/expenses_icons/other.png');
    _selectedIcon = 14;
    _selectedWallet = Wallet();
    notifyListeners();
  }
}
