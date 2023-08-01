import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';
class AuthLogo extends StatelessWidget {
  final String image;
  final String text;
  const AuthLogo({Key? key, required this.image, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, height: 90,),
        const SizedBox(height: 12),
        Text(text, style: AppTextTheme.logoTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary)),
      ],
    );
  }
}