import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceWidget extends StatelessWidget {
  final double amount;
  final String currency;
  final double fontSize;
  final Color color;

  const PriceWidget(
      {Key? key,
      required this.amount,
      required this.currency,
      this.fontSize = 18,
        required this.color}
      )
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          NumberFormat.decimalPattern().format(amount),
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          currency,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        )
      ],
    );
    ;
  }
}
