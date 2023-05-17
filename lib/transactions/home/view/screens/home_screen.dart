import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_app/auth/controller/services/firebase_auth_services.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/view/screens/transaction_history_screen.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../model/transaction.dart';
import '../widgets/custom_card.dart';
import '../widgets/expense_categorize.dart';
import '../widgets/last_transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TransactionController>(context, listen: false);
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
      body: StreamBuilder(
        stream: controller.getTransactions(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: Column(
              children: [
                 _headerSection(header: 'ملخص الشهر'),
                 _monthlySummarySection(controller: controller, snapshot: snapshot),
                const SizedBox(height: 16),
                _headerSection(header: 'النفقات حسب التصنيف'),
                _expensesCategorySection(controller: controller, snapshot: snapshot),
                 const SizedBox(height: 16),
                _headerSection(header: 'آخر المعاملات', showMore: true),
                _lastTransactionsSection(controller: controller, snapshot: snapshot),

              ],
            ),
          );
        }
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
            showMore? TextButton(onPressed: () => Get.to(const Directionality(textDirection: TextDirection.rtl,child: TransactionHistoryScreen())), child: Text('عرض المزيد', style: AppTextTheme.textButtonStyle.copyWith(color: redColor)),): Container()
          ],
        ),
        showMore? Container(): const SizedBox(height: 8),
      ],
    );
  }

  Widget _monthlySummarySection({required AsyncSnapshot<List<Transaction>> snapshot, required TransactionController controller}) {
    final transactions = snapshot.data ?? [];
    if(snapshot.hasData && snapshot.hasError){
      debugPrint(snapshot.error.toString());
      return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
    }
    if(snapshot.connectionState == ConnectionState.waiting){
      return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: darkGray),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          SummaryCard(
              title: 'أداء الشهر الحالي',
              amount: controller.calculateTotal(transactions: transactions),
              width: 300,
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
                  SummaryCard(
                      title: 'النفقات',
                      amount: controller.calculateTotal(transactions: transactions, type: 'expense'),
                      width: 150
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
                  SummaryCard(
                      title: 'الدخل',
                      amount: controller.calculateTotal(transactions:transactions, type:'income'),
                      width: 150,
                  ),

                ],
              )
            ],
          )
        ],
      )
    );
  }

  Widget _lastTransactionsSection({required TransactionController controller, required AsyncSnapshot<List<Transaction>> snapshot}){
    final transactions = snapshot.data?.take(5).toList() ?? [];
    if(snapshot.hasData && snapshot.hasError){
      debugPrint(snapshot.error.toString());
      return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
    }
    if(snapshot.connectionState == ConnectionState.waiting){
      return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: darkGray),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
            children: [
              transactions.isEmpty ?
              const SizedBox(width: double.infinity, child: Text('لا يوجد بيانات', style: AppTextTheme.headerTextStyle, textAlign: TextAlign.center,))
                  : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transactions.length,
                itemBuilder: (_,index) {
                  return Column(
                    children: [
                      TransactionHistoryItem(transaction: transactions[index]),
                      index != transactions.indexOf(transactions.last)? const Divider(): Container()
                    ],
                  );
                },
              )
            ]
          )
      );
  }

  Widget _expensesCategorySection({required TransactionController controller, required AsyncSnapshot<List<Transaction>> snapshot}){
    final transactions = snapshot.data??[];
    final expenses = controller.calculateTotal(transactions: transactions, type: 'expense');
    final grouped = controller.groupExpenses(transactions);
    if(snapshot.hasData && snapshot.hasError){
      debugPrint(snapshot.error.toString());
      return const Align(alignment: Alignment.center, child: Text('يوجد خطأ', style: AppTextTheme.headerTextStyle));
    }
    if(snapshot.connectionState == ConnectionState.waiting){
      return const Align(alignment: Alignment.center, child: CircularProgressIndicator());
    }
    return Container(
        padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
    border: Border.all(color: darkGray),
    borderRadius: BorderRadius.circular(10)
    ),
    child: Stack(
          children: [
            transactions.isEmpty? const SizedBox(width: double.infinity, child: Text('لا يوجد بيانات', style: AppTextTheme.headerTextStyle, textAlign: TextAlign.center,))
            : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: grouped.length,
              itemBuilder: (_,index) {
                return ExpensesCategorize(
                    categoryName: grouped[index]['name'],
                    categoryIcon: grouped[index]['icon'],
                    categoryAmount: grouped[index]['amount'],
                    totalExpense: expenses
                );
              }
            )
          ],
        )
    );
  }
}
