import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/config.dart';

import 'package:quantifico/presentation/shared/chart/barrel.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';
import 'package:quantifico/style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (
            BuildContext context,
            HomeScreenState state,
          ) {
            if (state is HomeScreenLoaded) {
              return _buildLoadedScreen(context, state);
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
    );
  }

  Widget _buildLoadedScreen(BuildContext context, HomeScreenLoaded state) {
    const titleStyle = TextStyle(
      fontSize: 18,
      color: Colors.black54,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: [
          const SizedBox(height: 15),
          const Text(
            'Resumo do mês',
            style: titleStyle,
          ),
          const SizedBox(height: 15),
          _buildInsights(),
          const SizedBox(height: 25),
          const Text(
            'Gráficos em destaque',
            style: titleStyle,
          ),
          const SizedBox(height: 15),
          _buildCharts(context, state),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildInsights() {
    return Row(
      children: [
        Expanded(
          child: _buildInsightCard(
            'Total Faturado',
            'R\$ 3.525,76',
            Colors.deepPurple,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildInsightCard(
            'N° Notas Fiscais',
            '76',
            Colors.deepOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(String label, String value, Color backgroundColor) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(BuildContext context, HomeScreenLoaded state) {
    if (state.starredCharts.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: state.starredCharts.length,
        itemBuilder: (context, index) {
          final chartName = state.starredCharts[index];
          return _buildChartFromName(context, chartName);
        },
      );
    } else {
      return Container(
        height: SizeConfig.screenHeight - 350.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Nenhum gráfico em destaque',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.sentiment_neutral,
              color: Colors.black54,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildChartFromName(BuildContext context, String chartName) {
    final bloc = BlocProvider.of<HomeScreenBloc>(context);
    final onStarOrUnstar = () => bloc.add(const LoadHomeScreen());

    switch (chartName) {
      case 'AnnualSalesChart':
        final annualSalesContainerBloc = BlocProvider.of<ChartContainerBloc<AnnualSalesChart>>(context);
        final annualSalesBloc = BlocProvider.of<AnnualSalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento Anual',
          bloc: annualSalesContainerBloc,
          chart: AnnualSalesChart(
            bloc: annualSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'CitySalesChart':
        final citySalesContainerBloc = BlocProvider.of<ChartContainerBloc<CitySalesChart>>(context);
        final citySalesBloc = BlocProvider.of<CitySalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento por Cidade',
          bloc: citySalesContainerBloc,
          chart: CitySalesChart(
            bloc: citySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'MonthlySalesChart':
        final monthlySalesContainerBloc = BlocProvider.of<ChartContainerBloc<MonthlySalesChart>>(context);
        final monthlySalesBloc = BlocProvider.of<MonthlySalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento Mensal',
          bloc: monthlySalesContainerBloc,
          chart: MonthlySalesChart(
            bloc: monthlySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'CustomerSalesChart':
        final customerSalesContainerBloc = BlocProvider.of<ChartContainerBloc<CustomerSalesChart>>(context);
        final customerSalesBloc = BlocProvider.of<CustomerSalesBloc>(context);
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
