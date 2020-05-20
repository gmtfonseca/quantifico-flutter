import 'dart:async';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnnualSalesBloc extends ChartBloc {
  AnnualSalesFilter _activeFilter = AnnualSalesFilter(
    startYear: DateTime.now().year - 4,
    endYear: DateTime.now().year,
  );

  AnnualSalesBloc({@required ChartRepository chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield SeriesLoading();
      final annualSalesData = await chartRepository.getAnnualSalesData(
        startYear: _activeFilter?.startYear,
        endYear: _activeFilter?.endYear,
      );
      if (annualSalesData.isNotEmpty) {
        final series = _buildSeries(annualSalesData);
        yield SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>(
          series,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<AnnualSalesFilter>(activeFilter: _activeFilter);
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  @override
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      _activeFilter = event.filter as AnnualSalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  List<charts.Series<AnnualSalesRecord, String>> _buildSeries(List<AnnualSalesRecord> data) {
    final numberFormat = NumberFormat.compactSimpleCurrency(locale: 'pt-BR', name: '');
    return [
      charts.Series<AnnualSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AnnualSalesRecord record, _) => record.year ?? 'Outro',
        measureFn: (AnnualSalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (AnnualSalesRecord record, _) => numberFormat.format(record.sales),
      )
    ];
  }
}
