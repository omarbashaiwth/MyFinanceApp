import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as user;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyController extends ChangeNotifier {
  final SharedPreferences prefs;

  CurrencyController(this.prefs);

  // String? selectedCurrency({required String key}) {
  //   return getCurrency(key: key);
  // }

  // Future<void> saveCurrencyLocally({required String key, required String value}) async {
  //   prefs.setString(key, value);
  // }

  // String? getCurrency({required String key}){
  //   debugPrint('getCurrencyCalled');
  //   return prefs.getString(key);
  // }

  Future<bool> hasSelectedCurrency(
      {required String userId, required FirebaseFirestore firestore}) async {
    final doc = await firestore.collection('Users').doc(userId).get();
    return doc.exists;
  }

  Future<String> getCurrencyFromFirebase(
      {required FirebaseFirestore firestore, required String userId}) async {
    debugPrint('getCurrencyCalled');
    final doc = await firestore.collection('Users').doc(userId).get();
    return doc.data()!['currency'];
  }

  Future<void> saveCurrency(
      {required FirebaseFirestore firestore,
      required user.User user,
      required String currency}) async {
    firestore.collection('Users').doc(user.uid).set({
      'username': user.displayName,
      'email': user.email,
      'currency': currency
    });
  }
}
