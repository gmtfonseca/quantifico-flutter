import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/chart_container/chart_container_bloc.dart';
import 'package:quantifico/bloc/home_screen/home_screen_bloc.dart';
import 'package:quantifico/bloc/home_screen/home_screen_event.dart';
import 'package:quantifico/bloc/chart_screen/barrel.dart';
import 'package:quantifico/presentation/chart/barrel.dart';
import 'package:quantifico/presentation/chart/shared/chart_container.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';
import 'package:quantifico/style.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = BlocProvider.of<ChartScreenBloc>(context);
        bloc.add(const RefreshChartScreen());
      },
      child: BlocBuilder<ChartScreenBloc, ChartScreenState>(
        builder: (context, state) {
          return Container(
            color: AppStyle.backgroundColor,
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChartScreenState state) {
    if (state is ChartScreenLoaded) {
      return _buildCharts(context);
    } else if (state is ChartScreenLoading) {
      return const LoadingIndicator();
    } else {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Erro ao carregar gráficos'),
            const SizedBox(width: 5),
            Icon(Icons.sentiment_dissatisfied),
          ],
        ),
      );
    }
  }

  Widget _buildCharts(BuildContext context) {
    final annualSalesBloc = BlocProvider.of<AnnualSalesBloc>(context);
    final customerSalesBloc = BlocProvider.of<CustomerSalesBloc>(context);
    final monthlySalesBloc = BlocProvider.of<MonthlySalesBloc>(context);
    final citySalesBloc = BlocProvider.of<CitySalesBloc>(context);

    final annualSalesContainerBloc = BlocProvider.of<ChartContainerBloc<AnnualSalesChart>>(context);
    final customerSalesContainerBloc = BlocProvider.of<ChartContainerBloc<CustomerSalesChart>>(context);
    final monthlySalesContainerBloc = BlocProvider.of<ChartContainerBloc<MonthlySalesChart>>(context);
    final citySalesContainerBloc = BlocProvider.of<ChartContainerBloc<CitySalesChart>>(context);

    final homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);
    final onStarOrUnstar = () => homeScreenBloc.add(const UpdateStarredCharts());

    const chartVerticalSpacing = SizedBox(height: 20);
    const contextVerticalSpacing = SizedBox(height: 30);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: [
          chartVerticalSpacing,
          _buildTitle('Periódicos'),
          chartVerticalSpacing,
          ChartContainer(
            title: 'Faturamento Anual',
            bloc: annualSalesContainerBloc,
            chart: AnnualSalesChart(
              bloc: annualSalesBloc,
            ),
            onStarOrUnstar: onStarOrUnstar,
          ),
          chartVerticalSpacing,
          ChartContainer(
            title: 'Faturamento Mensal',
            bloc: monthlySalesContainerBloc,
            chart: MonthlySalesChart(
              bloc: monthlySalesBloc,
            ),
            onStarOrUnstar: onStarOrUnstar,
          ),
          contextVerticalSpacing,
          _buildTitle('Clientes'),
          chartVerticalSpacing,
          ChartContainer(
            title: 'Faturamento por Cliente',
            bloc: customerSalesContainerBloc,
            chart: CustomerSalesChart(
              bloc: customerSalesBloc,
            ),
            onStarOrUnstar: onStarOrUnstar,
          ),
          contextVerticalSpacing,
          _buildTitle('Geográficos'),
          chartVerticalSpacing,
          ChartContainer(
            title: 'Faturamento por Cidade',
            bloc: citySalesContainerBloc,
            chart: CitySalesChart(
              bloc: citySalesBloc,
            ),
            onStarOrUnstar: onStarOrUnstar,
          ),
          chartVerticalSpacing,
        ],
      ),
    );
  }

  Widget _buildTitle(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black54,
      ),
    );
  }
}
