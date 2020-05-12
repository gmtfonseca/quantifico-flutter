import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/special.dart';
import 'package:quantifico/bloc/chart_container/chart_container.dart';
import 'package:quantifico/bloc/home_screen/home_screen.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0e0e0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
            builder: (
              BuildContext context,
              HomeScreenState state,
            ) {
              if (state is HomeScreenLoaded) {
                return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    shrinkWrap: true,
                    itemCount: state.starredCharts.length,
                    itemBuilder: (context, index) {
                      final chart = state.starredCharts[index];
                      return _chartFromName(context, chart);
                    });
              } else if (state is HomeScreenLoading) {
                return LoadingIndicator();
              } else {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não foi possível carregar seu home'),
                      SizedBox(width: 5),
                      Icon(Icons.sentiment_dissatisfied),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _chartFromName(BuildContext context, String chartName) {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    // ignore: close_sinks
    final homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);

    switch (chartName) {
      case 'AnnualSalesChart':
        // ignore: close_sinks
        final containerBloc = ChartContainerBloc(chartRepository: chartRepository, homeScreenBloc: homeScreenBloc);
        return AnnualSalesChart(
          bloc: AnnualSalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
          containerBloc: containerBloc,
        );
      case 'CitySalesChart':
        return CitySalesChart(bloc: CitySalesBloc(chartRepository: chartRepository)..add(LoadSeries()));
      case 'MonthlySalesChart':
        return MonthlySalesChart(bloc: MonthlySalesBloc(chartRepository: chartRepository)..add(LoadSeries()));
      case 'CustomerSalesChart':
        return CustomerSalesChart(bloc: CustomerSalesBloc(chartRepository: chartRepository)..add(LoadSeries()));
      default:
        return SizedBox();
    }
  }
}
