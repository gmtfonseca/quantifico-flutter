import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container_bloc.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';

import 'package:quantifico/data/repository/chart_container_repository.dart';
import 'package:quantifico/presentation/shared/chart/barrel.dart';
import 'package:quantifico/presentation/shared/chart/chart_container.dart';

class InsightScreen extends StatelessWidget {
  final InsightScreenBloc bloc;

  InsightScreen({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(RefreshInsightScreen());
      },
      child: BlocBuilder<InsightScreenBloc, InsightScreenState>(
          bloc: bloc,
          builder: (context, state) {
            return Container(
              color: Color(0xffe0e0e0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: _buildContent(context, state),
              ),
            );
          }),
    );
  }

  Widget _buildContent(BuildContext context, InsightScreenState state) {
    final verticalSpacing = SizedBox(height: 15);
    if (state is InsightScreenLoaded) {
      final chartContainerRepository = RepositoryProvider.of<ChartContainerRepository>(context);
      return ListView(
        children: [
          ChartContainer(
            title: 'Faturamento Anual',
            bloc: ChartContainerBloc(
              chartName: 'AnnualSalesChart',
              chartContainerRepository: chartContainerRepository,
              chartBloc: state.annualSalesBloc,
            ),
            chart: AnnualSalesChart(
              bloc: state.annualSalesBloc,
            ),
          ),
          verticalSpacing,
          ChartContainer(
            title: 'Faturamento por Cliente',
            bloc: ChartContainerBloc(
              chartName: 'CustomerSalesChart',
              chartContainerRepository: chartContainerRepository,
              chartBloc: state.customerSalesBloc,
            ),
            chart: CustomerSalesChart(
              bloc: state.customerSalesBloc,
            ),
          ),
          verticalSpacing,
          ChartContainer(
            title: 'Faturamento por Cidade',
            bloc: ChartContainerBloc(
              chartName: 'CitySalesChart',
              chartContainerRepository: chartContainerRepository,
              chartBloc: state.citySalesBloc,
            ),
            chart: CitySalesChart(
              bloc: state.citySalesBloc,
            ),
          ),
          verticalSpacing,
          ChartContainer(
            title: 'Faturamento Mensal',
            bloc: ChartContainerBloc(
              chartName: 'MonthlySalesBloc',
              chartContainerRepository: chartContainerRepository,
              chartBloc: state.monthlySalesBloc,
            ),
            chart: CustomerSalesChart(
              bloc: state.monthlySalesBloc,
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
