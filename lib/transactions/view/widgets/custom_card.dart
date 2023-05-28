import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String image;
  final int quarterRotate;

  const SummaryCard(
      {Key? key,
      required this.title,
      required this.amount,
      required this.image,
         this.quarterRotate = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                PriceWidget(
                    amount: amount,
                    color: amount < 0 ? Colors.red : Colors.green,
                )
              ],
            ),
            RotatedBox(
                quarterTurns: quarterRotate,
                child:Image.asset(image,height: 45,)
            )
          ],
        ),
        // child: Column(
        //   children: [
        //     Text(
        //       title,
        //       style: const TextStyle(
        //         fontSize: 18,
        //         fontFamily: 'Tajawal',
        //         color: blackColor,
        //       ),
        //     ),
        //     const SizedBox(height: 8),
        //     PriceWidget(amount: amount, currency: currency, color: amount < 0 ? Colors.red : Colors.green)
        //   ],
        // ),
      ),
    );
  }
}
