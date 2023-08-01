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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSecondary,),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          title:  Text(
            'التقارير',
            style: AppTextTheme.appBarTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
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
