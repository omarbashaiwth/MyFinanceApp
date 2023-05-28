import 'package:flutter/material.dart';
import 'package:myfinance_app/onboarding/model/currency.dart';

class OnBoardingController extends ChangeNotifier{

  Currency? _selectedCurrency;
  Currency? get selectedCurrency => _selectedCurrency;


  void onSelectedCurrencyChange(Currency value) {
    _selectedCurrency = value;
    notifyListeners();
  }
}