import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';

import '../../model/transaction.dart' as my_transaction;

class TransactionHistoryItem extends StatelessWidget {
  final String currency;
  final my_transaction.Transaction transaction;

  const TransactionHistoryItem({Key? key, this.currency = 'ريال', required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(transaction.category!.icon, height: 30),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name!,
                  style: const TextStyle(
                      fontFamily: 'Tajawal', fontSize: 13, color: blackColor),
                ),
                priceWidget(
                    amount: transaction.amount!,
                    currency: currency,
                    fontSize: 13),
                transaction.note!.isEmpty
                    ? Container()
                    : const SizedBox(height: 5),
                transaction.note!.isEmpty
                    ? Container()
                    : Text(
                  transaction.note!,
                  style: const TextStyle(
                      fontFamily: 'Tajawal', fontSize: 11, color: darkGray),
                )
              ],
            )
          ],
        ),
        Text(
          DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
              transaction.createdAt!.microsecondsSinceEpoch)),
          style: const TextStyle(
              fontFamily: 'Tajawal', fontSize: 11, color: darkGray),
        )
      ],
    );
  }
}