import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_app/auth/controller/services/firebase_auth_services.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:provider/provider.dart';

import '../../model/category.dart';
import '../../model/transaction.dart' as my_transaction;
import '../widgets/custom_card.dart';
import '../widgets/higher_expenses.dart';
import '../widgets/last_transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TransactionController>(context);
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
             _monthlySummarySection(controller),
            const SizedBox(height: 16),
            _headerSection(header: 'آخر المعاملات', showMore: true),
             _lastTransactionsSection(controller),
             const SizedBox(height: 16),
             _headerSection(header: 'أعلى النفقات'),
             _higherExpensesSection(controller)
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

  Widget _monthlySummarySection(TransactionController controller) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: darkGray),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          StreamBuilder(
            stream: controller.getTransactions(),
            builder: (context, snapshot) {
              return summaryCard(
                  title: 'أداء الشهر الحالي',
                  amount: controller.calculateDifference(snapshot.data),
                  width: 300,
              );
            }
          ),
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
                  StreamBuilder(
                    stream: controller.getTransactions(),
                    builder: (context, snapshot) {
                      return summaryCard(
                          title: 'النفقات',
                          amount: controller.calculateTotalExpense(snapshot.data),
                          width: 150
                      );
                    }
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 15,
                    width: 2,
                    color: normalGray,
                  ),
                  StreamBuilder(
                    stream: controller.getTransactions(),
                    builder: (context, snapshot) {
                      return summaryCard(
                          title: 'الدخل',
                          amount: controller.calculateTotalIncome(snapshot.data),
                          width: 150,
                      );
                    }
                  ),

                ],
              )
            ],
          )
        ],
      )
    );
  }

  Widget _lastTransactionsSection(TransactionController controller){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: darkGray),
          borderRadius: BorderRadius.circular(10)
      ),
      child: StreamBuilder(
        stream: controller.getTransactions(),
        builder: (context, snapshot) {
          final transactions = snapshot.data;
          if(snapshot.hasData && snapshot.hasError){
            debugPrint(snapshot.error.toString());
            return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              transactions!.isEmpty ?
              const SizedBox(width: double.infinity, child: Text('لا يوجد بيانات', style: AppTextTheme.headerTextStyle, textAlign: TextAlign.center,))
                  : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transactions.length,
                itemBuilder: (_,index) {
                  return Column(
                    children: [
                      lastTransactionsItem(transaction: transactions[index]),
                      index != transactions.lastIndexOf(transactions.last)? const Divider(): Container()
                    ],
                  );
                },
              )
            ]
          );

        }
      )

    );
  }

  Widget _higherExpensesSection(TransactionController controller){
    return Container(
        padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
    border: Border.all(color: darkGray),
    borderRadius: BorderRadius.circular(10)
    ),
    child: StreamBuilder(
      stream: controller.getFiveHighestExpense(),
      builder: (context, snapshot) {
        final transactions = snapshot.data;
        if(snapshot.hasData && snapshot.hasError){
          debugPrint(snapshot.error.toString());
          return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            transactions!.isEmpty? const SizedBox(width: double.infinity, child: Text('لا يوجد بيانات', style: AppTextTheme.headerTextStyle, textAlign: TextAlign.center,))
            : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: transactions.length,
              itemBuilder: (_,index) {
                final amounts = transactions.map((e) => e.amount).toList();
                var totalAmounts = 0.0;
                for (var amount in amounts) {
                  totalAmounts += amount!;
                }
                return higherExpensesItem(expense: transactions[index], totalExpense: totalAmounts);
              }
            )
          ],
        );
      }
    )
    );
  }
}
