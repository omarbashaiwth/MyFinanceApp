import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceWidget extends StatelessWidget {
  final double amount;
  final String currency;
  final double amountFontSize;
  final double currencyFontSize;
  final Color color;
  final FontWeight fontWeight;

  const PriceWidget(
      {Key? key,
      required this.amount,
        required this.currency,
      this.amountFontSize = 13,
        this.currencyFontSize = 13,
        required this.color, this.fontWeight = FontWeight.bold}
      )
      : super(key: key);

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          NumberFormat.decimalPattern().format(amount),
          style: TextStyle(
            fontSize: amountFontSize,
            fontFamily: 'Tajawal',
            fontWeight: fontWeight,
            color: color,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          currency,
          style: TextStyle(
            fontSize: currencyFontSize,
            fontFamily: 'Tajawal',
            fontWeight: fontWeight,
            color: color,
          ),
        )
      ],
    );
  }
}
