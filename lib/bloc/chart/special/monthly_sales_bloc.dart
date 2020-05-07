import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/monthly_sales_filter.dart';
import 'package:quantifico/data/model/chart/monthly_sales_record.dart';

import 'package:quantifico/data/repository/chart_repository.dart';

class MonthlySalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  MonthlySalesBloc({@required this.chartRepository});

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
      final data = await chartRepository.getMonthlySalesData();

      final Map<String, Map<String, double>> years = Map();
      data.map((MonthlySalesRecord record) {
        if (!years.containsKey(record.year)) {
          years[record.year] = {};
        }

        years[record.year] = {record.month: record.sales};
      });

      final series = [];
      years.forEach((year, v) {
        final data = _fillEmptyMonths(years[year]);

        series.add({
          'name': year,
          'data': data,
        });
      });

      yield DataLoaded<MonthlySalesRecord>(series);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      // Implemente years filter
      final data = await chartRepository.getMonthlySalesData();
      yield DataLoadedFiltered<MonthlySalesRecord, MonthlySalesFilter>(data, event.filter);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }

  List _fillEmptyMonths(Map year) {
    final data = [];
    for (var m = 1; m <= 12; m++) {
      if (year.containsKey(m)) {
        data.add(year[m]);
      } else {
        data.add(0);
      }
    }
    return data;
  }
}
