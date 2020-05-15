import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/chart_container/chart_container_bloc.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';
import 'package:quantifico/presentation/shared/chart/barrel.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = BlocProvider.of<InsightScreenBloc>(context);
        bloc.add(const RefreshInsightScreen());
      },
      child: BlocBuilder<InsightScreenBloc, InsightScreenState>(builder: (context, state) {
        return Container(
          color: const Color(0xffe0e0e0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: _buildContent(context, state),
          ),
        );
      }),
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
    final customerSalesContainerBloc = BlocProvider.of<ChartContainerBloc<CustomerSalesBloc>>(context);
    final monthlySalesContainerBloc = BlocProvider.of<ChartContainerBloc<MonthlySalesBloc>>(context);
    final citySalesContainerBloc = BlocProvider.of<ChartContainerBloc<CitySalesBloc>>(context);

    return ListView(
      children: [
        ChartContainer(
          title: 'Faturamento Anual',
          bloc: annualSalesContainerBloc,
          chart: AnnualSalesChart(
            bloc: annualSalesBloc,
          ),
        ),
        verticalSpacing,
        ChartContainer(
          title: 'Faturamento por Cliente',
          bloc: customerSalesContainerBloc,
          chart: CustomerSalesChart(
            bloc: customerSalesBloc,
          ),
        ),
        verticalSpacing,
        ChartContainer(
          title: 'Faturamento Mensal',
          bloc: monthlySalesContainerBloc,
          chart: MonthlySalesChart(
            bloc: monthlySalesBloc,
          ),
        ),
        verticalSpacing,
        ChartContainer(
          title: 'Faturamento por Cidade',
          bloc: citySalesContainerBloc,
          chart: CitySalesChart(
            bloc: citySalesBloc,
          ),
        ),
      ],
    );
  }
}
