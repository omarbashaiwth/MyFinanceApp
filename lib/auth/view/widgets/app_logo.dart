import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';
class AppLogo extends StatelessWidget {
  final String image;
  final String name;
  const AppLogo({Key? key, required this.image, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image),
        const SizedBox(height: 11),
        Text(name, style: AppTextTheme.logoTextStyle),
      ],
    );
  }
}