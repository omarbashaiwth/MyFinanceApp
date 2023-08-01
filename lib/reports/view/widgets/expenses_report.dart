import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/reports/controller/reports_controller.dart';
import 'package:myfinance_app/reports/view/widgets/chart_header.dart';
import 'package:myfinance_app/reports/view/widgets/info_widget.dart';
import 'package:myfinance_app/reports/view/widgets/pie_chart.dart.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';

class ExpensesReport extends StatelessWidget {
  const ExpensesReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context, listen: false);
    final reportsController = Provider.of<ReportsController>(context);
    return StreamBuilder(
      stream: transactionController.getTransactions(),
      builder: (context, snapshot) {
        final transactions = snapshot.data;
        final monthlyTransactions = transactionController.transactionsByMonth(transactions: transactions, pickedMonth: reportsController.pickedDate) ?? [];
        final groupedExpenses = reportsController.groupExpenses(monthlyTransactions);
        final total  = transactionController.calculateTotal(transactions: monthlyTransactions, type: 'expense');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              border: Border.all(color: lightGrey),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onBackground
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ChartHeader(
                    header: 'ملخص النفقات',
                    buttonLabel: reportsController.pickedDate.month == DateTime.now().month? 'هذا الشهر':Utils.dateFormat(date: reportsController.pickedDate, showDays: false),
                    onFilterClick: () async {
                      final pickedMonth = await showMonthPicker(
                        lastDate: DateTime.now(),
                        initialDate: reportsController.pickedDate,
                        context: context,
                        locale: const Locale('ar'),
                        roundedCornersRadius: 20,
                        headerColor: Theme.of(context).colorScheme.primary,
                        selectedMonthTextColor: white,
                        unselectedMonthTextColor: Theme.of(context).colorScheme.onPrimary,
                        dismissible: true,
                        cancelWidget: const Text(
                          'اغلاق',
                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                        ),
                        confirmWidget: const Text(
                          'تم',
                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                        )
                      );
                      reportsController.onChangePickedMonth(pickedMonth!);
                    },
                ),
                const SizedBox(height: 30),
               groupedExpenses.isNotEmpty? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     Padding(
                       padding: const EdgeInsets.only(bottom: 30),
                       child: SizedBox(width:150, height: 150, child: DrawPieChart(data: groupedExpenses, totalExpenses: total,)),
                     ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(groupedExpenses.length, (index) =>
                          Column(
                            children: [
                              InfoWidget(label: groupedExpenses[index].name, color: AppTheme.pieChartColors[index]),
                              const SizedBox(height: 4)
                            ],
                          )
                      )
                    )
                  ],
                ): const EmptyWidget()
              ],
            ),
          ),
        );
      }
    );
  }
}
