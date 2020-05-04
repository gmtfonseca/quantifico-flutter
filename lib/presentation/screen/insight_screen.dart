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

  @override
  void didChangeDependencies() {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    _annualSalesBloc = AnnualSalesBloc(chartRepository: chartRepository);
    _customerSalesBloc = CustomerSalesBloc(chartRepository: chartRepository);
    _refreshCharts();
    super.didChangeDependencies();
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
    _annualSalesBloc.add(LoadData());
    _customerSalesBloc.add(LoadData());
  }
}
