import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/filter/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/customer_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';

class CustomerSalesBloc extends ChartBloc {
  CustomerSalesFilter _activeFilter = CustomerSalesFilter(
    limit: ChartConfig.maxRecordLimit,
    sort: -1,
  );

  CustomerSalesBloc({@required ChartRepository chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield SeriesLoading();
      final customerSalesData = await chartRepository.getCustomerSalesData(
        startDate: _activeFilter?.startDate,
        endDate: _activeFilter?.endDate,
        limit: _activeFilter.limit,
        sort: _activeFilter.sort,
      );
      if (customerSalesData.isNotEmpty) {
        final series = _buildSeries(customerSalesData);
        yield SeriesLoaded<CustomerSalesRecord, String, CustomerSalesFilter>(
          series,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<CustomerSalesFilter>(
          activeFilter: _activeFilter,
        );
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  @override
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      _activeFilter = event.filter as CustomerSalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield SeriesNotLoaded();
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
