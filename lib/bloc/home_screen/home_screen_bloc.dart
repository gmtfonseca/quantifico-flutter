import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ChartContainerRepository chartContainerRepository;
  final Map<String, ChartBloc> chartBlocs;

  HomeScreenBloc({
    @required this.chartContainerRepository,
    @required this.chartBlocs,
  });

  @override
  HomeScreenState get initialState => HomeScreenLoading();

  @override
  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
    if (event is LoadHomeScreen) {
      yield* _mapLoadHomeScreenToState();
    }
  }

  Stream<HomeScreenState> _mapLoadHomeScreenToState() async* {
    try {
      final starredCharts = chartContainerRepository.getStarred();
      _initiStarredCharts(starredCharts);
      starredCharts.sort();
      yield HomeScreenLoaded(starredCharts: starredCharts);
    } catch (e) {
      yield HomeScreenNotLoaded();
    }
  }

  void _initiStarredCharts(List<String> starredCharts) {
    for (final chartName in starredCharts) {
      if (chartBlocs.containsKey(chartName)) {
        final chartBloc = chartBlocs[chartName];
        if (chartBloc.state is SeriesUninitialized) {
          chartBloc.add(const LoadSeries());
        }
      }
    }
  }
}
