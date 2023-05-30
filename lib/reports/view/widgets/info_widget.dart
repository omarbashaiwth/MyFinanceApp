import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

class InfoWidget extends StatelessWidget {
  final String label;
  final double? labelSize;
  final Color color;
  const InfoWidget({Key? key, required this.label, required this.color, this.labelSize = 14}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:  color,
              ),
            ),
            const SizedBox(width: 8),
            Text(label,style:  TextStyle(fontFamily: 'Tajawal', color: blackColor, fontSize: labelSize)),
          ],
        ),
      ],
    );
  }
}
