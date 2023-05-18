import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

import '../../model/transaction.dart' as my_transaction;

class TransactionHistoryItem extends StatelessWidget {
  final String currency;
  final my_transaction.Transaction transaction;

  const TransactionHistoryItem(
      {Key? key, this.currency = 'ريال', required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(transaction.category!.icon, height: 30),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name!,
                  style: const TextStyle(
                      fontFamily: 'Tajawal', fontSize: 13, color: blackColor),
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
              amount: transaction.category!.amount!,
              currency: currency,
              fontSize: 13,
              color:
                  transaction.category!.amount! < 0 ? Colors.red : Colors.green,
            ),
            Text(
              DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
                  transaction.createdAt!.microsecondsSinceEpoch)),
              style: const TextStyle(
                  fontFamily: 'Tajawal', fontSize: 11, color: darkGray),
            )
          ],
        )
      ],
    );
  }
}
