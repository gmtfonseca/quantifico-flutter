import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/monthly_sales_filter.dart';
import 'package:quantifico/data/model/chart/monthly_sales_record.dart';

import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthlySalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  MonthlySalesBloc({@required this.chartRepository});

  @override
  ChartState get initialState => SeriesLoading();

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {
    if (event is LoadSeries) {
      yield* _mapLoadSeriesToState();
    } else if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    }
  }

  Stream<ChartState> _mapLoadSeriesToState() async* {
    try {
      final monthlySalesData = await chartRepository.getMonthlySalesData(
        years: [DateTime.now().year],
      );
      if (monthlySalesData.isNotEmpty) {
        final monthlySalesMap = _monthlySalesListToMap(monthlySalesData);
        final seriesList = _buildSeries(monthlySalesMap);
        yield SeriesLoaded<MonthSales, int>(seriesList);
      } else {
        yield SeriesLoadedEmpty();
      }
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      final monthlySalesData = await chartRepository.getMonthlySalesData(
        years: (event.filter as MonthlySalesFilter)?.years,
      );
      if (monthlySalesData.isNotEmpty) {
        final monthlySalesMap = _monthlySalesListToMap(monthlySalesData);
        final seriesList = _buildSeries(monthlySalesMap);
        yield SeriesLoadedFiltered<MonthSales, int, MonthlySalesFilter>(seriesList, event.filter);
      } else {
        yield SeriesLoadedEmpty();
      }
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
    }
  }

  Map<String, Map<String, double>> _monthlySalesListToMap(List<MonthlySalesRecord> data) {
    final Map<String, Map<String, double>> years = Map();
    data.forEach((MonthlySalesRecord record) {
      if (!years.containsKey(record.year)) {
        years[record.year] = {};
      }

      years[record.year][record.month] = record.sales;
    });
    return years;
  }

  List<charts.Series<MonthSales, int>> _buildSeries(Map<String, Map<String, double>> monthlySalesMap) {
    final List colors = [
      charts.MaterialPalette.blue,
      charts.MaterialPalette.red,
      charts.MaterialPalette.yellow,
      charts.MaterialPalette.green
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

  List _toFilledMonthSalesList(Map<String, double> year) {
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
