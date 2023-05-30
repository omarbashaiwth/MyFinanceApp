import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

class ChartHeader extends StatelessWidget {
  final String header;
  final String? buttonLabel;
  final bool showFilter;
  final Function()? onFilterClick;
  const ChartHeader({Key? key, required this.header, this.buttonLabel,  this.onFilterClick, this.showFilter = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: showFilter? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      children:  [
        Text(header, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 20),),
        showFilter? OutlinedButton(
          onPressed: onFilterClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(buttonLabel!, style: const TextStyle(fontFamily: 'Tajawal', color: blackColor),),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down_rounded, color: blackColor,),
            ],
          ),
        ): const SizedBox.shrink()
      ],
    );
  }
}
