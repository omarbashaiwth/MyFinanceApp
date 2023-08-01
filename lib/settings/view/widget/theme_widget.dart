import 'package:flutter/material.dart';

import '../../model/theme_mode_options.dart';

class ThemeWidget extends StatelessWidget {
  final Function() onThemeChangeClicked;
  final ThemeModeOptions themeModeOptions;

  const ThemeWidget({super.key, required this.onThemeChangeClicked, required this.themeModeOptions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onThemeChangeClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Icon(themeModeOptions.modeIcon, size: 25),
                const SizedBox(width: 8),
                Text(
                  themeModeOptions.modeName,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            )),
            Icon(Icons.keyboard_arrow_left_rounded, color: Theme.of(context).colorScheme.onPrimary),
          ],
        ),
      ),
    );
  }
}
