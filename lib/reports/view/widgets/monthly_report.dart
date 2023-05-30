import 'package:flutter/material.dart';
import 'package:myfinance_app/reports/view/widgets/chart_header.dart';
import 'package:myfinance_app/reports/view/widgets/info_widget.dart';

import '../../../core/ui/theme.dart';
import 'bar_chart.dart';

class MonthlyReport extends StatelessWidget {
  const MonthlyReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fakeData = [
      {
        'month': 'مايو',
        'income': 12.0,
        'expense' : 15.0
      },
      {
        'month': 'أبريل',
        'income': 7.0,
        'expense' : 10.0
      },
      {
        'month': 'مارس',
        'income': 5.0,
        'expense' : 19.0
      },
      {
        'month': 'فبراير',
        'income': 14.0,
        'expense' : 15.0
      },
      {
        'month': 'يناير',
        'income': 10.0,
        'expense' : 18.0
      },

    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: normalGray),
          borderRadius: BorderRadius.circular(10),
          color: whiteColor),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const ChartHeader(
                header: 'أداؤك خلال آخر 5 أشهر',
                showFilter: false,
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                SizedBox(height: 200, child: DrawBarChart(data: fakeData)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    InfoWidget(label: 'مجموع النفقات', color: Color(0xFFEF4A37), labelSize: 10),
                    InfoWidget(label: 'مجموع الدخل', color: Color(0xFFF7ADA7), labelSize: 10,),
                  ]
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
