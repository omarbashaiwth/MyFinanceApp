import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/reports/model/expense_summray_model.dart';

class DrawPieChart extends StatelessWidget {
  final List<ExpenseSummaryModel> data;
  final double totalExpenses;
  const DrawPieChart({Key? key, required this.data, required this.totalExpenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 0,
          sections: _buildPieChartSections(
              data: data,
              totalExpenses: totalExpenses
          )
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections({required List<ExpenseSummaryModel> data, required double totalExpenses}) {
    return List.generate(data.length, (index) =>
        PieChartSectionData(
            showTitle: true,
            titleStyle: const TextStyle(
                fontSize: 10, color: whiteColor, fontWeight: FontWeight.bold),
            title: '${(data[index].value/totalExpenses * 100).round()}%',
            value: data[index].value,
            color: AppTheme.pieChartColors[index]
        )
    );
  }
}
