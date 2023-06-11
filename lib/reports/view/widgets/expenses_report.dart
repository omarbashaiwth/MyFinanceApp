import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/widgets/empty_widget.dart';
import 'package:myfinance_app/reports/controller/reports_controller.dart';
import 'package:myfinance_app/reports/view/widgets/chart_header.dart';
import 'package:myfinance_app/reports/view/widgets/info_widget.dart';
import 'package:myfinance_app/reports/view/widgets/pie_chart.dart.dart';
import 'package:myfinance_app/transactions/controller/transaction_controller.dart';
import 'package:provider/provider.dart';

class ExpensesReport extends StatelessWidget {
  const ExpensesReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context, listen: false);
    final reportsController = Provider.of<ReportsController>(context, listen: false);
    debugPrint('buildReport');
    return StreamBuilder(
      stream: transactionController.getTransactions(),
      builder: (context, snapshot) {
        final transactions = snapshot.data;
        final monthlyTransactions = transactionController.transactionsByMonth(transactions: transactions, pickedMonth: DateTime.now()) ?? [];
        final groupedExpenses = reportsController.groupExpenses(monthlyTransactions);
        final total  = transactionController.calculateTotal(transactions: monthlyTransactions, type: 'expense');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              border: Border.all(color: normalGray),
              borderRadius: BorderRadius.circular(10),
              color: whiteColor
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ChartHeader(
                    header: 'ملخص النفقات',
                    buttonLabel: 'هذا الشهر',
                    onFilterClick: () {},
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
