import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_app/auth/controller/services/firebase_auth_services.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';
import 'package:myfinance_app/profile/widget/profile_widget.dart';
import 'package:myfinance_app/reports/view/reports_screen.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/view/screens/transaction_history_screen.dart';
import 'package:myfinance_app/transactions/view/widgets/centered_header.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../../currency/controller/currency_controller.dart';
import '../../model/transaction.dart' as my_transaction;
import '../widgets/custom_card.dart';
import '../widgets/transaction_history_item.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    final transactionController = Provider.of<TransactionController>(context);
    final currencyController =
        Provider.of<CurrencyController>(context, listen: false);
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final currency =
        currencyController.getCurrencyFromFirebase(userId: auth.currentUser?.uid ?? '', firestore: firestore) ;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'المعاملات',
            style: AppTextTheme.appBarTitleTextStyle,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Get.to(() => const ReportsScreen()),
              icon: const Icon(Icons.insert_chart_outlined_rounded,
                  color: redColor),
            )
          ],
          leading: IconButton(
            onPressed: () {
              Get.bottomSheet(Container(
                padding: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: StreamBuilder(
                    stream: transactionController.getTransactions(),
                    builder: (context, snapshot) {
                      return ProfileWidget(
                        currentUser: auth.currentUser,
                        currency: currency,
                        controller: transactionController,
                        snapshot: snapshot,
                        onLogout: () async {
                          await FirebaseAuthServices.logout();
                          Get.back();
                        },
                      );
                    }),
              ));
            },
            icon: auth.currentUser!.photoURL == null
                ? const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.red,
                  )
                : ClipOval(
                    child: Image.network(auth.currentUser!.photoURL!),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: transactionController.getTransactions(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      CenteredHeader(
                          header: Utils.dateFormat(
                              date: DateTime.now(), showDays: false),
                      ),
                      const SizedBox(height: 20),
                      _headerSection(header: 'ملخص الشهر', currency: currency),
                      _monthlySummarySection(
                          controller: transactionController,
                          snapshot: snapshot,
                          currency: currency,
                      ),
                      const SizedBox(height: 16),
                      _headerSection(
                          header: 'آخر المعاملات',
                          showMore: true,
                          currency: currency,
                      ),
                      _lastTransactionsSection(
                          controller: transactionController,
                          snapshot: snapshot,
                          currency: currency,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _headerSection(
      {required String header,
      bool showMore = false,
      required Future<String> currency}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header, style: AppTextTheme.headerTextStyle),
            showMore
                ? TextButton(
                    onPressed: () => Get.to(() => Directionality(
                        textDirection: TextDirection.rtl,
                        child: TransactionHistoryScreen(
                          currency: currency,
                        ))),
                    child: Text('عرض المزيد',
                        style: AppTextTheme.textButtonStyle
                            .copyWith(color: redColor)),
                  )
                : Container()
          ],
        ),
        showMore ? Container() : const SizedBox(height: 8),
      ],
    );
  }

  Widget _monthlySummarySection(
      {required AsyncSnapshot<List<my_transaction.Transaction>> snapshot,
      required Future<String> currency,
      required TransactionController controller}) {
    final transactionsByMonth = controller.transactionsByMonth(
            transactions: snapshot.data, pickedMonth: DateTime.now()) ??
        [];
    final calculateDiff =
        controller.calculateTotal(transactions: transactionsByMonth);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                colors: [redColor, darkRedColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: PriceWidget(
                      amount: calculateDiff.isNegative
                          ? -calculateDiff
                          : calculateDiff,
                      currency: currency,
                      amountFontSize: 30,
                      currencyFontSize: 18,
                      color:
                          calculateDiff.isNegative ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SummaryCard(
                    title: 'النفقات',
                    image: 'assets/icons/expense.png',
                    amount: controller.calculateTotal(
                        transactions: transactionsByMonth, type: 'expense'),
                    currency: currency,
                    color: Colors.red,
                  ),
                  SummaryCard(
                    title: 'الدخل',
                    image: 'assets/icons/expense.png',
                    amount: controller.calculateTotal(
                      transactions: transactionsByMonth,
                      type: 'income',
                    ),
                    currency: currency,
                    color: Colors.green,
                    quarterRotate: 2,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lastTransactionsSection(
      {required TransactionController controller,
      required Future<String> currency,
      required AsyncSnapshot<List<my_transaction.Transaction>> snapshot}) {
    final transactions = snapshot.data?.take(5).toList() ?? [];
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: darkGray),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          transactions.isEmpty
              ? const EmptyWidget()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: transactions.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        TransactionHistoryItem(
                          transaction: transactions[index],
                          currency: currency,
                        ),
                        index != transactions.indexOf(transactions.last)
                            ? const Divider()
                            : Container()
                      ],
                    );
                  },
                )
        ]));
  }
}
