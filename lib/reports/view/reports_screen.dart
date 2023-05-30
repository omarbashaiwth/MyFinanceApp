import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/reports/view/widgets/expenses_report.dart';
import 'package:myfinance_app/reports/view/widgets/monthly_report.dart';

import '../../core/ui/theme.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: redColor,),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'التقارير',
            style: AppTextTheme.appBarTitleTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                ExpensesReport(),
                SizedBox(height: 18),
                MonthlyReport()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
