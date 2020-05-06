import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/city_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class CitySalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  CitySalesBloc({@required this.chartRepository});

  @override
  ChartState get initialState => DataLoading();

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {
    if (event is LoadData) {
      yield* _mapLoadDataToState(event);
    } else if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    }
  }

  Stream<ChartState> _mapLoadDataToState(LoadData event) async* {
    try {
      final data = await chartRepository.getCitySalesData(limit: ChartConfig.maxRecordLimit);
      yield DataLoaded<CitySalesRecord>(data);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      final data = await chartRepository.getCitySalesData(limit: event.filter?.limit);
      yield DataLoadedFiltered<CitySalesRecord, CitySalesFilter>(data, event.filter);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }
}
