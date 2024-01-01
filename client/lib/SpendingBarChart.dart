// ignore: file_names
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';

import 'classes/bar_chart_model.dart';

class SpendingBarChart extends StatelessWidget {
  final List<BarChartModel> data;
  final bool isNotEmpty;
  const SpendingBarChart(
      {super.key, required this.data, required this.isNotEmpty});

  @override
  Widget build(BuildContext context) {
    try {
      return charts.BarChart(
        [
          charts.Series<BarChartModel, String>(
            id: 'Actual Spending',
            domainFn: (BarChartModel transaction, _) => transaction.category,
            measureFn: (BarChartModel transaction, _) =>
                transaction.actualSpending,
            colorFn: (BarChartModel transaction, _) => transaction.actualColor,
            data: data,
          ),
          if (isNotEmpty)
            charts.Series<BarChartModel, String>(
              id: 'Forecasted Spending',
              domainFn: (BarChartModel transaction, _) => transaction.category,
              measureFn: (BarChartModel transaction, _) => double.parse(
                  transaction.forecastedSpending.toStringAsFixed(2)),
              colorFn: (BarChartModel transaction, _) =>
                  transaction.forecastedColor,
              data: data,
            ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        primaryMeasureAxis: const charts.NumericAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(),
        ),
        domainAxis: const charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelRotation: 45,
          ),
        ),
        behaviors: [
          charts.SeriesLegend(
            desiredMaxColumns: 2,
            position: charts.BehaviorPosition.top,
            horizontalFirst: true,
            outsideJustification: charts.OutsideJustification.start,
            entryTextStyle: charts.TextStyleSpec(
              fontSize: 11,
              color: charts.ColorUtil.fromDartColor(Colors.black),
            ),
          ),
        ],
      );
    } catch (e) {
      showErrorSnackbar(context, e.toString());
      return const Scaffold(
        body: Center(
          child: Text('An unexpected error occurred'),
        ),
      );
    }
  }
}
