import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/city_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';

class CitySalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  CitySalesBloc({@required this.chartRepository});

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
      final citySalesData = await chartRepository.getCitySalesData(limit: ChartConfig.maxRecordLimit);
      final series = _buildSeries(citySalesData);
      yield SeriesLoaded<CitySalesRecord, String>(series);
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      final citySalesData = await chartRepository.getCitySalesData(limit: (event.filter as CitySalesFilter)?.limit);
      final series = _buildSeries(citySalesData);
      yield SeriesLoadedFiltered<CitySalesRecord, String, CitySalesFilter>(series, event.filter);
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
    }
  }

  List<charts.Series<CitySalesRecord, String>> _buildSeries(List<CitySalesRecord> data) {
    const MAX_CITY_LENGTH = 35;
    return [
      charts.Series<CitySalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (CitySalesRecord record, _) => record.city,
        measureFn: (CitySalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (CitySalesRecord record, _) => toLimitedLength(
          record.city,
          MAX_CITY_LENGTH,
        ),
      )
    ];
  }
}
