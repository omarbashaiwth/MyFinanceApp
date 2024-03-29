import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

class WalletBalance extends StatelessWidget {
  final String balanceLabel;
  final double balance;
  final double fontSize;
  final String? currency;
  const WalletBalance({Key? key, required this.balance, required this.balanceLabel, required this.fontSize, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(balanceLabel, style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, color: Theme.of(context).colorScheme.onPrimary)),
        PriceWidget(
            amount: balance,
            currency: currency,
            currencyFontSize: fontSize,
            amountFontSize: fontSize,
          color: balance < 0 ? red: green,
        )
      ],
    );
  }
}
