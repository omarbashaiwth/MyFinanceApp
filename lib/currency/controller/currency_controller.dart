import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as user;
import 'package:flutter/material.dart';
import 'package:myfinance_app/currency/model/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyController extends ChangeNotifier {
  final SharedPreferences prefs;

  CurrencyController(this.prefs);

  bool _isCurrencyAlreadyFetched = false;

  Currency? _currency ;
  Currency? get currency => _currency;


  Future<bool> hasSelectedCurrency(
      {required String userId, required FirebaseFirestore firestore}) async {
    final doc = await firestore.collection('Users').doc(userId).get();
    return doc.exists;
  }

  Future<void> getCurrencyFromFirebase(
      {required FirebaseFirestore firestore, required String userId}) async {
    if(!_isCurrencyAlreadyFetched){
      debugPrint('getCurrencyCalled');
      final doc = await firestore.collection('Users').doc(userId).get();
      final currency = Currency.fromJson(json: doc.data()!['currency']);
      _currency = currency;
      _isCurrencyAlreadyFetched = true;
      notifyListeners();
    }

  }

  Future<void> saveCurrency(
      {required FirebaseFirestore firestore,
      required user.User user,
      required Currency currency}) async {
    firestore.collection('Users').doc(user.uid).set({
      'username': user.displayName,
      'email': user.email,
      'currency': currency.toJson()
    });
    _isCurrencyAlreadyFetched = false;
    notifyListeners();
  }
}
