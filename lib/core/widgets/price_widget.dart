import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_app/onboarding/controller/onboarding_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget build(BuildContext context) {
    // final currency =  Provider.of<OnBoardingController>(context, listen: false).getCurrency() ?? '';
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
          '',
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
