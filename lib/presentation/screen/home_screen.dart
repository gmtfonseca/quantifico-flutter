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
  final HomeScreenBloc bloc;

  const HomeScreen({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0e0e0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
            bloc: bloc,
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
                  },
                );
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

    switch (chartName) {
      case 'AnnualSalesChart':
        return AnnualSalesChart(
          bloc: AnnualSalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
          containerBloc: ChartContainerBloc(chartRepository: chartRepository, homeScreenBloc: bloc)
            ..add(LoadContainer('AnnualSalesChart')),
        );
      case 'CitySalesChart':
        return CitySalesChart(
          bloc: CitySalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
          containerBloc: ChartContainerBloc(chartRepository: chartRepository, homeScreenBloc: bloc)
            ..add(LoadContainer('CitySalesChart')),
        );
      case 'MonthlySalesChart':
        return MonthlySalesChart(
          bloc: MonthlySalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
          containerBloc: ChartContainerBloc(chartRepository: chartRepository, homeScreenBloc: bloc)
            ..add(LoadContainer('MonthlySalesChart')),
        );
      case 'CustomerSalesChart':
        return CustomerSalesChart(
          bloc: CustomerSalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
          containerBloc: ChartContainerBloc(chartRepository: chartRepository, homeScreenBloc: bloc)
            ..add(LoadContainer('CustomerSalesChart')),
        );
      default:
        return SizedBox();
    }
  }
}
