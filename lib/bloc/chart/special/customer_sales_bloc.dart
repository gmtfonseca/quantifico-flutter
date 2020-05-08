import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/customer_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';

class CustomerSalesBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  CustomerSalesBloc({@required this.chartRepository});

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
      final customerSalesData = await chartRepository.getCustomerSalesData(
        limit: ChartConfig.maxRecordLimit,
      );
      if (customerSalesData.isNotEmpty) {
        final series = _buildSeries(customerSalesData);
        yield SeriesLoaded<CustomerSalesRecord, String>(series);
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
      final customerSalesData = await chartRepository.getCustomerSalesData(
        limit: (event.filter as CustomerSalesFilter)?.limit,
      );
      if (customerSalesData.isNotEmpty) {
        final series = _buildSeries(customerSalesData);
        yield SeriesLoadedFiltered<CustomerSalesRecord, String, CustomerSalesFilter>(series, event.filter);
      } else {
        yield SeriesLoadedEmpty();
      }
    } catch (e) {
      yield SeriesNotLoaded();
      throw e;
    }
  }

  List<charts.Series<CustomerSalesRecord, String>> _buildSeries(List<CustomerSalesRecord> data) {
    const MAX_CITY_LENGTH = 35;
    return [
      charts.Series<CustomerSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (CustomerSalesRecord record, _) => record.customer,
        measureFn: (CustomerSalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (CustomerSalesRecord record, _) => toLimitedLength(
          record.customer,
          MAX_CITY_LENGTH,
        ),
      )
    ];
  }
}
