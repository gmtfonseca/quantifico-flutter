import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnnualSalesBloc extends ChartBloc {
  AnnualSalesBloc({@required ChartRepository chartRepository}) : super(chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield SeriesLoading();
      final annualSalesData = await chartRepository.getAnnualSalesData();
      if (annualSalesData.isNotEmpty) {
        final series = _buildSeries(annualSalesData);
        yield SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>(series);
      } else {
        yield const SeriesLoadedEmpty<AnnualSalesFilter>();
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  @override
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      yield SeriesLoading();
      final annualSalesFilter = event.filter as AnnualSalesFilter;
      final annualSalesData = await chartRepository.getAnnualSalesData(
        startYear: annualSalesFilter?.startYear,
        endYear: annualSalesFilter?.endYear,
      );
      if (annualSalesData.isNotEmpty) {
        final series = _buildSeries(annualSalesData);
        yield SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>(
          series,
          activeFilter: annualSalesFilter,
        );
      } else {
        yield SeriesLoadedEmpty<AnnualSalesFilter>(activeFilter: annualSalesFilter);
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }

  List<charts.Series<AnnualSalesRecord, String>> _buildSeries(List<AnnualSalesRecord> data) {
    return [
      charts.Series<AnnualSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AnnualSalesRecord record, _) => record.year ?? 'Outro',
        measureFn: (AnnualSalesRecord record, _) => record.sales,
        data: data,
      )
    ];
  }
}
