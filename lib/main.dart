import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/annual_sales_bloc.dart';

import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/chart/chart_event.dart';
import 'bloc/tab/tab.dart';
import 'data/repository/chart_container_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final webClient = WebClient();
  final chartWebProvider = ChartWebProvider(webClient: webClient);
  final chartRepository = ChartRepository(chartWebProvider: chartWebProvider);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final chartContainerRepository = ChartContainerRepository(sharedPreferences: sharedPreferences);
  runApp(Quantifico(
    chartRepository: chartRepository,
    chartContainerRepository: chartContainerRepository,
  ));
}

class Quantifico extends StatelessWidget {
  final ChartRepository chartRepository;
  final ChartContainerRepository chartContainerRepository;

  Quantifico({
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
            create: (context) => AnnualSalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
          )
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ChartRepository>(create: (context) => chartRepository),
            RepositoryProvider<ChartContainerRepository>(
              create: (context) => chartContainerRepository,
            ),
          ],
          child: MainScreen(),
        ),
      ),
    );
  }
}
