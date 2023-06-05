import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:month_picker_dialog/month_picker_dialog.dart';
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
import '../../model/transaction.dart';
import '../widgets/custom_card.dart';
import '../widgets/transaction_history_item.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    final controller = Provider.of<TransactionController>(context);
    final auth = FirebaseAuth.instance;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .background,
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
                    stream: controller.getTransactions(),
                    builder: (context, snapshot) {
                      return ProfileWidget(
                        currentUser: auth.currentUser,
                        controller: controller,
                        snapshot: snapshot,
                        onLogout: () async {
                          await FirebaseAuthServices(auth).logout();
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
              stream: controller.getTransactions(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      CenteredHeader(header: Utils.dateFormat(date: controller.pickedDate, showDays: false)),
                      const SizedBox(height: 20),
                      _headerSection(header: 'ملخص الشهر'),
                      _monthlySummarySection(
                          controller: controller, snapshot: snapshot),
                      const SizedBox(height: 16),
                      _headerSection(
                          header: 'آخر المعاملات', showMore: true),
                      _lastTransactionsSection(
                          controller: controller, snapshot: snapshot),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _headerSection({required String header, bool showMore = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header, style: AppTextTheme.headerTextStyle),
            showMore
                ? TextButton(
              onPressed: () =>
                  Get.to(() =>
                  const Directionality(
                      textDirection: TextDirection.rtl,
                      child: TransactionHistoryScreen())),
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

  Widget _monthPicker({required BuildContext context,
    required TransactionController controller}) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showMonthPicker(
            lastDate: DateTime.now(),
            context: context,
            locale: const Locale('ar'),
            roundedCornersRadius: 20,
            headerColor: Theme
                .of(context)
                .colorScheme
                .primary,
            selectedMonthTextColor: whiteColor,
            unselectedMonthTextColor: blackColor,
            dismissible: true,
            cancelWidget: const Text(
              'اغلاق',
              style:
              TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
            ),
            confirmWidget: const Text(
              'تم',
              style:
              TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
            ));
        controller.onChangePickedMonth(pickedDate!);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            intl.DateFormat('MMMM yyyy', 'ar').format(controller.pickedDate),
            style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, color: redColor)
        ],
      ),
    );
  }

  Widget _monthlySummarySection(
      {required AsyncSnapshot<List<Transaction>> snapshot,
        required TransactionController controller}) {
    final transactionsByMonth = controller.transactionsByMonth(
        transactions: snapshot.data, pickedDate: controller.pickedDate) ??
        [];
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
                      amount: controller.calculateTotal(
                          transactions: transactionsByMonth),
                      amountFontSize: 30,
                      currencyFontSize: 18,
                      color: controller.calculateTotal(
                          transactions: transactionsByMonth) <
                          0
                          ? Colors.red
                          : Colors.green,
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
                  ),
                  SummaryCard(
                    title: 'الدخل',
                    image: 'assets/icons/expense.png',
                    amount: controller.calculateTotal(
                      transactions: transactionsByMonth,
                      type: 'income',
                    ),
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

  Widget _lastTransactionsSection({required TransactionController controller,
    required AsyncSnapshot<List<Transaction>> snapshot}) {
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
                      transaction: transactions[index]),
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
