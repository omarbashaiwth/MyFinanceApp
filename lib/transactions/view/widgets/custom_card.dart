import 'package:flutter/material.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String? currency;
  final Color color;
  final String image;
  final double width;

  const SummaryCard(
      {Key? key,
      required this.title,
      required this.amount,
      required this.image, required this.color, required this.currency, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(
                title,
                style:  TextStyle(
                  fontSize: 18,
                  fontFamily: 'Tajawal',
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 6),
              PriceWidget(
                  amount: amount,
                  currency: currency,
                  amountFontSize: 20,
                  currencyFontSize: 18,
                  color: color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
