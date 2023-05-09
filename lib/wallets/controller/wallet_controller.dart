import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/wallets/model/wallet_type.dart';

import '../model/wallet.dart';

class WalletController extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  WalletType _walletType =
      WalletType(type: 'كاش', icon: 'assets/icons/cash.png');

  WalletType get walletType => _walletType;

  void onWalletTypeChange(WalletType value) {
    _walletType = value;
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

  Future<void> insertWallet(Wallet wallet) async {
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

  }
  
  Future<void> updateWallet({required double value,required String walletId}) async {
   final docRef =  _firestore.collection('Wallets').doc(walletId);
   docRef.update({'balance':FieldValue.increment(value)});
  }

  Stream<List<Wallet>> getWallets() {
    final snapshots = _firestore
        .collection('Wallets')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('createdAt')
        .withConverter(
            fromFirestore: Wallet.fromFirestore,
            toFirestore: (Wallet wallet, _) => wallet.toFirestore())
        .snapshots();
    final docs = snapshots.map((event) => event.docs);
    return docs.map((event) => event.map((e) => e.data()).toList());
  }

}
