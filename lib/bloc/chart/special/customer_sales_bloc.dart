import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/customer_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';

class CustomerSalesBloc extends ChartBloc {
  CustomerSalesBloc({@required ChartRepository chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield SeriesLoading();
      final customerSalesData = await chartRepository.getCustomerSalesData(
        limit: ChartConfig.maxRecordLimit,
      );
      if (customerSalesData.isNotEmpty) {
        final series = _buildSeries(customerSalesData);
        yield SeriesLoaded<CustomerSalesRecord, String, CustomerSalesFilter>(
          series,
          activeFilter: CustomerSalesFilter(limit: ChartConfig.maxRecordLimit),
        );
      } else {
        yield SeriesLoadedEmpty<CustomerSalesFilter>(
          activeFilter: CustomerSalesFilter(limit: ChartConfig.maxRecordLimit),
        );
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  @override
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      yield SeriesLoading();
      final customerSalesFilter = event.filter as CustomerSalesFilter;
      final customerSalesData = await chartRepository.getCustomerSalesData(
        limit: customerSalesFilter?.limit,
      );
      if (customerSalesData.isNotEmpty) {
        final series = _buildSeries(customerSalesData);
        yield SeriesLoaded<CustomerSalesRecord, String, CustomerSalesFilter>(
          series,
          activeFilter: customerSalesFilter,
        );
      } else {
        yield SeriesLoadedEmpty<CustomerSalesFilter>(activeFilter: customerSalesFilter);
      }
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
