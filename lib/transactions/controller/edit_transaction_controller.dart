
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/model/transaction.dart' as my_transaction;

import '../model/category.dart';

class EditTransactionController extends ChangeNotifier {

  final _firestore = FirebaseFirestore.instance;

  Category? _selectedCategory;

  Category? get selectedCategory => _selectedCategory;


  Timestamp? _selectedDate;
  Timestamp? get selectedDate => _selectedDate;


  Future<void> updateTransaction({required String transactionId,required my_transaction.Transaction data}) async {
    final docRef = FirebaseFirestore.instance.collection('Transactions')
        .doc(transactionId);
    docRef.update(data.toFirestore());
  }

  Stream<List<Category>?> getUserCategories(String id) {
    return _firestore
        .collection('Users')
        .doc(id)
        .snapshots()
        .map((snapshot) => snapshot.data()?['categories'])
        .map((categories) => categories
        .map<Category>((category) => Category.fromJson(category))
        .toList());
  }

  void onSelectedDateChange(Timestamp value) {
    _selectedDate = value;
    notifyListeners();
  }

  void onCategoryChange(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelections(){
    _selectedCategory = null;
    // _selectedWallet = null;
    _selectedDate = null;
    notifyListeners();
  }

}