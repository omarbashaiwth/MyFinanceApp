import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/reports/view/widgets/chart_header.dart';
import 'package:myfinance_app/reports/view/widgets/info_widget.dart';
import 'package:myfinance_app/reports/view/widgets/pie_chart.dart.dart';

class ExpensesReport extends StatelessWidget {
  const ExpensesReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fakeData = [
      {
        'value': 25.0,
        'title' : '30%',
        'label' : 'إيجار',
        'color' : const Color(0xFF2B6373)
      },
      {
        'value': 7.0,
        'title' : '2%',
        'label':'أخرى',
        'color' : const Color(0xFF5388D8)
      },
      {
        'value': 10.0,
        'title' : '10%',
        'label':'كهرباء',
        'color' : const Color(0xFFFF9F40)
      },
      {
        'value': 5.0,
        'title' : '5%',
        'label':'مستلزمات البيت',
        'color' : const Color(0xFFE8978E)
      },
      {
        'value': 10.0,
        'title' : '10%',
        'label':'وقود',
        'color' : const Color(0xFF91E88E)
      },
      {
        'value': 20.0,
        'title' : '20%',
        'label':'تعليم',
        'color' : const Color(0xFFD58EE8)
      },
      {
        'value': 8.0,
        'title' : '8%',
        'label':'مواصلات',
        'color' : const Color(0xFF8EDBE8)
      },

    ];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 30),
                   child: SizedBox(
                      width: 150, height: 150, child: DrawPieChart(data: fakeData)),
                 ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(fakeData.length, (index) =>
                      Column(
                        children: [
                          InfoWidget(label: fakeData[index]['label'], color: fakeData[index]['color']),
                          const SizedBox(height: 4)
                        ],
                      )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
