import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnnualSalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  AnnualSalesBloc({@required this.chartRepository});

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
      final annualSalesData = await chartRepository.getAnnualSalesData();
      final series = _buildSeries(annualSalesData);
      yield SeriesLoaded<AnnualSalesRecord, String>(series);
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      final annualSalesData = await chartRepository.getAnnualSalesData(
        startYear: (event.filter as AnnualSalesFilter)?.startYear,
        endYear: (event.filter as AnnualSalesFilter)?.endYear,
      );

      final series = _buildSeries(annualSalesData);
      yield SeriesLoadedFiltered<AnnualSalesRecord, String, AnnualSalesFilter>(series, event.filter);
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
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
