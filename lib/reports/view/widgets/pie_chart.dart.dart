import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';

class DrawPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DrawPieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 0,
          sections: _buildPieChartSections(
              count: data.length,
              titles: data.map((e) => e['title']).toList(),
              values: data.map((e) => e['value']).toList(),
              colors: data.map((e) => e['color']).toList(),
          )
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      {required int count, required List<dynamic> titles,required List<dynamic> values, required List<
          dynamic> colors}) {
    return List.generate(count, (index) =>
        PieChartSectionData(
            showTitle: true,
            titleStyle: const TextStyle(
                fontSize: 10, color: whiteColor, fontWeight: FontWeight.bold),
            title:titles[index],
            value: values[index],
            color: colors[index]
        )
    );
  }
}
