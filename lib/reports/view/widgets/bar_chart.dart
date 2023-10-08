import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/monthly_report_model.dart';

class DrawBarChart extends StatelessWidget {
  final List<MonthlyReportModel> data;

  const DrawBarChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
              );
            }),
        ),
        titlesData: FlTitlesData(
            topTitles: const AxisTitles(axisNameWidget: null),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (value,meta) {
                    return Text(value == meta.max? '' : meta.formattedValue);
              }
            )),
            rightTitles: const AxisTitles(axisNameWidget: null),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  data[value.toInt()].month,
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
                ),
              ),
            ))),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(drawVerticalLine: false),
        barGroups: _buildBars(data: data)));
  }

  List<BarChartGroupData> _buildBars(
      {required List<MonthlyReportModel> data, double width = 12}) {
    return List.generate(
        data.length,
        (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                  toY: data[index].incomes,
                  color: const Color(0xFFF7ADA7),
                  width: width),
              BarChartRodData(
                  toY: data[index].expenses,
                  color: const Color(0xFFEF4A37),
                  width: width),
            ]));
  }
}
