import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/reports/controller/reports_controller.dart';
import 'package:myfinance_app/reports/model/monthly_report_model.dart';
import 'package:myfinance_app/reports/view/widgets/chart_header.dart';
import 'package:myfinance_app/reports/view/widgets/info_widget.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import 'bar_chart.dart';

class MonthlyReport extends StatelessWidget {
  const MonthlyReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionController =
        Provider.of<TransactionController>(context, listen: false);
    final reportsController =
    Provider.of<ReportsController>(context, listen: false);
    return StreamBuilder(
        stream: transactionController.getTransactions(),
        builder: (context, snapshot) {
            final transactions = snapshot.data;
            final latestFiveMonths = reportsController.getLatestFiveMonths();
            final data = latestFiveMonths.map((month) {
              final monthlyTransactions =
                  transactionController.transactionsByMonth(
                    transactions: transactions,
                    pickedMonth: month,
                  ) ??[];
              final incomes = transactionController.calculateTotal(
                transactions: monthlyTransactions, type: 'income',
              );
              final expenses = transactionController.calculateTotal(
                  transactions: monthlyTransactions, type: 'expense',
              );
              return MonthlyReportModel(
                incomes: incomes,
                expenses: expenses,
                month: DateFormat('MMMM', 'ar').format(month),
              );
            }).toList();
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: lightGrey),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onBackground),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const ChartHeader(
                    header: 'أداؤك المالي خلال آخر 5 أشهر',
                    showFilter: false,
                  ),
                  const SizedBox(height: 30),
                  (transactions != null && transactions.isNotEmpty)? Column(
                    children: [
                      SizedBox(height: 200, child: DrawBarChart(data: data)),
                      const Padding(
                        padding: EdgeInsets.only(top: 18, bottom: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InfoWidget(
                                  label: 'مجموع النفقات',
                                  color: Color(0xFFEF4A37),
                                  labelSize: 10),
                              InfoWidget(
                                label: 'مجموع الدخل',
                                color: Color(0xFFF7ADA7),
                                labelSize: 10,
                              ),
                            ]),
                      )
                    ],
                  ): const EmptyWidget()
                ],
              ),
            ),
          );
        });
  }
}
