import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static final Future<SharedPreferences> _instance = SharedPreferences.getInstance();
  static  SharedPreferences? prefs;
  // call this method from iniState() function of mainApp().
  static Future<void> init() async {
    prefs = await _instance;
  }

  static String? getString(String key) {
    return prefs?.getString(key);
  }

  static setString(String key, String value) async {
    prefs?.setString(key, value);
  }
}