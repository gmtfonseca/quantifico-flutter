import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/customer_sales_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';

import 'chart_filter_dialog.dart';

class CustomerSalesChart extends StatelessWidget {
  final CustomerSalesBloc bloc;
  final ChartContainerBloc containerBloc;

  CustomerSalesChart({
    Key key,
    @required this.bloc,
    this.containerBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerSalesBloc, ChartState>(
      bloc: bloc,
      builder: (
        BuildContext context,
        ChartState state,
      ) {
        if (containerBloc != null) {
          return ChartContainer(
            bloc: containerBloc,
            title: 'Faturamento por Cliente',
            chart: Chart(
              name: 'CustomerSalesChart',
              state: state,
              widget: _buildChart(state),
            ),
            filterDialog: _buildFilterDialog(state),
          );
        } else {
          return SizedBox(
            height: 350,
            child: _buildChart(state),
          );
        }
      },
    );
  }

  Widget _buildFilterDialog(ChartState state) {
    if (state is FilterableState) {
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
