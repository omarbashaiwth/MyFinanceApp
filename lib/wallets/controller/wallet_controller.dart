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

  double getTotalBalance(List<Wallet> wallets) {
    var totalBalance = 0.0;
    final balances = wallets.map((wallet) => wallet.currentBalance).toList();
    for (var balance in balances) {
      totalBalance += balance!;
    }
    return totalBalance;
  }

  void onWalletTypeChange(WalletType value) {
    _walletType = value;
    notifyListeners();
  }

  Future<void> insertWallet(Wallet wallet) async {
    _firestore
        .collection('Wallets')
        .withConverter(
            fromFirestore: Wallet.fromFirestore,
            toFirestore: (Wallet wallet, _) => wallet.toFirestore())
        .add(wallet);
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
