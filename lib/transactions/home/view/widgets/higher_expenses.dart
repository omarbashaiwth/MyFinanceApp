
import 'package:flutter/material.dart';
import '../../../../core/ui/theme.dart';
import '../../../../core/widgets/price_widget.dart';
import '../../model/transaction.dart';
import 'package:percent_indicator/percent_indicator.dart';

Widget higherExpensesItem(
    {required Transaction expense,
    required double totalExpense,
    String currency = 'ريال'}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(expense.category!.icon, height: 30),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.name!,
                style: const TextStyle(
                    fontFamily: 'Tajawal', fontSize: 13, color: blackColor),
              ),
              priceWidget(
                  amount: expense.amount!, currency: currency, fontSize: 13)
            ],
          )
        ],
      ),
      const SizedBox(height: 8),
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: expense.amount! / totalExpense),
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 2),
        builder: (_, value, child) => LinearPercentIndicator(
          isRTL: true,
          percent: value,
          backgroundColor: normalGray.withOpacity(0.5),
          lineHeight: 8,
          barRadius: const Radius.circular(8),
        ),
      ),
      const SizedBox(height: 8),
    ],
  );
}
