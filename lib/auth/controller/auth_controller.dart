import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/model/my_user.dart';

class AuthController extends ChangeNotifier{

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  MyUser _user = MyUser();
  MyUser get user => _user;

  TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void onLoginStateChange(bool value){
    _isLogin = value;
    notifyListeners();
  }

  void onShowPasswordStateChange(){
    _showPassword = !_showPassword;
    notifyListeners();
  }

  void onEmailChange(String value){
    _user.email = value;
    notifyListeners();
  }

  void onPasswordChange(String value){
    _user.password = value;
    notifyListeners();
  }

  void onUsernameChange(String value){
    _user.username = value;
    notifyListeners();
  }
}