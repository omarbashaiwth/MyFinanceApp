import 'package:flutter/material.dart';

class ChartHeader extends StatelessWidget {
  final String header;
  final String? buttonLabel;
  final bool showFilter;
  final Function()? onFilterClick;
  const ChartHeader({Key? key, required this.header, this.buttonLabel,  this.onFilterClick, this.showFilter = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        Text(header, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 20),),
        showFilter? OutlinedButton(
          onPressed: onFilterClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(buttonLabel!, style:  TextStyle(fontFamily: 'Tajawal', color: Theme.of(context).colorScheme.onPrimary),),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).colorScheme.onPrimary,),
            ],
          ),
        ): const SizedBox.shrink()
      ],
    );
  }
}
