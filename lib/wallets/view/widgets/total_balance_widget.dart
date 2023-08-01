import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

class TotalBalanceWidget extends StatelessWidget {
  final double balance;
  final String? currency;
  final double currencyFontSize;
  final double amountFontSize;
  const TotalBalanceWidget({Key? key, required this.balance,required this.currencyFontSize, required this.amountFontSize, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: lightGrey),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          const Text('إجمالي الرصيد', style: AppTextTheme.headerTextStyle),
          const SizedBox(height: 8),
          PriceWidget(
              amount: balance,
              currency: currency,
              currencyFontSize: currencyFontSize,
              amountFontSize: amountFontSize,
            color: balance < 0 ? red: green,
          )
        ],
      ),
    );
  }
}
