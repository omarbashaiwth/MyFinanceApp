import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/model/category.dart';
import 'package:myfinance_app/wallets/model/wallet.dart';

class TransactionController extends ChangeNotifier {

  final _firestore = FirebaseFirestore.instance;

  int _selectedIcon = 14;
  int get selectedIcon => _selectedIcon;

  Category _selectedCategory =
      Category(label: 'أخرى', icon: 'assets/icons/expenses_icons/other.png');

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

  Future<void> saveTransaction(Map<String, dynamic> transaction) async {
    _firestore.collection('Transaction').add(transaction);
  }

  void clearSelections() {
    _selectedCategory = Category(label: 'أخرى', icon: 'assets/icons/expenses_icons/other.png');
    _selectedIcon = 14;
    _selectedWallet = Wallet();
    notifyListeners();
  }
}
