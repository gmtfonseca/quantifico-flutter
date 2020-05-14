import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/city_sales_filter.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';
import 'package:intl/intl.dart';

import 'chart_filter_dialog.dart';

class CitySalesChart extends Chart {
  CitySalesChart({
    Key key,
    @required ChartBloc bloc,
  }) : super(key: key, bloc: bloc);

  @override
  Widget buildContent() {
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
    );

    return charts.BarChart(
      (bloc.state as SeriesLoaded).series,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
    );
  }

  @override
  Widget filterDialog() {
    if (bloc.state is FilterableState) {
      final state = bloc.state as FilterableState;
      return CitySalesFilterDialog(
        limit: (state.activeFilter as CitySalesFilter)?.limit,
        onApply: ({int limit}) {
          bloc.add(
            UpdateFilter(
              CitySalesFilter(limit: limit),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

class CitySalesFilterDialog extends StatefulWidget {
  final void Function({int limit}) onApply;
  final int limit;

  CitySalesFilterDialog({
    this.onApply,
    this.limit,
  });

  _CitySalesFilterDialogState createState() => _CitySalesFilterDialogState();
}

class _CitySalesFilterDialogState extends State<CitySalesFilterDialog> {
  double _limit;

  @override
  void initState() {
    _limit = widget.limit?.toDouble() ?? 1.0;
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
