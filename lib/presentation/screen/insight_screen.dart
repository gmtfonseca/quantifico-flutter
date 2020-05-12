import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/city_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/monthly_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/special.dart';
import 'package:quantifico/bloc/chart_container/chart_container.dart';
import 'package:quantifico/bloc/home_screen/home_screen.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';

class InsightScreen extends StatefulWidget {
  @override
  _InsightScreenState createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  MonthlySalesBloc _monthlySalesBloc;
  AnnualSalesBloc _annualSalesBloc;
  CustomerSalesBloc _customerSalesBloc;
  CitySalesBloc _citySalesBloc;
  List<Bloc> _charts = [];

  @override
  void didChangeDependencies() {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    _monthlySalesBloc = MonthlySalesBloc(chartRepository: chartRepository);
    _charts.add(_monthlySalesBloc);
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
    _monthlySalesBloc?.close();
    _annualSalesBloc?.close();
    _customerSalesBloc?.close();
    _citySalesBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = SizedBox(height: 15);
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    // ignore: close_sinks
    final homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {
        _refreshCharts();
      },
      child: Container(
        color: Color(0xffe0e0e0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: ListView(
            children: [
              AnnualSalesChart(
                  bloc: _annualSalesBloc,
                  containerBloc: ChartContainerBloc(
                    chartRepository: chartRepository,
                    homeScreenBloc: homeScreenBloc,
                  )),
              verticalSpacing,
              MonthlySalesChart(bloc: _monthlySalesBloc),
              verticalSpacing,
              CitySalesChart(bloc: _citySalesBloc),
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
      if (chart.state is FilterableState) {
        chart.add(UpdateFilter((chart.state as FilterableState).activeFilter));
      } else {
        chart.add(LoadSeries());
      }
    }
  }
}
