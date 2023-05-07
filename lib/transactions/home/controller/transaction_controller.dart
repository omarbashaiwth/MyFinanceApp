import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart'
    as my_transaction;
import 'package:myfinance_app/transactions/home/model/category.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';

class TransactionController extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int _selectedIcon = 14;

  int get selectedIcon => _selectedIcon;

  Category _selectedCategory =
      Category(category: 'أخرى', icon: 'assets/icons/expenses_icons/other.png');

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

  Stream<List<my_transaction.Transaction>> getTransactions() {
    final snapshots = _firestore
        .collection('Transactions')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('createdAt')
        .withConverter(
            fromFirestore: my_transaction.Transaction.fromFirestore,
            toFirestore: (my_transaction.Transaction transaction, _) => transaction.toFirestore())
        .snapshots();
    final docs = snapshots.map((event) => event.docs);
    return docs.map((event) => event.map((e) => e.data()).toList());
  }

  Stream<List<my_transaction.Transaction>> getFiveHighestExpense() {
    final snapshots = _firestore
        .collection('Transactions')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('type', isEqualTo: 'expense')
        .orderBy('amount')
        .limit(5)
        .withConverter(
        fromFirestore: my_transaction.Transaction.fromFirestore,
        toFirestore: (my_transaction.Transaction transaction, _) => transaction.toFirestore())
        .snapshots();
    final docs = snapshots.map((event) => event.docs);
    return docs.map((event) => event.map((e) => e.data()).toList());
  }

  double calculateTotalExpense(List<my_transaction.Transaction>? transactions){
    var totalExpenses = 0.0;
    if(transactions != null){
      final expenses = transactions.where((element) => element.type == 'expense').toList();
      final amounts = expenses.map((e) => e.amount).toList();
      for(var amount in amounts){
        totalExpenses += amount!;
      }
    }
    return totalExpenses;
  }

  double calculateTotalIncome(List<my_transaction.Transaction>? transactions){
    var totalIncome = 0.0;
    if(transactions != null){
      final expenses = transactions.where((element) => element.type == 'income').toList();
      final amounts = expenses.map((e) => e.amount).toList();
      for(var amount in amounts){
        totalIncome += amount!;
      }
    }
    return totalIncome;
  }

  double calculateDifference(List<my_transaction.Transaction>? transactions){
    final totalIncome = calculateTotalIncome(transactions);
    final totalExpenses = calculateTotalExpense(transactions);

    return totalIncome + totalExpenses;
  }


  void clearSelections() {
    _selectedCategory = Category(
        category: 'أخرى', icon: 'assets/icons/expenses_icons/other.png');
    _selectedIcon = 14;
    _selectedWallet = Wallet();
    notifyListeners();
  }
}
