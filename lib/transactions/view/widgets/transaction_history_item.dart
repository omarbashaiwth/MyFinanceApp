import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

import '../../model/transaction.dart' as my_transaction;

class TransactionHistoryItem extends StatelessWidget {
  final my_transaction.Transaction transaction;

  const TransactionHistoryItem(
      {Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(transaction.category?.icon ?? 'assets/icons/salary.png', height: 30),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category?.name ?? 'دخل',
                  style: const TextStyle(
                      fontFamily: 'Tajawal', fontSize: 13, color: blackColor,
                  ),
                ),
                transaction.note == null || transaction.note!.isEmpty?
                    const SizedBox.shrink():
                Text(
                  transaction.note!,
                  style: const TextStyle(
                      fontFamily: 'Tajawal', fontSize: 11, color: darkGray),
                )
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PriceWidget(
              amount: transaction.amount!,
              fontSize: 13,
              color:
                  transaction.amount! < 0 ? Colors.red : Colors.green,
            ),
            Text(
              Utils.dateFormat(transaction.createdAt!),
              style: const TextStyle(
                  fontFamily: 'Tajawal', fontSize: 11, color: darkGray),
            )
          ],
        )
      ],
    );
  }
}
