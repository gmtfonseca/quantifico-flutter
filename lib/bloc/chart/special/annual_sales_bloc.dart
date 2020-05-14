import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnnualSalesBloc extends ChartBloc {
  AnnualSalesBloc({@required ChartRepository chartRepository}) : super(chartRepository: chartRepository);

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
      yield SeriesLoading();
      final annualSalesData = await chartRepository.getAnnualSalesData();
      if (annualSalesData.isNotEmpty) {
        final series = _buildSeries(annualSalesData);
        yield SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>(series);
      } else {
        yield SeriesLoadedEmpty();
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      yield SeriesLoading();
      final annualSalesData = await chartRepository.getAnnualSalesData(
        startYear: (event.filter as AnnualSalesFilter)?.startYear,
        endYear: (event.filter as AnnualSalesFilter)?.endYear,
      );
      if (annualSalesData.isNotEmpty) {
        final series = _buildSeries(annualSalesData);
        yield SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>(
          series,
          activeFilter: event.filter,
        );
      } else {
        yield SeriesLoadedEmpty<AnnualSalesFilter>(activeFilter: event.filter);
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  List<charts.Series<AnnualSalesRecord, String>> _buildSeries(List<AnnualSalesRecord> data) {
    return [
      charts.Series<AnnualSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AnnualSalesRecord record, _) => record.year ?? 'Outro',
        measureFn: (AnnualSalesRecord record, _) => record.sales,
        data: data,
      )
    ];
  }
}
