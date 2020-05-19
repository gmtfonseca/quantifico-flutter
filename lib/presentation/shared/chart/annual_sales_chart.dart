import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';
import 'package:quantifico/presentation/shared/filter_dialog.dart';

class AnnualSalesChart extends Chart {
  const AnnualSalesChart({
    Key key,
    @required ChartBloc bloc,
  }) : super(key: key, bloc: bloc);

  @override
  Widget buildContent() {
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
    );

    final state = bloc.state as SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>;
    return charts.BarChart(
      state.series,
      animate: true,
      primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
    );
  }

  @override
  Widget buildFilterDialog() {
    if (bloc.state is FilterableState) {
      final state = bloc.state as FilterableState;
      return AnnualSalesFiltersDialog(
        startYear: (state.activeFilter as AnnualSalesFilter)?.startYear,
        endYear: (state.activeFilter as AnnualSalesFilter)?.endYear,
        onApply: ({int startYear, int endYear}) {
          bloc.add(
            UpdateFilter(
              AnnualSalesFilter(
                startYear: startYear,
                endYear: endYear,
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

class AnnualSalesFiltersDialog extends StatefulWidget {
  final void Function({int startYear, int endYear}) onApply;
  final int startYear;
  final int endYear;

  const AnnualSalesFiltersDialog({
    this.onApply,
    this.startYear,
    this.endYear,
  });

  @override
  _AnnualSalesFiltersDialogState createState() => _AnnualSalesFiltersDialogState();
}

class _AnnualSalesFiltersDialogState extends State<AnnualSalesFiltersDialog> {
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startYearController.text = widget.startYear?.toString();
    _endYearController.text = widget.endYear?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FilterDialog(
      onApply: () {
        widget.onApply(
          startYear: _startYearController.text.isNotEmpty ? int.parse(_startYearController.text) : null,
          endYear: _endYearController.text.isNotEmpty ? int.parse(_endYearController.text) : null,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            TextField(
              controller: _startYearController,
              maxLength: 4,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Ano inicial',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _endYearController,
              maxLength: 4,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Ano final',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
    );
  }
}
