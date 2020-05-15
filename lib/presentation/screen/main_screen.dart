import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';
import 'package:quantifico/bloc/tab/tab.dart';
import 'package:quantifico/data/model/tab.dart';

import 'package:quantifico/presentation/screen/home_screen.dart';
import 'package:quantifico/presentation/screen/insight_screen.dart';
import 'package:quantifico/presentation/screen/invoice_screen.dart';

import 'package:quantifico/presentation/shared/tab_selector.dart';

class MainScreen extends StatelessWidget {
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
        final homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);
        homeScreenBloc.add(const LoadHomeScreen());
        return const HomeScreen();
      case Tab.insight:
        return const InsightScreen();
      case Tab.invoice:
        return InvoiceScreen();
      default:
        return Container();
    }
  }

  Widget _buildNavBar(BuildContext context, Tab activeTab) {
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return TabSelector(
      activeTab: activeTab,
      onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
    );
  }
}
