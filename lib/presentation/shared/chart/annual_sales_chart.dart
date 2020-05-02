import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';

class AnnualSalesChart extends StatelessWidget {
  final ChartBloc bloc;

  AnnualSalesChart({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnualSalesBloc, ChartState>(
        bloc: bloc,
        builder: (
          BuildContext context,
          ChartState state,
        ) {
          return ChartContainer(
            title: 'Faturamento Anual',
            chartState: state,
            child: _buildChart(state),
          );
        });
  }

  Widget _buildChart(ChartState state) {
    if (state is DataLoaded<AnnualSalesRecord>) {
      final series = [
        Series<AnnualSalesRecord, String>(
          id: 'Sales',
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          domainFn: (AnnualSalesRecord sales, _) => sales.year,
          measureFn: (AnnualSalesRecord sales, _) => sales.sales,
          data: state.data,
        )
      ];

      final simpleCurrencyFormatter = BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
      );

      return BarChart(
        series,
        animate: true,
        primaryMeasureAxis: NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
      );
    } else {
      return SizedBox();
    }
  }
}
