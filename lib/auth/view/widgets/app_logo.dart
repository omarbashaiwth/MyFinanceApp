import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

Widget buildAppLogo({required String logoImage, required String name}) {
  return Column(
    children: [
      Image.asset(logoImage),
      const SizedBox(height: 11),
      Text(name, style: AppTextTheme.logoTextStyle),
    ],
  );
}