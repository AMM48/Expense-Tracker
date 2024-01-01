import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

class BarChartModel {
  late String category;
  late double actualSpending;
  late double forecastedSpending;
  late final charts.Color actualColor;
  late final charts.Color forecastedColor;
  late final IconData icon;

  BarChartModel(
      {required this.category,
      required this.actualSpending,
      required this.forecastedSpending,
      required this.actualColor,
      required this.forecastedColor,
      required this.icon});
}
