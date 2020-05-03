import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/customer_sales_bloc.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';

class CustomerSalesChart extends StatelessWidget {
  final CustomerSalesBloc bloc;

  CustomerSalesChart({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerSalesBloc, ChartState>(
        bloc: bloc,
        builder: (
          BuildContext context,
          ChartState state,
        ) {
          return ChartContainer(
            title: 'Faturamento x Cliente',
            chartState: state,
            child: _buildChart(state),
          );
        });
  }

  Widget _buildChart(ChartState state) {
    if (state is DataLoaded<CustomerSalesRecord>) {
      final series = [
        Series<CustomerSalesRecord, String>(
          id: 'Sales',
          colorFn: (_, __) => MaterialPalette.red.shadeDefault,
          domainFn: (CustomerSalesRecord record, _) => record.customer,
          measureFn: (CustomerSalesRecord record, _) => record.sales,
          data: state.data,
          labelAccessorFn: (CustomerSalesRecord record, _) => '${record.customer}',
        ),
      ];

      final simpleCurrencyFormatter = BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
      );

      return BarChart(
        series,
        animate: true,
        vertical: false,
        barRendererDecorator: BarLabelDecorator<String>(),
        domainAxis: OrdinalAxisSpec(renderSpec: NoneRenderSpec()),
        primaryMeasureAxis: NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
      );
    } else {
      return SizedBox();
    }
  }
}
