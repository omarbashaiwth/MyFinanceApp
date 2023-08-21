import 'package:flutter/material.dart';

import '../../model/theme_mode_options.dart';

class ThemeOptionsDialog {
  static final themeModes = [
    ThemeModeOptions(
        modeName: 'الوضع النهاري',
        modeIcon: Icons.light_mode,
        mode: ThemeMode.light),
    ThemeModeOptions(
        modeName: 'الوضع الليلي',
        modeIcon: Icons.dark_mode,
        mode: ThemeMode.dark),
    ThemeModeOptions(
        modeName: 'النظام',
        modeIcon: Icons.phone_android_rounded,
        mode: ThemeMode.system),
  ];

  static void show(
      {required BuildContext context,
      required Function(ThemeModeOptions) onSelected}) {
    showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              title: Column(
                children: const [
                  Text(
                    'أختر الثيم',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 20),
                  ),
                  Divider()
                ],
              ),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: themeModes
                      .map((e) => ListTile(
                            leading: Icon(e.modeIcon, color: Theme.of(context).colorScheme.onPrimary),
                            title: Text(
                              e.modeName,
                              style: const TextStyle(fontFamily: 'Tajawal'),
                            ),
                            onTap: () {
                              Navigator.pop(context, onSelected(e));
                            },
                          ),
                  ).toList(),
              ),
            ),
          );
        });
  }
}
