import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/customer_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class CustomerSalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  CustomerSalesBloc({@required this.chartRepository});

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
      final data = await chartRepository.getCustomerSalesData();
      yield DataLoaded<CustomerSalesRecord>(data);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }

  Stream<ChartState> _mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      final data = await chartRepository.getCustomerSalesData(limit: event.filter?.limit);
      yield DataLoadedFiltered<CustomerSalesRecord, CustomerSalesFilter>(data, event.filter);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }
}
