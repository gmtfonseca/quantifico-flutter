import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class AnnualSalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  AnnualSalesBloc({@required this.chartRepository});

  @override
  ChartState get initialState => DataLoading();

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {
    if (event is LoadData) {
      yield* _mapLoadDataToState(event);
    } else if (event is UpdateFilter<AnnualSalesFilter>) {
      yield* _mapUpdateFilterToState(event);
    }
  }

  Stream<ChartState> _mapLoadDataToState(LoadData event) async* {
    try {
      final data = await chartRepository.getAnnualSalesData();
      yield DataLoaded<AnnualSalesRecord>(data);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      final data = await chartRepository.getAnnualSalesData(
        startYear: event.filter?.startYear,
        endYear: event.filter?.endYear,
      );
      yield DataLoadedFiltered<AnnualSalesRecord, AnnualSalesFilter>(data, event.filter);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }
}
