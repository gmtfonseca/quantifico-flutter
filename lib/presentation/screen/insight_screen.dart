import 'package:flutter/material.dart';
import 'package:quantifico/bloc/chart/annual_sales_bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/shared/chart/annual_sales_chart.dart';
import 'package:quantifico/util/web_client.dart';

class InsightScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        AnnualSalesChart(
          bloc: AnnualSalesBloc(
            chartRepository: ChartRepository(
              chartWebProvider: ChartWebProvider(
                webClient: WebClient(),
              ),
            ),
          )..add(LoadData()),
        )
      ],
    );
  }
}
