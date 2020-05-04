import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/special.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';

class InsightScreen extends StatefulWidget {
  @override
  _InsightScreenState createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  AnnualSalesBloc _annualSalesBloc;
  CustomerSalesBloc _customerSalesBloc;
  List<Bloc> _charts = [];

  @override
  void didChangeDependencies() {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    _annualSalesBloc = AnnualSalesBloc(chartRepository: chartRepository);
    _charts.add(_annualSalesBloc);
    _customerSalesBloc = CustomerSalesBloc(chartRepository: chartRepository);
    _charts.add(_customerSalesBloc);
    _refreshCharts();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _annualSalesBloc?.close();
    _customerSalesBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = SizedBox(height: 15);
    return RefreshIndicator(
      onRefresh: () async {
        _refreshCharts();
      },
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          AnnualSalesChart(bloc: _annualSalesBloc),
          verticalSpacing,
          CustomerSalesChart(bloc: _customerSalesBloc),
        ],
      ),
    );
  }

  void _refreshCharts() {
    for (Bloc chart in _charts) {
      if (chart.state is DataLoadedFiltered) {
        chart.add(UpdateFilter((chart.state as DataLoadedFiltered).activeFilter));
      } else {
        chart.add(LoadData());
      }
    }
  }
}
