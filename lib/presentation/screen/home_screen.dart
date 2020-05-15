import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';

import 'package:quantifico/presentation/shared/chart/barrel.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
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
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  shrinkWrap: true,
                  itemCount: state.starredCharts.length,
                  itemBuilder: (context, index) {
                    final chart = state.starredCharts[index];
                    return _chartFromName(context, chart);
                  },
                );
              } else if (state is HomeScreenLoading) {
                return const LoadingIndicator();
              } else {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não foi possível carregar seu home'),
                      const SizedBox(width: 5),
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
    final bloc = BlocProvider.of<HomeScreenBloc>(context);
    final onStarOrUnstar = () => bloc.add(const LoadHomeScreen());

    switch (chartName) {
      case 'AnnualSalesChart':
        final annualSalesContainerBloc = BlocProvider.of<ChartContainerBloc<AnnualSalesChart>>(context);
        final annualSalesBloc = BlocProvider.of<AnnualSalesBloc>(context);
        if (annualSalesBloc.state is SeriesLoading) {
          annualSalesBloc.add(const LoadSeries());
        }
        return ChartContainer(
          title: 'Faturamento Anual',
          bloc: annualSalesContainerBloc,
          chart: AnnualSalesChart(
            bloc: annualSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'CitySalesChart':
        final citySalesContainerBloc = BlocProvider.of<ChartContainerBloc<CitySalesBloc>>(context);
        final citySalesBloc = BlocProvider.of<CitySalesBloc>(context);
        if (citySalesBloc.state is SeriesLoading) {
          citySalesBloc.add(const LoadSeries());
        }
        return ChartContainer(
          title: 'Faturamento por Cidade',
          bloc: citySalesContainerBloc,
          chart: CitySalesChart(
            bloc: citySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'MonthlySalesChart':
        final monthlySalesContainerBloc = BlocProvider.of<ChartContainerBloc<MonthlySalesBloc>>(context);
        final monthlySalesBloc = BlocProvider.of<MonthlySalesBloc>(context)..add(const LoadSeries());
        if (monthlySalesBloc.state is SeriesLoading) {
          monthlySalesBloc.add(const LoadSeries());
        }
        return ChartContainer(
          title: 'Faturamento Mensal',
          bloc: monthlySalesContainerBloc,
          chart: MonthlySalesChart(
            bloc: monthlySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'CustomerSalesChart':
        final customerSalesContainerBloc = BlocProvider.of<ChartContainerBloc<CustomerSalesBloc>>(context);
        final customerSalesBloc = BlocProvider.of<CustomerSalesBloc>(context)..add(const LoadSeries());
        if (customerSalesBloc.state is SeriesLoading) {
          customerSalesBloc.add(const LoadSeries());
        }
        return ChartContainer(
          title: 'Faturamento por Cliente',
          bloc: customerSalesContainerBloc,
          chart: CustomerSalesChart(
            bloc: customerSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      default:
        return const SizedBox();
    }
  }
}
