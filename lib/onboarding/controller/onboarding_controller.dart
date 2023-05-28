import 'package:flutter/material.dart';
import 'package:myfinance_app/onboarding/model/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingController extends ChangeNotifier{
  final SharedPreferences prefs;
  OnBoardingController(this.prefs);
  
  Currency? _selectedCurrency;
  Currency? get selectedCurrency => _selectedCurrency;


  void onSelectedCurrencyChange(Currency value) {
    _selectedCurrency = value;
    notifyListeners();
  }
  
  String? getCurrency(){
    return prefs.getString('currency');
  }

  void setCurrency(String value){
    prefs.setString('currency', value);
  }
}