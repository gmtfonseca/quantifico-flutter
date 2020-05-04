import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/customer_sales_bloc.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';

import 'chart_filter_dialog.dart';

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
            chart: _buildChart(state),
            filtersDialog: CustomerSalesFilters(),
          );
        });
  }

  Widget _buildChart(ChartState state) {
    if (state is DataLoaded<CustomerSalesRecord>) {
      final series = [
        charts.Series<CustomerSalesRecord, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (CustomerSalesRecord record, _) => record.customer,
          measureFn: (CustomerSalesRecord record, _) => record.sales,
          data: state.data,
          labelAccessorFn: (CustomerSalesRecord record, _) => '${record.customer}',
        ),
      ];

      final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
      );

      return charts.BarChart(
        series,
        animate: true,
        vertical: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
        primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
      );
    } else {
      return SizedBox();
    }
  }
}

class CustomerSalesFilters extends StatefulWidget {
  @override
  _CustomerSalesFiltersState createState() => _CustomerSalesFiltersState();
}

class _CustomerSalesFiltersState extends State<CustomerSalesFilters> {
  double _limit;

  @override
  void initState() {
    _limit = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChartFilterDialog(
      content: Slider(
        label: '${_limit.round()}',
        value: _limit,
        onChanged: (value) {
          setState(() {
            _limit = value;
          });
        },
        min: 1.0,
        max: 15.0,
        divisions: 15,
      ),
    );
  }
}
