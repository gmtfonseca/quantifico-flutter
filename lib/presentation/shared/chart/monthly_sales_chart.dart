import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/monthly_sales_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/monthly_sales_filter.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/presentation/shared/chart/chart_filter_dialog.dart';

class MonthlySalesChart extends StatelessWidget {
  final MonthlySalesBloc bloc;
  final ChartContainerBloc containerBloc;

  MonthlySalesChart({
    Key key,
    @required this.bloc,
    this.containerBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonthlySalesBloc, ChartState>(
        bloc: bloc,
        builder: (
          BuildContext context,
          ChartState state,
        ) {
          if (containerBloc != null) {
            return ChartContainer(
              bloc: containerBloc,
              title: 'Faturamento Mensal',
              chart: Chart(
                name: this.runtimeType.toString(),
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
        });
  }

  Widget _buildFilterDialog(ChartState state) {
    if (state is FilterableState) {
      return MonthlySalesFilterDialog(
        years: (state.activeFilter as MonthlySalesFilter)?.years,
        onApply: ({List<int> years}) {
          bloc.add(
            UpdateFilter(
              MonthlySalesFilter(years: years),
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

      final customTickFormatter = charts.BasicNumericTickFormatterSpec((num month) {
        switch (month.toInt()) {
          case 1:
            return "Jan";
          case 2:
            return "Fev";
          case 3:
            return "Mar";
          case 4:
            return "Abr";
          case 5:
            return "Mai";
          case 6:
            return "Jun";
          case 7:
            return "Jul";
          case 8:
            return "Ago";
          case 9:
            return "Set";
          case 10:
            return "Out";
          case 11:
            return "Nov";
          case 12:
            return "Dez";
          default:
            return '';
        }
      });

      const MONTHS_IN_YEAR = 12;
      return charts.LineChart(
        state.series,
        animate: true,
        behaviors: [charts.SeriesLegend()],
        primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
        domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            desiredTickCount: MONTHS_IN_YEAR,
            zeroBound: false,
            dataIsInWholeNumbers: true,
          ),
          tickFormatterSpec: customTickFormatter,
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

class MonthlySalesFilterDialog extends StatefulWidget {
  final void Function({List<int> years}) onApply;
  final List<int> years;

  MonthlySalesFilterDialog({
    this.onApply,
    this.years,
  });

  _MonthlySalesFilterDialogState createState() => _MonthlySalesFilterDialogState();
}

class _MonthlySalesFilterDialogState extends State<MonthlySalesFilterDialog> {
  List<int> _years;
  bool _addButtonEnabled;
  TextEditingController _yearController = TextEditingController();

  @override
  void initState() {
    _years = List.from(widget.years);
    _updateAddButtonAvailability();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget verticalSpacing = SizedBox(height: 15);
    return ChartFilterDialog(
      onApply: () {
        widget.onApply(years: _years);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quais anos você deseja visualizar?',
              style: Theme.of(context).textTheme.body1,
            ),
            verticalSpacing,
            Row(
              children: [
                _buildYearTextField(),
                _buildAddButton(),
              ],
            ),
            verticalSpacing,
            Wrap(
              spacing: 10,
              children: _buildYearChips(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearTextField() {
    return Expanded(
      child: TextField(
        controller: _yearController,
        autofocus: true,
        onChanged: (year) {
          setState(() {
            _updateAddButtonAvailability();
          });
        },
        decoration: InputDecoration(
          labelText: 'Ano',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 4,
      ),
    );
  }

  Widget _buildAddButton() {
    return FlatButton(
      child: Text('ADICIONAR'),
      onPressed: _addButtonEnabled
          ? () {
              setState(() {
                _years.add(int.parse(_yearController.text));
                _yearController.clear();
                _updateAddButtonAvailability();
              });
            }
          : null,
    );
  }

  List<Widget> _buildYearChips() {
    return _years
        .map((year) => Chip(
              label: Text(year.toString()),
              onDeleted: () {
                setState(() {
                  _years.remove(year);
                  _updateAddButtonAvailability();
                });
              },
            ))
        .toList()
        .cast<Widget>();
  }

  void _updateAddButtonAvailability() {
    const YEAR_LENGTH = 4;
    const MAX_YEARS = 4;
    _addButtonEnabled = _yearController.text.length == YEAR_LENGTH && _years.length < MAX_YEARS;
  }
}
