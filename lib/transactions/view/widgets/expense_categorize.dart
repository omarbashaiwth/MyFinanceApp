
import 'package:flutter/material.dart';
import '../../../../core/ui/theme.dart';
import '../../../../core/widgets/price_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';


class ExpensesCategorize extends StatelessWidget {
  final String categoryIcon;
  final String categoryName;
  final double categoryAmount;
  final double totalExpense;
  const ExpensesCategorize({Key? key, required this.categoryIcon, required this.categoryName, required this.categoryAmount, required this.totalExpense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(categoryIcon, height: 30),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: const TextStyle(
                      fontFamily: 'Tajawal', fontSize: 13, color: blackColor),
                ),
                PriceWidget(
                    amount: categoryAmount,color: categoryAmount < 0 ? Colors.red : Colors.green)
              ],
            )
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: categoryAmount / totalExpense),
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
    );;
  }
}
