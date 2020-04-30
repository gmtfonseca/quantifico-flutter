import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/tab/tab.dart';
import 'package:quantifico/data/model/tab.dart';
import 'package:quantifico/presentation/shared/tab_selector.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, Tab>(
      builder: (context, activeTab) {
        return Scaffold(
          body: _buildBody(context, activeTab),
          bottomNavigationBar: _buildNavBar(context, activeTab),
        );
      },
    );
  }

  _buildBody(BuildContext context, Tab activeTab) {
    switch (activeTab) {
      case Tab.home:
        return SizedBox();
      case Tab.insight:
        return SizedBox();
      case Tab.invoice:
        return SizedBox();
      default:
        return Container();
    }
  }

  _buildNavBar(BuildContext context, Tab activeTab) {
    // ignore: close_sinks
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return TabSelector(
      activeTab: activeTab,
      onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
    );
  }
}
