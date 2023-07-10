import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_app/currency/controller/currency_controller.dart';
import 'package:provider/provider.dart';

class PriceWidget extends StatelessWidget {
  final double amount;
  final double amountFontSize;
  final double currencyFontSize;
  final Color color;
  final FontWeight fontWeight;

  const PriceWidget(
      {Key? key,
      required this.amount,
      this.amountFontSize = 13,
        this.currencyFontSize = 13,
        required this.color, this.fontWeight = FontWeight.bold}
      )
      : super(key: key);

  @override
  Widget build(BuildContext context){
    final currencyController = Provider.of<CurrencyController>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
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
          currencyController.getCurrency(key: user?.uid ?? '') ?? '',
          style: TextStyle(
            fontSize: currencyFontSize,
            fontFamily: 'Tajawal',
            fontWeight: fontWeight,
            color: color,
          ),
        )
      ],
    );
    ;
  }
}
