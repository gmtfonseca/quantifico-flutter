import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';
import 'package:quantifico/data/repository/nf_repository.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ChartContainerRepository chartContainerRepository;
  final NfRepository nfRepository;
  final Map<String, ChartBloc> chartBlocs;

  HomeScreenBloc({
    @required this.chartContainerRepository,
    @required this.nfRepository,
    @required this.chartBlocs,
  });

  @override
  HomeScreenState get initialState => HomeScreenLoading();

  @override
  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
    if (event is LoadHomeScreen) {
      yield* _mapLoadHomeScreenToState();
    } else if (event is RefreshHomeScreen) {
      yield* _mapRefreshHomeScreenToState();
    }
  }

  Stream<HomeScreenState> _mapLoadHomeScreenToState() async* {
    try {
      yield HomeScreenLoading();
      final starredCharts = chartContainerRepository.getStarred();
      _initiStarredCharts(starredCharts);
      starredCharts.sort();
      // Month and year were set just for testing
      final stats = await nfRepository.getStats(year: 2019, month: 5);
      yield HomeScreenLoaded(
        stats: stats,
        starredCharts: starredCharts,
      );
    } catch (e) {
      yield HomeScreenNotLoaded();
    }
  }

  Stream<HomeScreenState> _mapRefreshHomeScreenToState() async* {
    try {
      yield HomeScreenLoading();
      final starredCharts = chartContainerRepository.getStarred();
      _refreshStarredCharts(starredCharts);
      starredCharts.sort();
      // Month and year were set just for testing
      final stats = await nfRepository.getStats(year: 2019, month: 5);
      yield HomeScreenLoaded(
        stats: stats,
        starredCharts: starredCharts,
      );
    } catch (e) {
      yield HomeScreenNotLoaded();
    }
  }

  void _refreshStarredCharts(List<String> starredCharts) {
    for (final chartName in starredCharts) {
      if (chartBlocs.containsKey(chartName)) {
        final chartBloc = chartBlocs[chartName];
        chartBloc.add(const RefreshSeries());
      }
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
