import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/city_sales_bloc.dart';
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
  CitySalesBloc _citySalesBloc;
  List<Bloc> _charts = [];

  @override
  void didChangeDependencies() {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    _annualSalesBloc = AnnualSalesBloc(chartRepository: chartRepository);
    _charts.add(_annualSalesBloc);
    _customerSalesBloc = CustomerSalesBloc(chartRepository: chartRepository);
    _charts.add(_customerSalesBloc);
    _citySalesBloc = CitySalesBloc(chartRepository: chartRepository);
    _charts.add(_citySalesBloc);
    _refreshCharts();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // must close explicitly, otherwise linter givers warning
    _annualSalesBloc?.close();
    _customerSalesBloc?.close();
    _citySalesBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = SizedBox(height: 15);
    return RefreshIndicator(
      onRefresh: () async {
        _refreshCharts();
      },
      child: Container(
        color: Color(0xffe0e0e0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListView(
            children: [
              MonthlySalesChart(),
              verticalSpacing,
              CitySalesChart(bloc: _citySalesBloc),
              verticalSpacing,
              AnnualSalesChart(bloc: _annualSalesBloc),
              verticalSpacing,
              CustomerSalesChart(bloc: _customerSalesBloc),
            ],
          ),
        ),
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
