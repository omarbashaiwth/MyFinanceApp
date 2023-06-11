import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/model/transaction.dart'
    as my_transaction;
import 'package:myfinance_app/transactions/model/category.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';

class TransactionController extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int _selectedIcon = 0;

  int get selectedIcon => _selectedIcon;

  Category? _selectedCategory;

  Category? get selectedCategory => _selectedCategory;


  Timestamp _selectedDate = Timestamp.now();
  Timestamp get selectedDate => _selectedDate;

  DateTime _pickedDate = DateTime.now();
  DateTime get pickedDate => _pickedDate;

  Wallet? _selectedWallet;

  Wallet? get selectedWallet => _selectedWallet;

  void onChangePickedMonth(DateTime value){
    _pickedDate = value;
    notifyListeners();
  }

  void onChangeSelectedIcon(int selectedIconIndex) {
    _selectedIcon = selectedIconIndex;
    notifyListeners();
  }

  void onSelectedDateChange(Timestamp value) {
    _selectedDate = value;
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

  List<my_transaction.Transaction>? transactionsByMonth({required List<my_transaction.Transaction>? transactions, required DateTime pickedMonth}){
    final startOfMonth = DateTime(pickedMonth.year, pickedMonth.month);
    final endOfMonth = DateTime(pickedMonth.year, pickedMonth.month + 1).subtract(const Duration(milliseconds: 1));
    return transactions?.where((transaction) => transaction.createdAt!.toDate().isAfter(startOfMonth) && transaction.createdAt!.toDate().isBefore(endOfMonth)).toList();
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
              previousValue + transaction.amount!);
    } else {
      final transactionsByType =
          transactions.where((element) => element.type == type).toList();
      return transactionsByType.fold(
          0.0,
          (previousValue, transaction) =>
              previousValue + transaction.amount!
      );
    }
  }

  void clearSelections() {
    _selectedCategory = null;
    _selectedIcon = 0;
    _selectedWallet = null;
    _selectedDate = Timestamp.now();
    notifyListeners();
  }
}
