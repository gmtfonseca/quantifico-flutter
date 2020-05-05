import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/annual_sales_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/presentation/shared/chart/chart_filter_dialog.dart';

class AnnualSalesChart extends StatelessWidget {
  final AnnualSalesBloc bloc;

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
          chart: _buildChart(state),
          filterDialog: AnnualSalesFiltersDialog(
            startYear: state is DataLoadedFiltered ? state.activeFilter.startYear : null,
            endYear: state is DataLoadedFiltered ? state.activeFilter.endYear : null,
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
          ),
        );
      },
    );
  }

  Widget _buildChart(ChartState state) {
    if (state is DataLoaded<AnnualSalesRecord>) {
      final series = [
        charts.Series<AnnualSalesRecord, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (AnnualSalesRecord record, _) => record.year ?? 'Outro',
          measureFn: (AnnualSalesRecord record, _) => record.sales,
          data: state.data,
        )
      ];

      final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
      );

      return charts.BarChart(
        series,
        animate: true,
        primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
      );
    } else {
      return SizedBox();
    }
  }
}

class AnnualSalesFiltersDialog extends StatefulWidget {
  final void Function({int startYear, int endYear}) onApply;
  final int startYear;
  final int endYear;

  AnnualSalesFiltersDialog({
    this.onApply,
    this.startYear,
    this.endYear,
  });

  @override
  _AnnualSalesFiltersDialogState createState() => _AnnualSalesFiltersDialogState();
}

class _AnnualSalesFiltersDialogState extends State<AnnualSalesFiltersDialog> {
  TextEditingController _startYearController = TextEditingController();
  TextEditingController _endYearController = TextEditingController();

  @override
  void initState() {
    _startYearController.text = widget.startYear?.toString();
    _endYearController.text = widget.endYear?.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChartFilterDialog(
      onApply: () {
        widget.onApply(
          startYear: _startYearController.text.isNotEmpty ? int.parse(_startYearController.text) : null,
          endYear: _endYearController.text.isNotEmpty ? int.parse(_endYearController.text) : null,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: _startYearController,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Ano inicial',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 25),
            TextField(
              controller: _endYearController,
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
