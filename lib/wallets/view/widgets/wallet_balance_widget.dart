import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

class WalletBalance extends StatelessWidget {
  final String balanceLabel;
  final double balance;
  final double fontSize;
  const WalletBalance({Key? key, required this.balance, required this.balanceLabel, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(balanceLabel, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 18, color: blackColor)),
        PriceWidget(
            amount: balance,
            currencyFontSize: fontSize,
            amountFontSize: fontSize,
          color: balance < 0 ? Colors.red: Colors.green,
        )
      ],
    );
  }
}
