import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child:  Text(
        text,
        style: AppTextTheme.headerTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        textAlign: TextAlign.start,
      ),
    );
  }
}
