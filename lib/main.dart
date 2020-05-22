import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/annual_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/product_sales_bloc.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';

import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/provider/nf_web_provider.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/data/repository/nf_repository.dart';
import 'package:quantifico/presentation/chart/product_sales_chart.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/chart/special/barrel.dart';
import 'bloc/chart_container/chart_container_bloc.dart';
import 'bloc/chart_screen/barrel.dart';
import 'bloc/nf_screen/barrel.dart';
import 'bloc/tab/tab.dart';
import 'data/repository/chart_container_repository.dart';
import 'presentation/chart/barrel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final webClient = WebClient();
  final chartWebProvider = ChartWebProvider(webClient: webClient);
  final chartRepository = ChartRepository(chartWebProvider: chartWebProvider);
  final sharedPreferences = await SharedPreferences.getInstance();
  final chartContainerRepository = ChartContainerRepository(sharedPreferences: sharedPreferences);
  final nfWebProvider = NfWebProvider(webClient: webClient);
  final nfRepository = NfRepository(nfWebProvider: nfWebProvider);
  runApp(Quantifico(
    chartRepository: chartRepository,
    chartContainerRepository: chartContainerRepository,
    nfRepository: nfRepository,
  ));
}

class Quantifico extends StatelessWidget {
  final ChartRepository chartRepository;
  final ChartContainerRepository chartContainerRepository;
  final NfRepository nfRepository;

  const Quantifico({
    this.chartRepository,
    this.chartContainerRepository,
    this.nfRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantifico',
      theme: ThemeData(
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
          ),
          BlocProvider<ProductSalesBloc>(
            create: (context) => ProductSalesBloc(chartRepository: chartRepository),
          ),
        ],
        child: Builder(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeScreenBloc>(
                create: (context) => HomeScreenBloc(
                  chartContainerRepository: chartContainerRepository,
                  nfRepository: nfRepository,
                  chartBlocs: {
                    'AnnualSalesChart': BlocProvider.of<AnnualSalesBloc>(context),
                    'CustomerSalesChart': BlocProvider.of<CustomerSalesBloc>(context),
                    'CitySalesChart': BlocProvider.of<CitySalesBloc>(context),
                    'MonthlySalesChart': BlocProvider.of<MonthlySalesBloc>(context),
                    'ProductSalesChart': BlocProvider.of<ProductSalesBloc>(context),
                  },
                )..add(const LoadHomeScreen()),
              ),
              BlocProvider<ChartScreenBloc>(
                create: (context) => ChartScreenBloc(
                  chartBlocs: [
                    BlocProvider.of<AnnualSalesBloc>(context),
                    BlocProvider.of<CustomerSalesBloc>(context),
                    BlocProvider.of<CitySalesBloc>(context),
                    BlocProvider.of<MonthlySalesBloc>(context),
                    BlocProvider.of<ProductSalesBloc>(context),
                  ],
                )..add(const LoadChartScreen()),
              ),
              BlocProvider<NfScreenBloc>(
                create: (context) => NfScreenBloc(nfRepository: nfRepository)..add(const LoadNfScreen()),
              ),
              BlocProvider<ChartContainerBloc<AnnualSalesChart>>(
                create: (context) => ChartContainerBloc<AnnualSalesChart>(
                    chartBloc: BlocProvider.of<AnnualSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<CustomerSalesChart>>(
                create: (context) => ChartContainerBloc<CustomerSalesChart>(
                    chartBloc: BlocProvider.of<CustomerSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<ProductSalesChart>>(
                create: (context) => ChartContainerBloc<ProductSalesChart>(
                    chartBloc: BlocProvider.of<ProductSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<CitySalesChart>>(
                create: (context) => ChartContainerBloc<CitySalesChart>(
                    chartBloc: BlocProvider.of<CitySalesBloc>(context),
                    chartContainerRepository: chartContainerRepository),
              ),
              BlocProvider<ChartContainerBloc<MonthlySalesChart>>(
                create: (context) => ChartContainerBloc<MonthlySalesChart>(
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
