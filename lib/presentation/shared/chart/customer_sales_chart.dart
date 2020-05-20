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
import 'package:quantifico/presentation/shared/text_date_picker.dart';

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
      barRendererDecorator: charts.BarLabelDecorator<String>(
        insideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.white, fontSize: 11),
        outsideLabelStyleSpec: const charts.TextStyleSpec(fontSize: 11),
      ),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: simpleCurrencyFormatter,
        renderSpec: const charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: charts.Color.transparent),
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildFilterDialog() {
    if (bloc.state is FilterableState) {
      final activeFilter = (bloc.state as FilterableState).activeFilter as CustomerSalesFilter;

      return CustomerSalesFilterDialog(
        startDate: activeFilter?.startDate,
        endDate: activeFilter?.endDate,
        limit: activeFilter?.limit,
        onApply: (startDate, endDate, limit) {
          bloc.add(
            UpdateFilter(
              CustomerSalesFilter(
                startDate: startDate,
                endDate: endDate,
                limit: limit,
              ),
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
  final void Function(
    DateTime startDate,
    DateTime endDate,
    int limit,
  ) onApply;
  final DateTime startDate;
  final DateTime endDate;
  final int limit;

  const CustomerSalesFilterDialog({
    this.onApply,
    this.startDate,
    this.endDate,
    this.limit,
  });

  @override
  _CustomerSalesFilterDialogState createState() => _CustomerSalesFilterDialogState();
}

class _CustomerSalesFilterDialogState extends State<CustomerSalesFilterDialog> {
  DateTime _startDate;
  DateTime _endDate;
  double _limit;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _limit = widget.limit?.toDouble() ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return FilterDialog(
      onApply: () {
        widget.onApply(
          _startDate,
          _endDate,
          _limit.round(),
        );
      },
      onClear: () {
        setState(() {
          _startDate = null;
          _endDate = null;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDatePicker(
              onChanged: (value) {
                _startDate = value;
              },
              labelText: 'Data inicial',
              initialValue: _startDate,
            ),
            const SizedBox(height: 20),
            TextDatePicker(
              onChanged: (value) {
                _endDate = value;
              },
              labelText: 'Data final',
              initialValue: _endDate,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Limite',
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Slider(
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
                ),
                const SizedBox(width: 5),
                Text(
                  '${_limit.round()}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
