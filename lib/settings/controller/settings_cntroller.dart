import 'package:flutter/material.dart';
import 'package:myfinance_app/settings/model/theme_mode_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class SettingsController extends ChangeNotifier {

  static late ThemeModeOptions _currentTheme;
  ThemeModeOptions get currentTheme => _currentTheme;

  static void init(SharedPreferences prefs) {
    _currentTheme = getThemeModeOption(prefs);
  }


  void toggleThemeModeOption(ThemeModeOptions modeOption) {
    _currentTheme = modeOption;
    _saveThemeModePreference(modeOption.mode);
    notifyListeners();
  }

  static ThemeModeOptions getThemeModeOption(SharedPreferences prefs) {
    final savedThemeMode =  prefs.getString('theme_mode');
    return  _mapStringToThemeModeOptions(savedThemeMode);
  }

  void _saveThemeModePreference(ThemeMode mode) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('theme_mode', mode.toString());
  }

  static ThemeModeOptions _mapStringToThemeModeOptions(String? savedThemeMode){
    switch(savedThemeMode) {
      case 'ThemeMode.light':
        return ThemeModeOptions(modeName: 'الوضع النهاري', modeIcon: Icons.light_mode, mode: ThemeMode.light);
      case 'ThemeMode.dark':
        return ThemeModeOptions(modeName: 'الوضع الليلي', modeIcon: Icons.dark_mode, mode: ThemeMode.dark);
      case 'ThemeMode.system':
        return ThemeModeOptions(modeName: 'النظام', modeIcon: Icons.phone_android_rounded, mode: ThemeMode.system);
      default:
        return ThemeModeOptions(modeName: 'النظام', modeIcon: Icons.phone_android_rounded, mode: ThemeMode.system);
    }
  }

  static void sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'om2013ab@gmail.com',
    );

    String url = params.toString();
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}