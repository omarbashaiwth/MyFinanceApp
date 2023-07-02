import 'package:flutter/material.dart';
import 'package:myfinance_app/onboarding/model/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingController extends ChangeNotifier{
  final SharedPreferences prefs;
  OnBoardingController(this.prefs);

  // bool _firstTimeLaunched = true;
  // bool get firstTimeLaunched => _firstTimeLaunched;
  //
  //
  // void onFirstTimeLaunchedChanged(bool value) {
  //   _firstTimeLaunched = value;
  //   notifyListeners();
  // }
  
  bool? firstTimeLaunched(){
    return prefs.getBool('onBoarding');
  }

  void onFirstTimeLaunchedChanged(bool value){
    prefs.setBool('onBoarding', value);
  }
}