import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/customer_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class CustomerSalesBloc extends ChartBloc {
  final ChartRepository chartRepository;

  CustomerSalesBloc({@required this.chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadDataEvent() async* {
    try {
      final data = await chartRepository.getCustomerSalesData();
      yield DataLoaded<CustomerSalesRecord>(data);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }
}
