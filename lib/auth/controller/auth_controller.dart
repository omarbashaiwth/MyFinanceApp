import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier{

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  void onLoginStateChange(bool value){
    _isLogin = value;
    notifyListeners();
  }

  void onLoadingStateChange(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void onShowPasswordStateChange(bool value){
    _showPassword = value;
    notifyListeners();
  }
}