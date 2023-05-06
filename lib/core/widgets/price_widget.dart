import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget priceWidget(
{required double amount, required String currency, double fontSize = 18}
    ){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        NumberFormat.decimalPattern().format(amount),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
          color: amount < 0 ? Colors.red : Colors.green,
        ),
      ),
      const SizedBox(width: 2),
      Text(
        currency,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
          color: amount < 0 ? Colors.red : Colors.green,
        ),
      )
    ],
  );
}