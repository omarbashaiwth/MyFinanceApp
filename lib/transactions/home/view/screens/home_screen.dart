import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_app/auth/controller/services/firebase_auth_services.dart';
import 'package:myfinance_app/core/ui/theme.dart';

import '../../model/category.dart';
import '../../model/transaction.dart' as my_transaction;
import '../widgets/custom_card.dart';
import '../widgets/higher_expenses.dart';
import '../widgets/last_transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: redColor.withOpacity(.90),
        title: const Text('المعاملات',style: AppTextTheme.appBarTitleTextStyle,),
        actions:[IconButton(onPressed: () async => await FirebaseAuthServices(FirebaseAuth.instance).logout(), icon: Image.asset('assets/icons/menu.png', height: 25,))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Column(
          children: [
            _headerSection(header: 'ملخص الشهر'),
            _monthlySummarySection(),
            _headerSection(header: 'آخر المعاملات', showMore: true),
            _lastTransactionsSection(),
            _headerSection(header: 'أعلى النفقات'),
            _higherExpensesSection()
          ],
        ),
      ),
    );
  }

  Widget _headerSection({required String header, bool showMore = false}){
    return Column(
      children: [
        showMore? Container(): const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header, style: AppTextTheme.headerTextStyle),
            showMore? TextButton(onPressed: (){}, child: Text('عرض المزيد', style: AppTextTheme.textButtonStyle.copyWith(color: redColor)),): Container()
          ],
        ),
        showMore? Container(): const SizedBox(height: 8),
      ],
    );
  }

  Widget _monthlySummarySection(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: darkGray),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          summaryCard(title: 'أداء الشهر الحالي', amount: -100, width: 300),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 15,
                    width: 2,
                    color: normalGray,
                  ),
                  summaryCard(title: 'النفقات', amount: -600, width: 150),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 15,
                    width: 2,
                    color: normalGray,
                  ),
                  summaryCard(title: 'الدخل', amount: 500, width: 150),

                ],
              )
            ],
          )
        ],
      )
    );
  }

  Widget _lastTransactionsSection(){
    var latestFiveTransactions = [
      my_transaction.Transaction(name: 'إيجار', amount: -600,note: null,date: Timestamp.fromDate(DateTime(2020)),category: Category(icon:'assets/icons/expenses_icons/rent.png')),
      my_transaction.Transaction(name:'كهرباء', amount:-50,note: null,date:Timestamp.fromDate(DateTime(2020)),category: Category(icon: 'assets/icons/expenses_icons/electricity.png')),
      my_transaction.Transaction(name: 'الراتب', amount: 1000,note: null,date: Timestamp.fromDate(DateTime(2020)) , category: Category(icon:'assets/icons/salary.png')),
      my_transaction.Transaction(name: 'انترنت', amount: -20,note: null,date: Timestamp.fromDate(DateTime(2020)),category: Category(icon: 'assets/icons/expenses_icons/rent.png')),
      my_transaction.Transaction(name: 'تسوق', amount: -30,note: null,date: Timestamp.fromDate(DateTime(2020)),category: Category(icon: 'assets/icons/expenses_icons/electricity.png')),
    ];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: darkGray),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          lastTransactionsItem(transaction: latestFiveTransactions[0]),
          const Divider(),
          lastTransactionsItem(transaction: latestFiveTransactions[1]),
          const Divider(),
          lastTransactionsItem(transaction: latestFiveTransactions[2]),
        ],
      )

    );
  }

  Widget _higherExpensesSection(){
    var higherFiveTransactions = [
      my_transaction.Transaction(name: 'إيجار', amount: -600,note: null,date: Timestamp.fromDate(DateTime(2020)),category: Category(icon: 'assets/icons/expenses_icons/rent.png')),
      my_transaction.Transaction(name:'كهرباء', amount:-50,note: null,date:Timestamp.fromDate(DateTime(2020)),category: Category(icon: 'assets/icons/expenses_icons/electricity.png')),
      my_transaction.Transaction(name: 'انترنت', amount: -20,note: null,date: Timestamp.fromDate(DateTime(2020)),category:Category(icon: 'assets/icons/expenses_icons/rent.png')),
      my_transaction.Transaction(name: 'تسوق', amount: -30,note: null,date: Timestamp.fromDate(DateTime(2020)),category:Category(icon: 'assets/icons/expenses_icons/electricity.png')),
    ];
    final amounts = higherFiveTransactions.map((e) => e.amount).toList();
    var totalAmounts = 0.0;
    for (var amount in amounts) {
      totalAmounts += amount!;
    }
    return Container(
        padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
    border: Border.all(color: darkGray),
    borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      children: [
        higherExpensesItem(expense: higherFiveTransactions[0], indicatorValue: higherFiveTransactions[0].amount!/totalAmounts),
        higherExpensesItem(expense: higherFiveTransactions[1], indicatorValue: higherFiveTransactions[1].amount!/totalAmounts),
        higherExpensesItem(expense: higherFiveTransactions[2], indicatorValue: higherFiveTransactions[2].amount!/totalAmounts),
        higherExpensesItem(expense: higherFiveTransactions[3], indicatorValue: higherFiveTransactions[3].amount!/totalAmounts),
      ],
    )
    );
  }
}
