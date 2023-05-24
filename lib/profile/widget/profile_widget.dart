import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/model/transaction.dart'
    as my_transactions;

class ProfileWidget extends StatelessWidget {
  final User currentUser;
  final TransactionController controller;
  final AsyncSnapshot<List<my_transactions.Transaction>> snapshot;
  final Function() onLogout;

  const ProfileWidget(
      {Key? key,
      required this.currentUser,
      required this.onLogout,
      required this.snapshot,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactions = snapshot.data ?? [];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300]),
          ),
          const SizedBox(height: 32),
          ClipOval(
              child: currentUser.photoURL != null
                  ? Image.network(currentUser.photoURL!, height: 70)
                  : const Icon(
                      Icons.account_circle_rounded,
                      size: 70,
                      color: Colors.red,
                    )
          ),
          const SizedBox(height: 10),
          Text(
            currentUser.displayName ?? 'Unknown Name',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          Text(currentUser.email!),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onLogout,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout, size: 15, color: redColor),
                SizedBox(width: 8),
                Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                      fontFamily: 'Tajawal', fontSize: 15, color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'النفقات',
                    style: TextStyle(fontFamily: 'Tajawl'),
                  ),
                  PriceWidget(
                    amount: controller.calculateTotal(
                        transactions: transactions, type: 'expense'),
                    currency: 'ريال',
                    color: blackColor,
                    fontWeight: FontWeight.normal,
                  )
                ],
              ),
              Container(
                height: 30,
                width: 1,
                color: normalGray,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'الدخل',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  PriceWidget(
                    amount: controller.calculateTotal(
                        transactions: transactions, type: 'income'),
                    currency: 'ريال',
                    color: blackColor,
                    fontWeight: FontWeight.normal,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
