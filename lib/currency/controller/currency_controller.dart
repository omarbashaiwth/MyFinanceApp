
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyController extends ChangeNotifier {
  final SharedPreferences prefs;

  CurrencyController(this.prefs);

  String? selectedCurrency({required String key}) {
    return getCurrency(key: key);
  }

  Future<void> saveCurrencyLocally({required String key, required String value}) async {
    prefs.setString(key, value);
  }

  String? getCurrency({required String key}){
    debugPrint('getCurrencyCalled');
    return prefs.getString(key);
  }
}


