import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';


Widget summaryCard(
    {required String title,
    required double amount,
    String currency = 'ريال',
    required double? width}) {
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
