import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class AnnualSalesBloc extends ChartBloc {
  final ChartRepository chartRepository;

  AnnualSalesBloc({@required this.chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadDataEvent() async* {
    try {
      final data = await chartRepository.getAnnualSalesData();
      yield DataLoaded<AnnualSalesRecord>(data);
    } catch (e) {
      yield DataNotLoaded();
      throw e;
    }
  }
}
