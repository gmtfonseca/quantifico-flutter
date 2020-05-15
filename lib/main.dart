import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/annual_sales_bloc.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';

import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/chart/chart_event.dart';
import 'bloc/chart/special/barrel.dart';
import 'bloc/chart_container/chart_container_bloc.dart';
import 'bloc/insight_screen/insight_screen_bloc.dart';
import 'bloc/insight_screen/insight_screen_event.dart';
import 'bloc/tab/tab.dart';
import 'data/repository/chart_container_repository.dart';
import 'presentation/shared/chart/barrel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final webClient = WebClient();
  final chartWebProvider = ChartWebProvider(webClient: webClient);
  final chartRepository = ChartRepository(chartWebProvider: chartWebProvider);
  final sharedPreferences = await SharedPreferences.getInstance();
  final chartContainerRepository = ChartContainerRepository(sharedPreferences: sharedPreferences);
  runApp(Quantifico(
    chartRepository: chartRepository,
    chartContainerRepository: chartContainerRepository,
  ));
}

class Quantifico extends StatelessWidget {
  final ChartRepository chartRepository;
  final ChartContainerRepository chartContainerRepository;

  const Quantifico({
    this.chartRepository,
    this.chartContainerRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantifico',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.deepPurple,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TabBloc>(
            create: (context) => TabBloc(),
          ),
          BlocProvider<AnnualSalesBloc>(
            create: (context) => AnnualSalesBloc(chartRepository: chartRepository),
          ),
          BlocProvider<CustomerSalesBloc>(
            create: (context) => CustomerSalesBloc(chartRepository: chartRepository),
          ),
          BlocProvider<CitySalesBloc>(
            create: (context) => CitySalesBloc(chartRepository: chartRepository),
          ),
          BlocProvider<MonthlySalesBloc>(
            create: (context) => MonthlySalesBloc(chartRepository: chartRepository),
          )
        ],
        child: Builder(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeScreenBloc>(
                create: (context) => HomeScreenBloc(chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<InsightScreenBloc>(
                create: (context) => InsightScreenBloc(
                  annualSalesBloc: BlocProvider.of<AnnualSalesBloc>(context),
                  customerSalesBloc: BlocProvider.of<CustomerSalesBloc>(context),
                  citySalesBloc: BlocProvider.of<CitySalesBloc>(context),
                  monthlySalesBloc: BlocProvider.of<MonthlySalesBloc>(context),
                )..add(const LoadInsightScreen()),
              ),
              BlocProvider<ChartContainerBloc<AnnualSalesChart>>(
                create: (context) => ChartContainerBloc<AnnualSalesChart>(
                    chartBloc: BlocProvider.of<AnnualSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<CustomerSalesBloc>>(
                create: (context) => ChartContainerBloc<CustomerSalesBloc>(
                    chartBloc: BlocProvider.of<CustomerSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<CitySalesBloc>>(
                create: (context) => ChartContainerBloc<CitySalesBloc>(
                    chartBloc: BlocProvider.of<CitySalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<MonthlySalesBloc>>(
                create: (context) => ChartContainerBloc<MonthlySalesBloc>(
                    chartBloc: BlocProvider.of<MonthlySalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              )
            ],
            child: MainScreen(),
          );
        }),
      ),
    );
  }
}
