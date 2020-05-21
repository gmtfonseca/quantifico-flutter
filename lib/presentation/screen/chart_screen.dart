import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/chart_container/chart_container_bloc.dart';
import 'package:quantifico/bloc/home_screen/home_screen_bloc.dart';
import 'package:quantifico/bloc/home_screen/home_screen_event.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';
import 'package:quantifico/presentation/shared/chart/barrel.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';
import 'package:quantifico/style.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = BlocProvider.of<InsightScreenBloc>(context);
        bloc.add(const RefreshInsightScreen());
      },
      child: BlocBuilder<InsightScreenBloc, InsightScreenState>(
        builder: (context, state) {
          return Container(
            color: AppStyle.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: _buildContent(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, InsightScreenState state) {
    if (state is InsightScreenLoaded) {
      return _buildCharts(context);
    } else if (state is InsightScreenLoading) {
      return const LoadingIndicator();
    } else {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Não foi possível carregar seus insights'),
            const SizedBox(width: 5),
            Icon(Icons.sentiment_dissatisfied),
          ],
        ),
      );
    }
  }

  Widget _buildCharts(BuildContext context) {
    const verticalSpacing = SizedBox(height: 15);
    final annualSalesBloc = BlocProvider.of<AnnualSalesBloc>(context);
    final customerSalesBloc = BlocProvider.of<CustomerSalesBloc>(context);
    final monthlySalesBloc = BlocProvider.of<MonthlySalesBloc>(context);
    final citySalesBloc = BlocProvider.of<CitySalesBloc>(context);

    final annualSalesContainerBloc = BlocProvider.of<ChartContainerBloc<AnnualSalesChart>>(context);
    final customerSalesContainerBloc = BlocProvider.of<ChartContainerBloc<CustomerSalesChart>>(context);
    final monthlySalesContainerBloc = BlocProvider.of<ChartContainerBloc<MonthlySalesChart>>(context);
    final citySalesContainerBloc = BlocProvider.of<ChartContainerBloc<CitySalesChart>>(context);

    final homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);
    final onStarOrUnstar = () => homeScreenBloc.add(const LoadHomeScreen());

    return ListView(
      children: [
        ChartContainer(
          title: 'Faturamento Anual',
          bloc: annualSalesContainerBloc,
          chart: AnnualSalesChart(
            bloc: annualSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        ),
        verticalSpacing,
        ChartContainer(
          title: 'Faturamento por Cliente',
          bloc: customerSalesContainerBloc,
          chart: CustomerSalesChart(
            bloc: customerSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        ),
        verticalSpacing,
        ChartContainer(
          title: 'Faturamento Mensal',
          bloc: monthlySalesContainerBloc,
          chart: MonthlySalesChart(
            bloc: monthlySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        ),
        verticalSpacing,
        ChartContainer(
          title: 'Faturamento por Cidade',
          bloc: citySalesContainerBloc,
          chart: CitySalesChart(
            bloc: citySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        ),
      ],
    );
  }
}
