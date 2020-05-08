import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/customer_sales_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
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
          filterDialog: _buildFilterDialog(state),
        );
      },
    );
  }

  Widget _buildFilterDialog(ChartState state) {
    return CustomerSalesFilterDialog(
      limit: state is SeriesLoadedFiltered
          ? (state.activeFilter as CustomerSalesFilter).limit
          : ChartConfig.maxRecordLimit,
      onApply: ({int limit}) {
        bloc.add(
          UpdateFilter(
            CustomerSalesFilter(limit: limit),
          ),
        );
      },
    );
  }

  Widget _buildChart(ChartState state) {
    if (state is SeriesLoaded) {
      final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
      );

      return charts.BarChart(
        state.series,
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

class CustomerSalesFilterDialog extends StatefulWidget {
  final void Function({int limit}) onApply;
  final int limit;

  CustomerSalesFilterDialog({
    this.onApply,
    this.limit,
  });

  _CustomerSalesFilterDialogState createState() => _CustomerSalesFilterDialogState();
}

class _CustomerSalesFilterDialogState extends State<CustomerSalesFilterDialog> {
  double _limit;

  @override
  void initState() {
    _limit = widget.limit.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChartFilterDialog(
      onApply: () {
        widget.onApply(limit: _limit.round());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Limite'),
          Slider(
            label: '${_limit.round()}',
            value: _limit,
            onChanged: (value) {
              setState(() {
                _limit = value;
              });
            },
            min: 1.0,
            max: ChartConfig.maxRecordLimit.toDouble(),
            divisions: ChartConfig.maxRecordLimit,
          ),
        ],
      ),
    );
  }
}
