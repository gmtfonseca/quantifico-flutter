import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';
import 'package:quantifico/bloc/tab/tab.dart';
import 'package:quantifico/data/model/tab.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/screen/home_screen.dart';
import 'package:quantifico/presentation/screen/insight_screen.dart';
import 'package:quantifico/presentation/screen/invoice_screen.dart';

import 'package:quantifico/presentation/shared/tab_selector.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  InsightScreenBloc _insightScreenBloc;
  HomeScreenBloc _homeScreenBloc;

  @override
  void didChangeDependencies() {
    final chartRepository = RepositoryProvider.of<ChartRepository>(context);
    final chartContainerRepository = RepositoryProvider.of<ChartContainerRepository>(context);
    _homeScreenBloc = HomeScreenBloc(chartContainerRepository: chartContainerRepository)..add(LoadHomeScreen());
    final annualSalesBloc = BlocProvider.of<AnnualSalesBloc>(context);
    _insightScreenBloc = InsightScreenBloc(annualSalesBloc: annualSalesBloc)..add(LoadInsightScreen());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _insightScreenBloc.close();
    _homeScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TabBloc, Tab>(
        builder: (context, activeTab) {
          return Scaffold(
            body: _buildBody(context, activeTab),
            bottomNavigationBar: _buildNavBar(context, activeTab),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Tab activeTab) {
    switch (activeTab) {
      case Tab.home:
        _homeScreenBloc.add(const LoadHomeScreen());
        return HomeScreen(bloc: _homeScreenBloc);
      case Tab.insight:
        return InsightScreen(bloc: _insightScreenBloc);
      case Tab.invoice:
        return InvoiceScreen();
      default:
        return Container();
    }
  }

  Widget _buildNavBar(BuildContext context, Tab activeTab) {
    // ignore: close_sinks
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return TabSelector(
      activeTab: activeTab,
      onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
    );
  }
}
