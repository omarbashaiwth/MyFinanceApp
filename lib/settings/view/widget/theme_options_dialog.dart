import 'package:flutter/material.dart';

import '../../model/theme_mode_options.dart';

class ThemeOptionsDialog{
  static final themeModes = [
    ThemeModeOptions(modeName: 'الوضع النهاري', modeIcon: Icons.light_mode, mode: ThemeMode.light),
    ThemeModeOptions(modeName: 'الوضع الليلي', modeIcon: Icons.dark_mode, mode: ThemeMode.dark),
    ThemeModeOptions(modeName: 'النظام', modeIcon: Icons.phone_android_rounded, mode: ThemeMode.system),

  ];
  static void show({required BuildContext context, required Function(ThemeModeOptions) onSelected} ) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('أختر الثيم'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(themeModes[0].modeIcon),
                  title:  Text(themeModes[0].modeName),
                  onTap: () {
                    Navigator.pop(context, onSelected(themeModes[0]));
                  },
                ),
                ListTile(
                  leading: Icon(themeModes[1].modeIcon),
                  title:  Text(themeModes[1].modeName),
                  onTap: () {
                    Navigator.pop(context, onSelected(themeModes[1]));
                  },
                ),
                ListTile(
                  leading: Icon(themeModes[2].modeIcon),
                  title:  Text(themeModes[2].modeName),
                  onTap: () {
                    Navigator.pop(context, onSelected(themeModes[2]));
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}