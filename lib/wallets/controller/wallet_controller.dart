import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/wallets/model/wallet_type.dart';
import 'package:myfinance_app/transactions/model/transaction.dart' as my_transactions;


import '../model/wallet.dart';

class WalletController extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  WalletType? _walletType;

  WalletType? get walletType => _walletType;

  bool _deleteRelatedTransactions = false;
  bool get deleteRelatedTransactions => _deleteRelatedTransactions;

  void onWalletTypeChange(WalletType value) {
    _walletType = value;
    notifyListeners();
  }

  void onToggleDeleteTransactions(bool value){
    _deleteRelatedTransactions = value;
    notifyListeners();
  }

  double calculateTotalBalance(List<Wallet> wallets) {
    var totalBalance = 0.0;
    final balances = wallets.map((wallet) => wallet.currentBalance).toList();
    for (var balance in balances) {
      totalBalance += balance!;
    }
    return totalBalance;
  }

  Future<String> insertWallet(Wallet wallet) async {
    final docRef = _firestore.collection('Wallets').doc();
    final walletToInsert = Wallet(
      id: docRef.id,
      name: wallet.name,
      currentBalance: wallet.currentBalance,
      walletType: wallet.walletType,
      userId: wallet.userId,
      createdAt: wallet.createdAt
    );
    docRef.withConverter(
            fromFirestore: Wallet.fromFirestore,
            toFirestore: (Wallet wallet, _) => wallet.toFirestore())
        .set(walletToInsert);
    return docRef.id;

  }
  
  Future<void> updateWalletBalance({required double value,required String walletId}) async {
   final docRef =  _firestore.collection('Wallets').doc(walletId);
   docRef.update({'balance':FieldValue.increment(value)});
  }
  
  Future<void> updateWallet({required Wallet wallet}) async {
    final docRef = _firestore.collection('Wallets').doc(wallet.id);
    docRef.update(
      {
        'balance': wallet.currentBalance,
        'icon':wallet.walletType!.icon,
        'type' : wallet.walletType!.type,
        'name':wallet.name
      }
    );
  }

  Future<void> deleteWallet({required String walletId}) async{
    final docRef =  _firestore.collection('Wallets').doc(walletId);
    docRef.delete();
  }

  Future<void> deleteTransactionsRelatedToWallet({required String walletId}) async{
    final docRef = _firestore.collection('Transactions')
        .where('walletId', isEqualTo: walletId)
        .where('userId', isEqualTo: _auth.currentUser!.uid);
    docRef.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream<List<Wallet>> getWallets()  {
    return _firestore.collection('Wallets')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('balance', descending: true)
        .withConverter<Wallet>(
          fromFirestore: Wallet.fromFirestore,
          toFirestore: (Wallet wallet, _) => wallet.toFirestore()
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  }

  Future<Wallet?> getWalletById(String walletId) {
    return _firestore.collection('Wallets')
        .doc(walletId)
        .withConverter<Wallet>(
        fromFirestore: Wallet.fromFirestore,
        toFirestore: (Wallet wallet, _) => wallet.toFirestore()
    )
        .get()
        .then((value) => value.data());

  }
  
  Stream<List<my_transactions.Transaction>> getTransactionsRelatedToWallet(String walletId)  {
    return _firestore.collection('Transactions')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('walletId', isEqualTo: walletId)
        .orderBy('createdAt',descending: true)
        .withConverter<my_transactions.Transaction>(
          fromFirestore: my_transactions.Transaction.fromFirestore,
          toFirestore: (my_transactions.Transaction transaction,_) => transaction.toFirestore()
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  void clearSelections(){
    _walletType = null;
    notifyListeners();
  }

}
