import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/monthly_sales_filter.dart';
import 'package:quantifico/data/model/chart/monthly_sales_record.dart';

import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthlySalesBloc extends ChartBloc {
  MonthlySalesBloc({@required ChartRepository chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield SeriesLoading();
      final defaultFilter = MonthlySalesFilter(years: [DateTime.now().year]);
      final monthlySalesData = await chartRepository.getMonthlySalesData(
        years: defaultFilter.years,
      );
      if (monthlySalesData.isNotEmpty) {
        final monthlySalesMap = _monthlySalesListToMap(monthlySalesData);
        final seriesList = _buildSeries(monthlySalesMap);
        yield SeriesLoaded<MonthSales, int, MonthlySalesFilter>(
          seriesList,
          activeFilter: defaultFilter,
        );
      } else {
        yield SeriesLoadedEmpty(activeFilter: defaultFilter);
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  @override
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      yield SeriesLoading();
      final monthlySalesFilter = event.filter as MonthlySalesFilter;
      final monthlySalesData = await chartRepository.getMonthlySalesData(
        years: monthlySalesFilter?.years,
      );
      if (monthlySalesData.isNotEmpty) {
        final monthlySalesMap = _monthlySalesListToMap(monthlySalesData);
        final seriesList = _buildSeries(monthlySalesMap);
        yield SeriesLoaded<MonthSales, int, MonthlySalesFilter>(
          seriesList,
          activeFilter: monthlySalesFilter,
        );
      } else {
        yield SeriesLoadedEmpty<MonthlySalesFilter>(activeFilter: monthlySalesFilter);
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  Map<String, Map<String, double>> _monthlySalesListToMap(List<MonthlySalesRecord> data) {
    final Map<String, Map<String, double>> years = Map();

    for (final record in data) {
      if (!years.containsKey(record.year)) {
        years[record.year] = {};
      }

      years[record.year][record.month] = record.sales;
    }

    return years;
  }

  List<charts.Series<MonthSales, int>> _buildSeries(Map<String, Map<String, double>> monthlySalesMap) {
    final colors = [
      charts.MaterialPalette.blue,
      charts.MaterialPalette.red,
      charts.MaterialPalette.green,
      charts.MaterialPalette.yellow,
    ];

    final List<charts.Series<MonthSales, int>> seriesList = [];
    var colorIdx = 0;
    monthlySalesMap.forEach((year, months) {
      final data = _toFilledMonthSalesList(months);
      final color = colors[colorIdx];
      final series = charts.Series<MonthSales, int>(
        id: year,
        colorFn: (_, __) => color.shadeDefault,
        domainFn: (MonthSales record, _) => int.parse(record.month),
        measureFn: (MonthSales record, _) => record.sales,
        data: data,
      );
      colorIdx += 1;
      seriesList.add(series);
    });

    return seriesList;
  }

  List<MonthSales> _toFilledMonthSalesList(Map<String, double> year) {
    const MONTHS_IN_YEAR = 12;
    final List<MonthSales> data = [];
    for (var m = 1; m <= MONTHS_IN_YEAR; m++) {
      final month = m.toString();
      if (year.containsKey(month)) {
        data.add(MonthSales(month: month, sales: year[month]));
      } else {
        data.add(MonthSales(month: month, sales: 0.0));
      }
    }
    return data;
  }
}
