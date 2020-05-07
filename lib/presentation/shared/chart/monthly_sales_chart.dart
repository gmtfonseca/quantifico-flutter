import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/presentation/shared/chart/chart.dart';

class MonthlySalesChartRecord {
  final int month;
  final double sales;

  MonthlySalesChartRecord({this.month, this.sales});
}

class MonthlySalesChart extends StatelessWidget {
  MonthlySalesChart({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  Widget _buildChart() {
    final List<MonthlySalesChartRecord> data1 = [
      MonthlySalesChartRecord(month: 1, sales: 13.0),
      MonthlySalesChartRecord(month: 2, sales: 12.0),
      MonthlySalesChartRecord(month: 3, sales: 25.0),
      MonthlySalesChartRecord(month: 4, sales: 11.0),
      MonthlySalesChartRecord(month: 5, sales: 27.0),
      MonthlySalesChartRecord(month: 6, sales: 13.0),
      MonthlySalesChartRecord(month: 7, sales: 26.0),
      MonthlySalesChartRecord(month: 8, sales: 10.0),
      MonthlySalesChartRecord(month: 9, sales: 6.0),
      MonthlySalesChartRecord(month: 10, sales: 14.0),
      MonthlySalesChartRecord(month: 11, sales: 13.0),
      MonthlySalesChartRecord(month: 12, sales: 22.0),
    ];

    final List<MonthlySalesChartRecord> data2 = [
      MonthlySalesChartRecord(month: 1, sales: 18.0),
      MonthlySalesChartRecord(month: 2, sales: 15.0),
      MonthlySalesChartRecord(month: 3, sales: 14.0),
      MonthlySalesChartRecord(month: 4, sales: 10.0),
      MonthlySalesChartRecord(month: 5, sales: 20.0),
      MonthlySalesChartRecord(month: 6, sales: 25.0),
      MonthlySalesChartRecord(month: 7, sales: 23.0),
      MonthlySalesChartRecord(month: 8, sales: 21.0),
      MonthlySalesChartRecord(month: 9, sales: 6.0),
      MonthlySalesChartRecord(month: 10, sales: 16.0),
      MonthlySalesChartRecord(month: 11, sales: 12.0),
      MonthlySalesChartRecord(month: 12, sales: 14.0),
    ];

    //Map<String, List<MonthlySalesChartRecord>>

    final List<charts.Series<MonthlySalesChartRecord, int>> series = [
      charts.Series<MonthlySalesChartRecord, int>(
        id: '2012',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MonthlySalesChartRecord sales, _) => sales.month,
        measureFn: (MonthlySalesChartRecord sales, _) => sales.sales,
        data: data1,
      ),
      charts.Series<MonthlySalesChartRecord, int>(
        id: '2013',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (MonthlySalesChartRecord sales, _) => sales.month,
        measureFn: (MonthlySalesChartRecord sales, _) => sales.sales,
        data: data2,
      ),
    ];

    final customTickFormatter = charts.BasicNumericTickFormatterSpec((num month) {
      final m = month.toInt();
      if (m == 1) {
        return "Jan";
      } else if (m == 2) {
        return "Feb";
      } else if (m == 3) {
        return "Mar";
      } else if (m == 4) {
        return "Abr";
      } else if (m == 5) {
        return "Mai";
      } else if (m == 6) {
        return "Jun";
      } else if (m == 7) {
        return "Jul";
      } else if (m == 8) {
        return "Ago";
      } else if (m == 9) {
        return "Set";
      } else if (m == 10) {
        return "Out";
      } else if (m == 11) {
        return "Nov";
      } else {
        return "Dez";
      }
    });

    return Container(
      color: Colors.white,
      height: 350,
      child: charts.LineChart(
        series,
        defaultRenderer: charts.LineRendererConfig(),
        domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            desiredTickCount: 12,
            zeroBound: false,
            dataIsInWholeNumbers: true,
          ),
          tickFormatterSpec: customTickFormatter,
        ),
      ),
    );
  }
}
