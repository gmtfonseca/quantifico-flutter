import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/customer_sales_record.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/presentation/shared/filter_dialog.dart';

class CustomerSalesChart extends Chart {
  const CustomerSalesChart({
    Key key,
    @required ChartBloc bloc,
  }) : super(key: key, bloc: bloc);

  @override
  Widget buildContent() {
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
    );

    final state = bloc.state as SeriesLoaded<CustomerSalesRecord, String, CustomerSalesFilter>;
    return charts.BarChart(
      state.series,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
    );
  }

  @override
  Widget buildFilterDialog() {
    if (bloc.state is FilterableState) {
      final state = bloc.state as FilterableState;
      return CustomerSalesFilterDialog(
        limit: (state.activeFilter as CustomerSalesFilter)?.limit,
        onApply: ({int limit}) {
          bloc.add(
            UpdateFilter(
              CustomerSalesFilter(limit: limit),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

class CustomerSalesFilterDialog extends StatefulWidget {
  final void Function({int limit}) onApply;
  final int limit;

  const CustomerSalesFilterDialog({
    this.onApply,
    this.limit,
  });

  @override
  _CustomerSalesFilterDialogState createState() => _CustomerSalesFilterDialogState();
}

class _CustomerSalesFilterDialogState extends State<CustomerSalesFilterDialog> {
  double _limit;

  @override
  void initState() {
    _limit = widget.limit?.toDouble() ?? 1.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilterDialog(
      onApply: () {
        widget.onApply(limit: _limit.round());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Limite'),
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
