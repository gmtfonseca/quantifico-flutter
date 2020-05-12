import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/city_sales_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/city_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';

import 'chart_filter_dialog.dart';

class CitySalesChart extends StatelessWidget {
  final CitySalesBloc bloc;

  CitySalesChart({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    // ignore: close_sinks
    final chartContainerBloc = ChartContainerBloc(chartRepository: chartRepository)
      ..add(LoadContainer(this.runtimeType.toString()));
    return BlocBuilder<CitySalesBloc, ChartState>(
        bloc: bloc,
        builder: (
          BuildContext context,
          ChartState state,
        ) {
          return ChartContainer(
            bloc: chartContainerBloc,
            title: 'Faturamento por Cidade',
            chart: Chart(
              name: 'CitySalesChart',
              state: state,
              widget: _buildChart(state),
            ),
            filterDialog: _buildFilterDialog(state),
          );
        });
  }

  Widget _buildFilterDialog(ChartState state) {
    if (state is FilterableState) {
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
