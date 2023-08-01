import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

class CenteredHeader extends StatelessWidget {
  final String header;

  const CenteredHeader({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            color: lightGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            header,
            style: AppTextTheme.headerTextStyle,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: lightGrey,
          ),
        ),
      ],
    );
  }
}
