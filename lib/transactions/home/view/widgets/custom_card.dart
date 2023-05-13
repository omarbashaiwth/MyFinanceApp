import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currency;
  final double? width;
  const SummaryCard({Key? key, required this.title, required this.amount, this.currency = 'ريال', this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Tajawal',
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 8),
              priceWidget(amount: amount, currency: currency)
            ],
          ),
        ),
      ),
    );
  }
}
