import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/core/widgets/price_widget.dart';
import 'package:myfinance_app/reports/view/reports_screen.dart';
import 'package:myfinance_app/settings/view/settings_screen.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/view/screens/edit_transaction_screen.dart';
import 'package:myfinance_app/transactions/view/screens/transaction_history_screen.dart';
import 'package:myfinance_app/transactions/view/widgets/centered_header.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../core/widgets/tutorial_targets.dart';
import '../../../currency/controller/currency_controller.dart';
import '../../model/transaction.dart' as my_transaction;
import '../widgets/custom_card.dart';
import '../widgets/transaction_history_item.dart';

class TransactionsScreen extends StatefulWidget {
  final List<GlobalKey> tutTargetsKeys;
  final Function onNavigateToWalletScreen;
  const TransactionsScreen({Key? key, required this.tutTargetsKeys, required this.onNavigateToWalletScreen}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('tutorial') ?? true) {
        createTutorial(prefs, widget.tutTargetsKeys);
        showTutorial();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context);
    final currencyController = Provider.of<CurrencyController>(context);
    final currency = currencyController.currency;
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          title:  Text(
            'المعاملات',
            style: AppTextTheme.appBarTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Get.to(() => const ReportsScreen()),
              icon:  Icon(Icons.insert_chart_outlined_rounded,
                  color: Theme.of(context).colorScheme.onSecondary),
            )
          ],
          leading: IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              Get.to(() =>  SettingsScreen(prefs: prefs));
              },
            icon:  Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onSecondary),
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: transactionController.getTransactions(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future:currencyController.getCurrencyFromFirebase(userId: auth.currentUser!.uid, firestore: firestore),
                    builder: (_, __)  => Column(
                      children: [
                        CenteredHeader(
                            header: Utils.dateFormat(
                                date: DateTime.now(), showDays: false),
                        ),
                        const SizedBox(height: 20),
                        _headerSection(header: 'ملخص الشهر', currency: currency?.symbol ?? ''),
                        _monthlySummarySection(
                            controller: transactionController,
                            snapshot: snapshot,
                            currency: currency?.symbol ?? '',
                            width: screenWidth/2.5
                        ),
                        const SizedBox(height: 16),
                        _headerSection(
                            header: 'آخر المعاملات',
                            showMore: true,
                            currency: currency?.symbol ?? '',
                        ),
                        _lastTransactionsSection(
                            controller: transactionController,
                            snapshot: snapshot,
                            currency: currency?.symbol ?? '',
                        ),
                      ],
                    ),
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
      required String? currency}) {
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
                            .copyWith(color: orangeyRed)),
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
      required String? currency,
        required double width,
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
            gradient:  LinearGradient(
                colors: [Get.isDarkMode? darkGrey:orangeyRed, Get.isDarkMode? darkGrey:redBrown],
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
                      borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(Get.context!).colorScheme.surface,
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
                          calculateDiff.isNegative ? red : green,
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
                    color: red,
                    width: width,
                  ),
                  SummaryCard(
                    title: 'الدخل',
                    image: 'assets/icons/expense.png',
                    amount: controller.calculateTotal(
                      transactions: transactionsByMonth,
                      type: 'income',
                    ),
                    currency: currency,
                    color: green,
                    width: width,
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
      required String? currency,
      required AsyncSnapshot<List<my_transaction.Transaction>> snapshot}) {
    final transactions = snapshot.data?.take(5).toList() ?? [];
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: lightGrey),
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
                          onItemClicked: () {
                            if(transactions[index].type == 'expense' || transactions[index].type == 'income'){
                              Get.to(() => EditTransactionScreen(transaction: transactions[index]));
                            }
                          },
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

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial(SharedPreferences prefs, List<GlobalKey> keys) {
    tutorialCoachMark = TutorialCoachMark(
      targets: TutorialTargets.createTargets(keys),
      hideSkip: true,
      colorShadow: Colors.grey[600]!,
      opacityShadow: 0.4,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () => prefs.setBool('tutorial', false),
      onClickTarget: (target) {
        if(target.identify == 'tut_target_3'){
          widget.onNavigateToWalletScreen();
        }
      },
    );
  }
}
