
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/model/transaction.dart' as my_transaction;

import '../../wallets/model/wallet.dart';
import '../model/category.dart';

class EditTransactionController extends ChangeNotifier {

  Category? _selectedCategory;

  Category? get selectedCategory => _selectedCategory;


  Timestamp? _selectedDate;
  Timestamp? get selectedDate => _selectedDate;

  // Wallet? _selectedWallet;
  //
  // Wallet? get selectedWallet => _selectedWallet;


  Future<void> updateTransaction({required String transactionId,required my_transaction.Transaction data}) async {
    final docRef = FirebaseFirestore.instance.collection('Transactions')
        .doc(transactionId);
    docRef.update(data.toFirestore());
  }

  void onSelectedDateChange(Timestamp value) {
    _selectedDate = value;
    notifyListeners();
  }

  void onCategoryChange(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // void onWalletChange(Wallet wallet) {
  //   _selectedWallet = wallet;
  //   notifyListeners();
  // }

  void clearSelections(){
    _selectedCategory = null;
    // _selectedWallet = null;
    _selectedDate = null;
    notifyListeners();
  }

}