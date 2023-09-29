import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';
import 'package:myfinance_app/transactions/view/screens/edit_transaction_screen.dart';

import '../../model/transaction.dart' as my_transaction;
import '../screens/transaction_history_screen.dart';

class TransactionHistoryItem extends StatelessWidget {
  final my_transaction.Transaction transaction;
  final String? currency;

  const TransactionHistoryItem(
      {Key? key, required this.transaction, required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => EditTransactionScreen(transaction: transaction)),
      child: Row(
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
                    style:  TextStyle(
                        fontFamily: 'Tajawal', fontSize: 13, color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  transaction.note == null || transaction.note!.isEmpty?
                      const SizedBox.shrink():
                  Text(
                    transaction.note!,
                    style:  TextStyle(
                        fontFamily: 'Tajawal', fontSize: 11, color: Theme.of(context).colorScheme.onPrimary),
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
                currency: currency,
                color: transaction.type == null? Theme.of(context).colorScheme.onPrimary :
                    transaction.type == 'expense' ? Colors.red : Colors.green,
                fontWeight: FontWeight.normal,
              ),
              Text(
                Utils.dateFormat(date: DateTime.fromMicrosecondsSinceEpoch(
                    transaction.createdAt!.microsecondsSinceEpoch),
                ),
                style:  TextStyle(
                    fontFamily: 'Tajawal', fontSize: 11, color: Theme.of(context).colorScheme.onPrimary),
              )
            ],
          )
        ],
      ),
    );
  }
}
