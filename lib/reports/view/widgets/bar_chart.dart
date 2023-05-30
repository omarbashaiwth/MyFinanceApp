import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DrawBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DrawBarChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      titlesData: FlTitlesData(
          topTitles: AxisTitles(axisNameWidget: null),
          rightTitles: AxisTitles(axisNameWidget: null),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget:(value, _) => Text(data[value.toInt()]['month'], style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),),
            )
          )
      ),
      borderData: FlBorderData(show: false),
        gridData: FlGridData(drawVerticalLine: false),
        barGroups: _buildBars(
            incomes: data.map((e) => e['income']).toList(),
            expenses: data.map((e) => e['expense']).toList()
        )
    )
    );

  }

  List<BarChartGroupData> _buildBars({required List<dynamic> incomes, required List<dynamic> expenses, double? width = 12}){
    return List.generate(5, (index) =>
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: incomes[index],
              color: const Color(0xFFF7ADA7),
              width: width
            ),
            BarChartRodData(
                toY: expenses[index],
                color: const Color(0xFFEF4A37),
                width: width
            ),
          ]
        )
    );
  }

}
